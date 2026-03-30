/**
 * Saadni Cloud Functions
 *
 * Handles push notifications for:
 * 1. New job applications → notifies the service owner
 * 2. Application status changes → notifies the applicant
 * 3. New chat messages → notifies the recipient
 */

import * as admin from "firebase-admin";
import {
  onDocumentCreated,
  onDocumentUpdated,
} from "firebase-functions/v2/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {logger} from "firebase-functions/v2";

// Initialize Firebase Admin SDK
admin.initializeApp();

const db = admin.firestore();

// ============================================================
// HELPER: Send FCM push notification to a user's devices
// ============================================================

async function sendPushToUser(
  userId: string,
  notification: { title: string; body: string },
  data: Record<string, string>
): Promise<void> {
  const tokensSnapshot = await db
    .collection("users")
    .doc(userId)
    .collection("fcmTokens")
    .where("isActive", "==", true)
    .get();

  if (tokensSnapshot.empty) {
    logger.warn(`No active FCM tokens found for user: ${userId}`);
    return;
  }

  const tokens = tokensSnapshot.docs.map((doc: admin.firestore.QueryDocumentSnapshot) => doc.data().token as string);
  logger.info(`Sending push to ${tokens.length} device(s) for user: ${userId}`);

  const message: admin.messaging.MulticastMessage = {
    tokens,
    notification: {
      title: notification.title,
      body: notification.body,
    },
    data,
    apns: {
      payload: {
        aps: {
          sound: "default",
          badge: 1,
        },
      },
    },
  };

  const response = await admin.messaging().sendEachForMulticast(message);

  // Clean up invalid tokens
  if (response.failureCount > 0) {
    const failedTokens: string[] = [];
    response.responses.forEach((resp: admin.messaging.SendResponse, idx: number) => {
      if (!resp.success) {
        const errorCode = resp.error?.code;
        if (
          errorCode === "messaging/invalid-registration-token" ||
          errorCode === "messaging/registration-token-not-registered"
        ) {
          failedTokens.push(tokens[idx]);
        }
      }
    });

    for (const token of failedTokens) {
      await db
        .collection("users")
        .doc(userId)
        .collection("fcmTokens")
        .doc(token)
        .update({isActive: false});
      logger.info(`Marked invalid token as inactive: ${token.substring(0, 20)}...`);
    }
  }

  logger.info(
    `Push sent: ${response.successCount} success, ${response.failureCount} failures`
  );
}

// ============================================================
// HELPER: Write notification document to Firestore
// ============================================================

async function writeNotification(params: {
  userId: string;
  type: string;
  title: string;
  body: string;
  payload: Record<string, unknown>;
  priority: string;
  category: string;
}): Promise<void> {
  const now = admin.firestore.Timestamp.now();
  const expiresAt = admin.firestore.Timestamp.fromDate(
    new Date(Date.now() + 90 * 24 * 60 * 60 * 1000)
  );

  await db
    .collection("notifications")
    .doc(params.userId)
    .collection("messages")
    .add({
      userId: params.userId,
      type: params.type,
      title: params.title,
      body: params.body,
      payload: params.payload,
      timestamp: now,
      read: false,
      readAt: null,
      deleted: false,
      deletedAt: null,
      priority: params.priority,
      actionable: true,
      expiresAt: expiresAt,
      category: params.category,
    });

  logger.info(`Notification written for user ${params.userId}: ${params.type}`);
}

// ============================================================
// 1. ON NEW APPLICATION — Notify the service owner
// ============================================================

