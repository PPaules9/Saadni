# Firestore Schema Design

## Collections

### 1. `users` (Collection)
Document ID: Firebase Auth UID

```
users/{userId}
{
  email: string
  displayName: string?
  photoURL: string?
  phoneNumber: string?
  createdAt: timestamp
  lastLoginAt: timestamp
  isServiceProvider: boolean
  isJobSeeker: boolean
  totalJobsPosted: number
  totalJobsCompleted: number
  rating: number?
}
```

### 2. `services` (Collection)
Document ID: Auto-generated UUID

```
services/{serviceId}
{
  // Common fields
  id: string (matches document ID)
  title: string
  description: string
  price: number
  providerId: string (user ID)
  providerName: string?
  providerImageURL: string?
  status: string (draft, published, active, completed, cancelled)
  isFeatured: boolean
  createdAt: timestamp
  updatedAt: timestamp

  // Job type discriminator
  jobType: string ("flexibleJobs" | "shift")

  // Location
  location: {
    name: string
    latitude: number?
    longitude: number?
  }

  // Image
  image: {
    localId: string?
    remoteURL: string?
  }

  // Flexible job specific (only if jobType === "flexibleJobs")
  category: string? (FlexibleJobCategory enum)

  // Shift specific (only if jobType === "shift")
  shiftName: string?
  shiftCategory: string?
  customCategory: string?
  schedule: {
    startDate: timestamp
    startTime: timestamp
    endTime: timestamp
    isRepeated: boolean
    repeatDates: [timestamp]
  }

  // Application counts (for real-time updates)
  applicationCount: number (default: 0)
}
```

### 3. `applications` (Collection)
Document ID: Auto-generated UUID

```
applications/{applicationId}
{
  id: string (matches document ID)
  serviceId: string (reference to service)
  applicantId: string (user ID who applied)
  applicantName: string
  applicantPhotoURL: string?

  status: string ("pending", "accepted", "rejected", "withdrawn")
  appliedAt: timestamp

  // Optional fields
  coverMessage: string? (why they want the job)
  proposedPrice: number? (counter-offer)

  // Response from service provider
  responseMessage: string?
  respondedAt: timestamp?
}
```

### 4. `chats` (Collection) - Future Phase
Document ID: Composite of two user IDs (sorted alphabetically)

```
chats/{chatId}
{
  participants: [userId1, userId2]
  participantNames: {userId1: "Name", userId2: "Name"}
  lastMessage: string
  lastMessageAt: timestamp
  serviceId: string? (if chat started from a service)
  serviceTitle: string?
}
```

### 5. `messages` (Subcollection under chats) - Future Phase
```
chats/{chatId}/messages/{messageId}
{
  senderId: string
  text: string
  sentAt: timestamp
  read: boolean
}
```

## Indexes Required

### Composite Indexes
1. **services collection**:
   - Index on `status` (ascending) + `createdAt` (descending)
   - Index on `providerId` (ascending) + `createdAt` (descending)
   - Index on `jobType` (ascending) + `status` (ascending) + `createdAt` (descending)

2. **applications collection**:
   - Index on `serviceId` (ascending) + `appliedAt` (descending)
   - Index on `applicantId` (ascending) + `appliedAt` (descending)

## Security Rules (Basic - to be enhanced)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own user document
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    // Anyone authenticated can read published services
    match /services/{serviceId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null &&
                      request.resource.data.providerId == request.auth.uid;
      allow update, delete: if request.auth != null &&
                              resource.data.providerId == request.auth.uid;
    }

    // Applications
    match /applications/{applicationId} {
      allow read: if request.auth != null &&
                    (request.auth.uid == resource.data.applicantId ||
                     request.auth.uid == get(/databases/$(database)/documents/services/$(resource.data.serviceId)).data.providerId);
      allow create: if request.auth != null &&
                      request.resource.data.applicantId == request.auth.uid;
      allow update: if request.auth != null;
    }
  }
}
```

## Notes

- All timestamps are stored as Firestore Timestamp objects
- Images are stored in Firebase Storage, not Firestore (only URLs are stored)
- The `applicationCount` field on services is denormalized for real-time badge updates
- Service documents use a jobType discriminator to distinguish between FlexibleJobService and ShiftService
- Firestore indexes are created automatically when queries with multiple filters are first executed
