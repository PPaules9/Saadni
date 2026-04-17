"use strict";
/**
 * Saadni Cloud Functions
 *
 * Handles push notifications for:
 * 1. New job applications → notifies the service owner
 * 2. Application status changes → notifies the applicant
 * 3. New chat messages → notifies the recipient
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.onServiceStatusChange = exports.onNewTransaction = exports.onNewReview = exports.onNewMessage = exports.onApplicationStatusChange = exports.onNewApplication = void 0;
const admin = require("firebase-admin");
const firestore_1 = require("firebase-functions/v2/firestore");
const v2_1 = require("firebase-functions/v2");
// Initialize Firebase Admin SDK
admin.initializeApp();
const db = admin.firestore();
// ============================================================
// HELPER: Send FCM push notification to a user's devices
// ============================================================
async function sendPushToUser(userId, notification, data) {
    const tokensSnapshot = await db
        .collection("users")
        .doc(userId)
        .collection("fcmTokens")
        .where("isActive", "==", true)
        .get();
    if (tokensSnapshot.empty) {
        v2_1.logger.warn(`No active FCM tokens found for user: ${userId}`);
        return;
    }
    const tokens = tokensSnapshot.docs.map((doc) => doc.data().token);
    v2_1.logger.info(`Sending push to ${tokens.length} device(s) for user: ${userId}`);
    const message = {
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
        const failedTokens = [];
        response.responses.forEach((resp, idx) => {
            if (!resp.success) {
                const errorCode = resp.error?.code;
                if (errorCode === "messaging/invalid-registration-token" ||
                    errorCode === "messaging/registration-token-not-registered") {
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
                .update({ isActive: false });
            v2_1.logger.info(`Marked invalid token as inactive: ${token.substring(0, 20)}...`);
        }
    }
    v2_1.logger.info(`Push sent: ${response.successCount} success, ${response.failureCount} failures`);
}
// ============================================================
// HELPER: Write notification document to Firestore
// ============================================================
async function writeNotification(params) {
    const now = admin.firestore.Timestamp.now();
    const expiresAt = admin.firestore.Timestamp.fromDate(new Date(Date.now() + 90 * 24 * 60 * 60 * 1000));
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
    v2_1.logger.info(`Notification written for user ${params.userId}: ${params.type}`);
}
// ============================================================
// 1. ON NEW APPLICATION — Notify the service owner
// ============================================================
exports.onNewApplication = (0, firestore_1.onDocumentCreated)("applications/{applicationId}", async (event) => {
    const snapshot = event.data;
    if (!snapshot)
        return;
    const application = snapshot.data();
    const applicationId = event.params.applicationId;
    const serviceId = application.serviceId;
    const applicantName = application.applicantName;
    const applicantId = application.applicantId;
    v2_1.logger.info(`New application ${applicationId} from ${applicantName} for service ${serviceId}`);
    // Look up the service to find the owner
    const serviceDoc = await db.collection("services").doc(serviceId).get();
    if (!serviceDoc.exists) {
        v2_1.logger.error(`Service ${serviceId} not found`);
        return;
    }
    const service = serviceDoc.data();
    const providerId = service.providerId;
    const serviceName = (service.title || service.name || "your service");
    // Don't notify yourself
    if (providerId === applicantId)
        return;
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
    await sendPushToUser(providerId, { title, body }, {
        type: "new_application",
        applicationId,
        serviceId,
        applicantId,
    });
});
// ============================================================
// 2. ON APPLICATION STATUS CHANGE — Notify the applicant
// ============================================================
exports.onApplicationStatusChange = (0, firestore_1.onDocumentUpdated)("applications/{applicationId}", async (event) => {
    const beforeData = event.data?.before.data();
    const afterData = event.data?.after.data();
    if (!beforeData || !afterData)
        return;
    const oldStatus = beforeData.status;
    const newStatus = afterData.status;
    if (oldStatus === newStatus)
        return;
    const applicationId = event.params.applicationId;
    const applicantId = afterData.applicantId;
    const serviceId = afterData.serviceId;
    v2_1.logger.info(`Application ${applicationId} status: ${oldStatus} → ${newStatus}`);
    const serviceDoc = await db.collection("services").doc(serviceId).get();
    const serviceName = serviceDoc.exists
        ? (serviceDoc.data().title || serviceDoc.data().name || "a service")
        : "a service";
    if (newStatus === "accepted") {
        const title = "Application Accepted! 🎉";
        const body = `Your application for "${serviceName}" has been accepted!`;
        await writeNotification({
            userId: applicantId,
            type: "application_status",
            title,
            body,
            payload: { applicationId, serviceId, serviceName, status: "accepted" },
            priority: "high",
            category: "applications",
        });
        await sendPushToUser(applicantId, { title, body }, {
            type: "application_status", applicationId, serviceId, status: "accepted",
        });
    }
    else if (newStatus === "rejected") {
        const title = "Application Update";
        const body = `Your application for "${serviceName}" was not selected.`;
        await writeNotification({
            userId: applicantId,
            type: "application_status",
            title,
            body,
            payload: { applicationId, serviceId, serviceName, status: "rejected" },
            priority: "high",
            category: "applications",
        });
        await sendPushToUser(applicantId, { title, body }, {
            type: "application_status", applicationId, serviceId, status: "rejected",
        });
    }
    else if (newStatus === "withdrawn") {
        // Notify the service OWNER that the applicant withdrew
        const providerId = serviceDoc.exists ? serviceDoc.data().providerId : null;
        if (providerId && providerId !== applicantId) {
            const applicantName = afterData.applicantName;
            const title = "Application Withdrawn";
            const body = `${applicantName} withdrew their application for "${serviceName}"`;
            await writeNotification({
                userId: providerId,
                type: "application_withdrawn",
                title,
                body,
                payload: { applicationId, serviceId, serviceName, seekerId: applicantId, seekerName: applicantName },
                priority: "medium",
                category: "applications",
            });
            await sendPushToUser(providerId, { title, body }, {
                type: "application_withdrawn", applicationId, serviceId,
            });
        }
    }
});
// ============================================================
// 3. ON NEW MESSAGE — Notify the other participant(s)
// ============================================================
exports.onNewMessage = (0, firestore_1.onDocumentCreated)("messages/{messageId}", async (event) => {
    const snapshot = event.data;
    if (!snapshot)
        return;
    const message = snapshot.data();
    const senderId = message.senderId;
    const senderName = message.senderName;
    const conversationId = message.conversationId;
    const content = message.content;
    const participantIds = message.participantIds;
    if (!participantIds || participantIds.length === 0)
        return;
    const recipientIds = participantIds.filter((id) => id !== senderId);
    const preview = content.length > 80 ? content.substring(0, 80) + "..." : content;
    for (const recipientId of recipientIds) {
        await writeNotification({
            userId: recipientId,
            type: "new_message_seeker",
            title: senderName,
            body: preview,
            payload: { conversationId, senderId, senderName, messagePreview: preview },
            priority: "high",
            category: "messages",
        });
        await sendPushToUser(recipientId, { title: senderName, body: preview }, {
            type: "new_message", conversationId, senderId, senderName,
        });
    }
});
// ============================================================
// 4. ON NEW REVIEW — Notify the reviewee
// ============================================================
exports.onNewReview = (0, firestore_1.onDocumentCreated)("reviews/{reviewId}", async (event) => {
    const snapshot = event.data;
    if (!snapshot)
        return;
    const review = snapshot.data();
    const reviewerId = review.reviewerId;
    const revieweeId = review.revieweeId;
    const reviewerRole = review.reviewerRole;
    const rating = review.rating;
    const reviewerName = review.reviewerName || "Someone";
    const serviceId = review.serviceId;
    if (!revieweeId || reviewerId === revieweeId)
        return;
    v2_1.logger.info(`New review for ${revieweeId} from ${reviewerId} (${rating} stars)`);
    const title = "New Review ⭐";
    const body = `${reviewerName} left you a ${rating}-star review.`;
    // Determine the correct notification type based on who wrote the review
    const notificationType = reviewerRole === "provider"
        ? "review_posted_provider" // Provider reviewed seeker
        : "review_posted_seeker"; // Seeker reviewed provider
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
    await sendPushToUser(revieweeId, { title, body }, {
        type: notificationType,
        reviewId: event.params.reviewId,
        serviceId,
    });
});
// ============================================================
// 5. ON NEW TRANSACTION — Notify regarding wallet activity
// ============================================================
exports.onNewTransaction = (0, firestore_1.onDocumentCreated)("transactions/{transactionId}", async (event) => {
    const snapshot = event.data;
    if (!snapshot)
        return;
    const transaction = snapshot.data();
    const userId = transaction.userId;
    const amount = transaction.amount;
    const type = transaction.type; // earning, top_up, withdrawal, fee
    const serviceName = transaction.serviceName;
    if (!userId)
        return;
    v2_1.logger.info(`New transaction for user ${userId}: ${type} (EGP ${amount})`);
    let title = "";
    let body = "";
    let notificationType = "";
    if (type === "earning" && amount > 0) {
        notificationType = "earning_received";
        title = "Payment Received 💰";
        body = serviceName
            ? `You earned EGP ${amount} for "${serviceName}".`
            : `You earned EGP ${amount}.`;
    }
    else if (type === "top_up" && amount > 0) {
        notificationType = "topup_success";
        title = "Top-Up Successful 💳";
        body = `Your wallet was topped up with EGP ${amount}.`;
    }
    else if (type === "withdrawal" && amount < 0) {
        notificationType = "withdrawal_processed";
        title = "Withdrawal Processed 🏦";
        body = `Your withdrawal of EGP ${Math.abs(amount)} has been processed.`;
    }
    else {
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
    await sendPushToUser(userId, { title, body }, {
        type: notificationType,
        transactionId: event.params.transactionId,
    });
});
// ============================================================
// 6. ON SERVICE STATUS CHANGE — Notify applicants if cancelled
// ============================================================
exports.onServiceStatusChange = (0, firestore_1.onDocumentUpdated)("services/{serviceId}", async (event) => {
    const beforeData = event.data?.before.data();
    const afterData = event.data?.after.data();
    if (!beforeData || !afterData)
        return;
    const oldStatus = beforeData.status;
    const newStatus = afterData.status;
    // Only proceed if the status changed to 'cancelled'
    if (oldStatus === newStatus || newStatus !== "cancelled")
        return;
    const serviceId = event.params.serviceId;
    const hiredApplicantId = afterData.hiredApplicantId;
    const serviceName = (afterData.title || afterData.name || "the service");
    const providerId = afterData.providerId;
    // If there's a hired applicant, they need to know the job is cancelled
    if (hiredApplicantId) {
        v2_1.logger.info(`Service ${serviceId} cancelled. Notifying hired applicant ${hiredApplicantId}`);
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
        await sendPushToUser(hiredApplicantId, { title, body }, {
            type: "job_cancelled",
            serviceId,
        });
    }
});
//# sourceMappingURL=index.js.map