export const onNewApplication = onDocumentCreated(
  "applications/{applicationId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const application = snapshot.data();
    const applicationId = event.params.applicationId;
    const serviceId = application.serviceId as string;
    const applicantName = application.applicantName as string;
    const applicantId = application.applicantId as string;

    logger.info(`New application ${applicationId} from ${applicantName} for service ${serviceId}`);

    // Look up the service to find the owner
    const serviceDoc = await db.collection("services").doc(serviceId).get();
    if (!serviceDoc.exists) {
      logger.error(`Service ${serviceId} not found`);
      return;
    }

    const service = serviceDoc.data()!;
    const providerId = service.providerId as string;
    const serviceName = (service.title || service.name || "your service") as string;

    // Don't notify yourself
    if (providerId === applicantId) return;

    const title = "New Application 📩";
    const body = `${applicantName} applied to "${serviceName}"`;

    await writeNotification({
      userId: providerId,
      type: "new_application",
      title,
      body,
      payload: {
        jobId: serviceId,
        jobName: serviceName,
        applicationId,
        seekerId: applicantId,
        seekerName: applicantName,
        serviceId,
        serviceName,
      },
      priority: "high",
      category: "applications",
    });

    await sendPushToUser(providerId, {title, body}, {
      type: "new_application",
      applicationId,
      serviceId,
      applicantId,
    });
  }
);

// ============================================================
// 2. ON APPLICATION STATUS CHANGE — Notify the applicant
// ============================================================

export const onApplicationStatusChange = onDocumentUpdated(
  "applications/{applicationId}",
  async (event) => {
    const beforeData = event.data?.before.data();
    const afterData = event.data?.after.data();
    if (!beforeData || !afterData) return;

    const oldStatus = beforeData.status as string;
    const newStatus = afterData.status as string;

    if (oldStatus === newStatus) return;

    const applicationId = event.params.applicationId;
    const applicantId = afterData.applicantId as string;
    const serviceId = afterData.serviceId as string;

    logger.info(`Application ${applicationId} status: ${oldStatus} → ${newStatus}`);

    const serviceDoc = await db.collection("services").doc(serviceId).get();
    const serviceName = serviceDoc.exists
      ? ((serviceDoc.data()!.title || serviceDoc.data()!.name || "a service") as string)
      : "a service";

    if (newStatus === "accepted") {
      const title = "Application Accepted! 🎉";
      const body = `Your application for "${serviceName}" has been accepted!`;

      await writeNotification({
        userId: applicantId,
        type: "application_status",
        title,
        body,
        payload: {applicationId, serviceId, serviceName, status: "accepted"},
        priority: "high",
        category: "applications",
      });

      await sendPushToUser(applicantId, {title, body}, {
        type: "application_status", applicationId, serviceId, status: "accepted",
      });
    } else if (newStatus === "rejected") {
      const title = "Application Update";
      const body = `Your application for "${serviceName}" was not selected.`;

      await writeNotification({
        userId: applicantId,
        type: "application_status",
        title,
        body,
        payload: {applicationId, serviceId, serviceName, status: "rejected"},
        priority: "high",
        category: "applications",
      });

      await sendPushToUser(applicantId, {title, body}, {
        type: "application_status", applicationId, serviceId, status: "rejected",
      });
    } else if (newStatus === "withdrawn") {
      // Notify the service OWNER that the applicant withdrew
      const providerId = serviceDoc.exists ? serviceDoc.data()!.providerId as string : null;

      if (providerId && providerId !== applicantId) {
        const applicantName = afterData.applicantName as string;
        const title = "Application Withdrawn";
        const body = `${applicantName} withdrew their application for "${serviceName}"`;

        await writeNotification({
          userId: providerId,
          type: "application_withdrawn",
          title,
          body,
          payload: {applicationId, serviceId, serviceName, seekerId: applicantId, seekerName: applicantName},
          priority: "medium",
          category: "applications",
        });

        await sendPushToUser(providerId, {title, body}, {
          type: "application_withdrawn", applicationId, serviceId,
        });
      }
    }
  }
);

// ============================================================
// 3. ON NEW MESSAGE — Notify the other participant(s)
// ============================================================

