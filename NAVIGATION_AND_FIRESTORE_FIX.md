# Navigation Flow & Firestore Permissions Fix

## Problems Identified

### 1. ❌ Firestore Permission Error: "Failed to sync user: Missing or insufficient permissions"
**Root Cause:** Firestore security rules don't allow users to read/write their own `/users/{uid}` documents.

**Where it fails:**
- [AuthenticationManager.swift:63](Saadni/Modules/Authentication/AuthenticationManager.swift#L63) - `userCache.loadUser()` fails silently
- [FirestoreService.swift:45-58](Saadni/Modules/Firebase/FirestoreService.swift#L45-L58) - saveUser() and fetchUser() throw permission errors

**Impact:**
- User data not persisted to Firestore
- Subsequent app launches can't load user (though local cache helps)
- User info not available to other users

### 2. ❌ App Skips Onboarding & Auth, Goes Directly to RoleSelection
**Root Cause:** `hasSelectedRole` persists in UserDefaults even after signOut

**Current Flow (WRONG):**
```
1. New user signs up → authState = .authenticated ✅
2. User completes role selection → hasSelectedRole = true ✅
3. User signs out → hasSelectedRole still TRUE in UserDefaults ❌
4. Same user signs in again
5. MainView checks: hasSelectedRole=true, so skips Onboarding/Auth ❌
6. Goes directly to RoleSelection ❌
```

**Where it goes wrong:**
- [AppStateManager.swift:13-14](Saadni/App/AppStateManager.swift#L13-L14) - No reset on signOut
- [MainView.swift:22-26](Saadni/App/MainView.swift#L22-L26) - Uses stale hasSelectedRole flag

### 3. ❌ AuthenticationManager Doesn't Handle signOut State Cleanup
- When user signs out, AppState should reset both flags
- Currently only [AuthenticationManager.swift:174](Saadni/Modules/Authentication/AuthenticationManager.swift#L174) calls Auth.signOut()
- AppStateManager is unaware of logout

## Solutions

### Solution 1: Add Firestore Security Rules
**File:** Firebase Console → Firestore → Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can read/write only their own profile
    match /users/{userId} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth.uid == userId;
      allow create: if request.auth.uid == userId;
    }

    // Services - read all, write own
    match /services/{serviceId} {
      allow read: if request.auth != null;
      allow create, update, delete: if request.auth.uid == resource.data.providerId;
    }

    // Applications - read own, write own
    match /applications/{appId} {
      allow read: if request.auth.uid == resource.data.seekerId || request.auth.uid == resource.data.providerId;
      allow create: if request.auth.uid == request.resource.data.seekerId;
      allow update: if request.auth.uid == resource.data.providerId;
    }

    // Reviews - read all, write own
    match /reviews/{reviewId} {
      allow read: if request.auth != null;
      allow create: if request.auth.uid == request.resource.data.reviewerId;
      allow update, delete: if request.auth.uid == resource.data.reviewerId;
    }

    // Transactions - read own only
    match /transactions/{transactionId} {
      allow read: if request.auth.uid == resource.data.userId;
      allow create: if request.auth != null;
      allow update, delete: if false; // Admin only
    }

    // Messages
    match /conversations/{conversationId} {
      allow read, write: if request.auth.uid in resource.data.participantIds;
    }

    match /conversations/{conversationId}/messages/{messageId} {
      allow read, write: if request.auth.uid in get(/databases/$(database)/documents/conversations/$(conversationId)).data.participantIds;
    }
  }
}
```

### Solution 2: Reset AppState on SignOut
**File:** [AppStateManager.swift](Saadni/App/AppStateManager.swift)

Add method to reset both flags when user signs out:

```swift
func resetStateOnSignOut() async throws {
    hasSeenOnboarding = false
    hasSelectedRole = false
    try await saveState()
    print("🔄 AppState reset on sign out")
}
```

### Solution 3: Call Reset on SignOut
**File:** [AuthenticationManager.swift](Saadni/Modules/Authentication/AuthenticationManager.swift)

Need to pass AppStateManager to AuthenticationManager so it can reset state on signOut.

### Solution 4: Fix Navigation Logic in AppStateManager
**File:** [AppStateManager.swift](Saadni/App/AppStateManager.swift)

Add computed properties to handle the combined state:

```swift
var shouldShowOnboarding: Bool {
    // Show onboarding if:
    // 1. User is unauthenticated AND hasn't seen onboarding
    return !hasSeenOnboarding
}

var shouldShowRoleSelection: Bool {
    // Show role selection if:
    // 1. User is authenticated AND hasn't selected role
    return !hasSelectedRole
}
```

## Implementation Steps

1. **Update AppStateManager** - Add reset method and computed properties
2. **Update AuthenticationManager** - Inject AppStateManager, call reset on signOut
3. **Update AuthenticationManager.signOut()** - Call appStateManager.resetStateOnSignOut()
4. **Update MainView** - Simplify navigation logic using new computed properties
5. **Add Firestore Security Rules** - In Firebase Console
6. **Test flow:**
   - ✅ New user: Onboarding → Auth → RoleSelection → App
   - ✅ Returning user: Auth → RoleSelection → App
   - ✅ Sign out: Reset flags, back to Onboarding
   - ✅ User data saves to Firestore with permission

## Files to Modify

1. [AppStateManager.swift](Saadni/App/AppStateManager.swift) - Add reset logic
2. [AuthenticationManager.swift](Saadni/Modules/Authentication/AuthenticationManager.swift) - Inject AppState, call reset
3. [MainView.swift](Saadni/App/MainView.swift) - Simplify with computed properties (optional)
4. Firebase Console - Add security rules

## Verification Checklist

- [ ] Firestore rules added
- [ ] AppStateManager.resetStateOnSignOut() implemented
- [ ] AuthenticationManager calls reset on signOut
- [ ] New user sees: Onboarding → Auth → RoleSelection
- [ ] Returning user sees: Auth → RoleSelection
- [ ] Signing out shows Onboarding on next launch
- [ ] Firestore permissions error gone
- [ ] User data persists across app launches