export const onNewMessage = onDocumentCreated(
  "messages/{messageId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const message = snapshot.data();
    const senderId = message.senderId as string;
    const senderName = message.senderName as string;
    const conversationId = message.conversationId as string;
    const content = message.content as string;
    const participantIds = message.participantIds as string[];

    if (!participantIds || participantIds.length === 0) return;

    const recipientIds = participantIds.filter((id) => id !== senderId);
    const preview = content.length > 80 ? content.substring(0, 80) + "..." : content;

    for (const recipientId of recipientIds) {
      await writeNotification({
        userId: recipientId,
        type: "new_message_seeker",
        title: senderName,
        body: preview,
        payload: {conversationId, senderId, senderName, messagePreview: preview},
        priority: "high",
        category: "messages",
      });

      await sendPushToUser(recipientId, {title: senderName, body: preview}, {
        type: "new_message", conversationId, senderId, senderName,
      });
    }
  }
);

// ============================================================
// 4. ON NEW REVIEW — Notify the reviewee
// ============================================================

export const onNewReview = onDocumentCreated(
  "reviews/{reviewId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const review = snapshot.data();
    const reviewerId = review.reviewerId as string;
    const revieweeId = review.revieweeId as string;
    const reviewerRole = review.reviewerRole as string;
    const rating = review.rating as number;
    const reviewerName = (review.reviewerName as string) || "Someone";
    const serviceId = review.serviceId as string;

    if (!revieweeId || reviewerId === revieweeId) return;

    logger.info(`New review for ${revieweeId} from ${reviewerId} (${rating} stars)`);

    const title = "New Review ⭐";
    const body = `${reviewerName} left you a ${rating}-star review.`;

    // Determine the correct notification type based on who wrote the review
    const notificationType =
      reviewerRole === "provider"
        ? "review_posted_provider" // Provider reviewed seeker
        : "review_posted_seeker";  // Seeker reviewed provider

    await writeNotification({
      userId: revieweeId,
      type: notificationType,
      title,
      body,
      payload: {
        reviewId: event.params.reviewId,
        serviceId,
        reviewerId,
        reviewerName,
        rating,
      },
      priority: "high",
      category: "reviews",
    });

    await sendPushToUser(revieweeId, {title, body}, {
      type: notificationType,
      reviewId: event.params.reviewId,
      serviceId,
    });
  }
);

// ============================================================
// 5. ON NEW TRANSACTION — Notify regarding wallet activity
// ============================================================

export const onNewTransaction = onDocumentCreated(
  "transactions/{transactionId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const transaction = snapshot.data();
    const userId = transaction.userId as string;
    const amount = transaction.amount as number;
    const type = transaction.type as string; // earning, top_up, withdrawal, fee
    const serviceName = transaction.serviceName as string | undefined;

    if (!userId) return;

    logger.info(`New transaction for user ${userId}: ${type} (EGP ${amount})`);

    let title = "";
    let body = "";
    let notificationType = "";

    if (type === "earning" && amount > 0) {
      notificationType = "earning_received";
      title = "Payment Received 💰";
      body = serviceName
        ? `You earned EGP ${amount} for "${serviceName}".`
        : `You earned EGP ${amount}.`;
    } else if (type === "top_up" && amount > 0) {
      notificationType = "topup_success";
      title = "Top-Up Successful 💳";
      body = `Your wallet was topped up with EGP ${amount}.`;
    } else if (type === "withdrawal" && amount < 0) {
      notificationType = "withdrawal_processed";
      title = "Withdrawal Processed 🏦";
      body = `Your withdrawal of EGP ${Math.abs(amount)} has been processed.`;
    } else {
      // Ignore other transaction types (like fees) to avoid spam
      return;
    }

    await writeNotification({
      userId,
      type: notificationType,
      title,
      body,
      payload: {
        transactionId: event.params.transactionId,
        amount,
        transactionType: type,
      },
      priority: "high",
      category: "wallet",
    });

    await sendPushToUser(userId, {title, body}, {
      type: notificationType,
      transactionId: event.params.transactionId,
    });
  }
);

// ============================================================
// 6. ON NEW REVIEW — Update reviewee's rating atomically
// Replaces the client-side read-modify-write in ReviewsStore
// which had a race condition when concurrent reviews were submitted.
// ============================================================

export const onReviewCreated = onDocumentCreated(
  "reviews/{reviewId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const review = snapshot.data();
    const revieweeId = review.revieweeId as string;
    const rating = review.rating as number;

    if (!revieweeId || typeof rating !== "number") return;

    const userRef = db.collection("users").doc(revieweeId);

    await db.runTransaction(async (t) => {
      const userSnap = await t.get(userRef);
      if (!userSnap.exists) return;

      const data = userSnap.data()!;
      const currentRating = (data.rating as number) ?? 0;
      const totalReviews = (data.totalReviews as number) ?? 0;

      // Recalculate rolling average atomically
      const newTotal = currentRating * totalReviews + rating;
      const newCount = totalReviews + 1;
      const newAverage = newTotal / newCount;

      t.update(userRef, {
        rating: newAverage,
        totalReviews: newCount,
      });
    });

    logger.info(`Rating updated for user ${revieweeId} after new review (${rating} stars)`);
  }
);

// ============================================================
// 7. ON SERVICE STATUS CHANGE — Notify applicants if cancelled
// ============================================================

export const onServiceStatusChange = onDocumentUpdated(
  "services/{serviceId}",
  async (event) => {
    const beforeData = event.data?.before.data();
    const afterData = event.data?.after.data();
    if (!beforeData || !afterData) return;

    const oldStatus = beforeData.status as string;
    const newStatus = afterData.status as string;

    // Only proceed if the status changed to 'cancelled'
    if (oldStatus === newStatus || newStatus !== "cancelled") return;

    const serviceId = event.params.serviceId;
    const hiredApplicantId = afterData.hiredApplicantId as string | undefined;
    const serviceName = (afterData.title || afterData.name || "the service") as string;
    const providerId = afterData.providerId as string;

    // If there's a hired applicant, they need to know the job is cancelled
    if (hiredApplicantId) {
      logger.info(`Service ${serviceId} cancelled. Notifying hired applicant ${hiredApplicantId}`);

      const title = "Job Cancelled 🚫";
      const body = `The provider has cancelled "${serviceName}".`;

      await writeNotification({
        userId: hiredApplicantId,
        type: "job_cancelled",
        title,
        body,
        payload: {
          serviceId,
          serviceName,
          providerId,
          status: "cancelled",
        },
        priority: "high",
        category: "services",
      });

      await sendPushToUser(hiredApplicantId, {title, body}, {
        type: "job_cancelled",
        serviceId,
      });
    }
  }
);

// ============================================================
// 8. SCHEDULED — Delete messages older than 90 days
// Runs daily. Processes in batches of 500 (Firestore batch limit).
// Previously this was done from the client with an unbounded query —
// that approach was unsafe and would fail silently past 500 docs.
// ============================================================

export const cleanupExpiredMessages = onSchedule(
  {schedule: "every 24 hours", timeZone: "UTC"},
  async () => {
    const cutoff = new Date(Date.now() - 90 * 24 * 60 * 60 * 1000);
    const cutoffTimestamp = admin.firestore.Timestamp.fromDate(cutoff);
    let totalDeleted = 0;

    // Loop until no more expired messages remain
    while (true) {
      const snapshot = await db
        .collection("messages")
        .where("createdAt", "<", cutoffTimestamp)
        .limit(500)
        .get();

      if (snapshot.empty) break;

      const batch = db.batch();
      snapshot.docs.forEach((doc) => batch.delete(doc.ref));
      await batch.commit();

      totalDeleted += snapshot.docs.length;
      logger.info(`Deleted batch of ${snapshot.docs.length} expired messages`);

      // Stop if we got fewer than 500 — means no more remain
      if (snapshot.docs.length < 500) break;
    }

    logger.info(`cleanupExpiredMessages complete. Total deleted: ${totalDeleted}`);
  }
);
