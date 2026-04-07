# 🎓 GoodShift — Master Course

> **Version:** 1.0 &nbsp;|&nbsp; **Generated:** April 7, 2026
> **For:** A junior developer working with an AI tutor (Claude) to master this codebase phase-by-phase.

---

## How to Use This Document

1. **Hand this file to your AI tutor** at the start of every session.
2. Work through **one Phase at a time**, in order.
3. For each file listed, open it in Xcode and discuss it with your tutor.
4. Complete the **Checkpoint Quiz** before advancing to the next Phase.
5. If you get stuck, your tutor has all the context needed to help.

---

## Table of Contents

| Phase | Title | Files |
|-------|-------|-------|
| 0 | [Project Overview & Architecture Map](#phase-0-project-overview--architecture-map) | — |
| 1 | [App Lifecycle & Dependency Injection](#phase-1-app-lifecycle--dependency-injection) | 5 |
| 2 | [Design System & Theming](#phase-2-design-system--theming) | 9 |
| 3 | [Core Utilities & Error Handling](#phase-3-core-utilities--error-handling) | 7 |
| 4 | [Domain Models — Data Layer](#phase-4-domain-models--data-layer) | 10 |
| 5 | [Firebase Data Access Layer](#phase-5-firebase-data-access-layer) | 4 |
| 6 | [Real-Time Stores — State Management](#phase-6-real-time-stores--state-management) | 7 |
| 7 | [Navigation & Coordinator Pattern](#phase-7-navigation--coordinator-pattern) | 5 |
| 8 | [Authentication Feature](#phase-8-authentication-feature) | 3 |
| 9 | [Onboarding Feature](#phase-9-onboarding-feature) | 4 |
| 10 | [Notifications & Push (FCM)](#phase-10-notifications--push-fcm) | 8 |
| 11 | [Feature Views — UI Layer](#phase-11-feature-views--ui-layer) | 20+ |
| 12 | [Analytics & Observability](#phase-12-analytics--observability) | 2 |
| 13 | [Testing & Mocks](#phase-13-testing--mocks) | 3 |
| 14 | [Putting It All Together](#phase-14-putting-it-all-together) | — |

---

# Phase 0: Project Overview & Architecture Map

## What Is GoodShift?

GoodShift is an **iOS gig-economy marketplace** connecting two user roles:

| Role | In-App Label | What They Do |
|------|-------------|--------------|
| **Job Seeker** | "Need Help With Something" | Browse services, apply to jobs, pay via wallet |
| **Service Provider** | "Earn Some Cash" | Post services, manage applicants, receive earnings |

A single user can **switch between roles** at any time from Profile.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Swift 6 / SwiftUI |
| Minimum Target | iOS 17 (with iOS 26 Liquid Glass availability checks) |
| Backend | Firebase (Auth, Firestore, Storage, Cloud Messaging) |
| Architecture | Observable Stores + Coordinator Pattern |
| State Management | `@Observable` (Observation framework, not Combine) |
| DI | Manual via `AppContainer` + `@Environment` |
| Analytics | Amplitude SDK |
| Notifications | Firebase Cloud Messaging (FCM) |

## Folder Structure

```
GoodShift/
├── App/                        ← Entry point, lifecycle, DI container
│   ├── GoodShiftApp.swift      ← @main
│   ├── MainView.swift          ← Root state machine
│   └── Bootstrap/
│       ├── AppContainer.swift  ← Dependency injection
│       └── AppDelegate.swift   ← Push notifications handling
│
├── Core/                       ← Shared infrastructure
│   ├── Analytics/              ← Amplitude tracking
│   ├── Design System/          ← Tokens, Colors, Buttons, TextFields
│   ├── DI/Mocks/               ← Mock implementations for testing
│   ├── Error/                  ← AppError enum, ErrorHandler
│   ├── Navigation/             ← Coordinators & NavigationDestinations
│   ├── Notifications/          ← In-app notifications (model/store/views)
│   ├── Protocols/              ← Auth/Firestore/Storage provider protocols
│   ├── Resources/              ← Assets
│   ├── AppConstants.swift      ← Compile-safe string keys
│   ├── CalendarService.swift   ← EventKit integration
│   └── StateKey.swift          ← Type-safe UserDefaults keys
│
├── Models/                     ← Domain models + Firestore stores
│   ├── Account/                ← User, UserCache, AppStateManager
│   ├── Applications/           ← JobApplication, ApplicationsStore
│   ├── Authentication/         ← AuthenticationManager
│   ├── Currency/               ← CurrencyManager
│   ├── Firebase/               ← FirestoreService, ListenerManager
│   ├── Messaging/              ← Conversation, Message, Stores
│   ├── Reviews/                ← Review, ReviewsStore
│   ├── Services/               ← JobService, ServicesStore, ServiceValidator
│   └── Wallet/                 ← Transaction, WalletStore
│
├── Features/                   ← Feature-specific views & logic
│   ├── Authentication/
│   ├── Chat/ & ChatViews/
│   ├── CreateJobSheet/
│   ├── Dashboard/
│   ├── FilteredServices/
│   ├── JobCompletion/
│   ├── LaunchScreen/
│   ├── Onboarding/
│   ├── Profile/
│   ├── Reviews/
│   ├── Role Selection/
│   ├── Search/
│   ├── ServiceDetail/
│   ├── ServiceManagement/
│   └── WalletView/
│
└── MainViews/                  ← Tab-level views
    ├── ChatView.swift
    ├── ProfileView.swift
    ├── ProviderViews/          ← HomeView, myJobs, CreateJobSheet, JobProvider
    └── StudentViews/           ← DashboardView, BrowseJobs, AppliedJobsView
```

## Data Flow Diagram

```
┌──────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  SwiftUI     │     │  @Observable     │     │  Firestore      │
│  Views       │◄────│  Stores          │◄────│  Listeners      │
│              │     │                  │     │  (Real-time)    │
│ @Environment │     │ - ServicesStore   │     │                 │
│ injection    │     │ - ApplicationsStore│    │ Collections:    │
│              │     │ - ConversationsStore│   │  users          │
│              │     │ - MessagesStore   │     │  services       │
│              │     │ - WalletStore     │     │  applications   │
│              │     │ - ReviewsStore    │     │  conversations  │
│              │     │ - NotificationsStore│   │  reviews        │
│              │     │                  │     │  transactions   │
└──────┬───────┘     └──────────────────┘     │  notifications  │
       │                                      └─────────────────┘
       │             ┌──────────────────┐
       └────────────►│  Coordinators    │
                     │  (Navigation)    │
                     │ - AppCoordinator │
                     │ - JobSeekerCoord │
                     │ - ServiceProvCoord│
                     └──────────────────┘
```

### Checkpoint Quiz — Phase 0
- [ ] What two user roles exist in GoodShift?
- [ ] Name 3 Firestore collections used by the app.
- [ ] What is the difference between a "Store" and a "Coordinator" in this architecture?

---

# Phase 1: App Lifecycle & Dependency Injection

> **Goal:** Understand exactly what happens from cold launch to the first pixel on screen.

## Files to Study (in order)

### 1.1 `App/GoodShiftApp.swift`
**Path:** `GoodShift/App/GoodShiftApp.swift`

**ELI5:** This is the "front door" of the app. When a user taps the icon, iOS calls `@main` on this struct, which configures Firebase and injects every dependency into the SwiftUI environment.

**Expert Concepts:**
- `@main` attribute — the entry point that replaces `UIApplicationMain`
- `@UIApplicationDelegateAdaptor` — bridges UIKit's `AppDelegate` into SwiftUI lifecycle
- **Environment injection** — every `@Observable` store is created here and passed via `.environment()`
- `FirebaseApp.configure()` runs in `init()` — before any view renders

**Key Code Pattern:**
```swift
@main
struct GoodShiftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    // All stores and managers are instantiated here
    @State private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(container.authManager)
                .environment(container.servicesStore)
                // ... all other stores
        }
    }
}
```

**Things to Notice:**
- The `AppContainer` is the single source of truth for all dependencies
- No singletons are used for stores — everything flows through `@Environment`
- `FirebaseApp.configure()` **must** be called before any Firebase API

---

### 1.2 `App/Bootstrap/AppContainer.swift`
**Path:** `GoodShift/App/Bootstrap/AppContainer.swift`

**ELI5:** Think of `AppContainer` as a toolbox. Before the builder (the app) starts work, the toolbox loads every tool (store, manager) it needs. When a user logs in, it opens all tools in parallel. When they log out, it cleans them all up.

**Expert Concepts:**
- `@Observable` class — drives SwiftUI reactivity without Combine
- `TaskGroup` — parallel async initialization of all stores on login
- **Session lifecycle** — `setupUserSession(userId:)` / `teardownUserSession()`
- Stores are properties, not singletons, enabling testability

**Critical Method — `setupUserSession`:**
```swift
func setupUserSession(userId: String) async {
    await withTaskGroup(of: Void.self) { group in
        group.addTask { try? await self.servicesStore.setupListeners(userId: userId) }
        group.addTask { try? await self.applicationsStore.setupListeners(userId: userId) }
        group.addTask { try? await self.conversationsStore.setupListeners(userId: userId) }
        group.addTask { try? await self.walletStore.setupListeners(userId: userId) }
        group.addTask { await self.notificationsStore.setupListeners(userId: userId) }
        group.addTask { try? await self.reviewsStore.setupListeners(userId: userId) }
    }
}
```
All 6 listeners start **concurrently** — not sequentially.

**`teardownUserSession`:** Calls `removeAllListeners()` on every store, clearing all data and Firestore subscriptions.

---

### 1.3 `App/MainView.swift`
**Path:** `GoodShift/App/MainView.swift`

**ELI5:** This is the traffic light. It looks at the user's state and decides which screen to show: "Are they logged in? Have they finished onboarding? What role are they?"

**State Machine:**
```
                 ┌─ Not Authenticated ──► AuthenticationView
                 │
User arrives ────┤─ Authenticated + No Onboarding ──► OnboardingView
                 │
                 ├─ Authenticated + No Role ──► RoleSelectionView
                 │
                 └─ Authenticated + Role Set ──► TabView (Dashboard/Home)
```

**Key Pattern — Conditional View Rendering:**
```swift
var body: some View {
    Group {
        switch authManager.authState {
        case .signedOut:     AuthenticationView()
        case .signedIn:      authenticatedContent
        }
    }
}
```

---

### 1.4 `App/Bootstrap/AppDelegate.swift`
**Path:** `GoodShift/App/Bootstrap/AppDelegate.swift`

**ELI5:** The mailman. Whenever iOS receives a push notification, it delivers it here. This file unwraps the notification, figures out what type it is, and tells the app where to navigate.

**Expert Concepts:**
- `UNUserNotificationCenterDelegate` — handles foreground + tapped notifications
- `MessagingDelegate` — receives FCM token updates
- Notification payload parsing → maps to `NotificationType` enum
- Deep-link routing via `AppCoordinator`

---

### 1.5 `Models/Account/AppStateManager.swift`
**What It Does:** Tracks lightweight app-level state like `hasSeenOnboarding` via `@AppStorage`, keeping it separate from user data.

---

### Checkpoint Quiz — Phase 1
- [ ] What does `@UIApplicationDelegateAdaptor` do?
- [ ] Why does `setupUserSession` use a `TaskGroup` instead of sequential `await` calls?
- [ ] Draw the state machine in `MainView` — what are the 4 possible screens?
- [ ] What happens to all listeners when a user signs out?

---

# Phase 2: Design System & Theming

> **Goal:** Learn the 4-layer color system and reusable UI components.

## Architecture: Tokens → Semantics → Palette → Provider

```
ColorToken (raw hex)
    ↓
SemanticColor (role-based name)
    ↓
ColorPalette (maps semantic → token per light/dark)
    ↓
Colors.swiftUIColor(.semantic) (final SwiftUI Color)
```

## Files to Study

### 2.1 `Core/Design System/Colors/Tokens.swift`
- **`ColorToken` enum** — raw hex values: `.primary → "#37857D"`, `.backgroundLight → "#E8F2EE"`, etc.
- Includes `Color(hex:)` extension for SwiftUI
- Has a preview view (`ColorTokensPreview`) to visually inspect all tokens

### 2.2 `Core/Design System/Colors/Semantic Colors.swift`
- **`SemanticColor` enum** — role names: `.appBackground`, `.cardBackground`, `.textMain`, `.primary`, `.selectionHighlight`, `.successGreen`
- **Rule:** Feature/UI code should ONLY reference `SemanticColor`, never `ColorToken` directly

### 2.3 `Core/Design System/Colors/Colors Themes.swift`
- **`ColorPalette`** — maps `(SemanticColor, isDarkMode)` → `ColorToken`
- Example: `.appBackground` → `.backgroundLight` (light) / `.backgroundDark` (dark)
- **`ColorTheme` enum** — currently just `.default`, extensible for future themes

### 2.4 `Core/Design System/Colors/Provider.swift`
- **`DefaultColorProviderSwiftUI`** — uses `UIColor(dynamicProvider:)` for automatic light/dark switching
- **`Colors.swiftUIColor(_:)`** — the final API every view uses:
```swift
Text("Hello")
    .foregroundStyle(Colors.swiftUIColor(.textMain))
    .background(Colors.swiftUIColor(.appBackground))
```

### 2.5 `Core/Design System/Buttons/DesignSystemButtons.swift`
- **`BrandButton`** — the app's primary button component
- Supports: `ButtonSize` (.small/.medium/.large), primary/secondary variants, optional icon
- Uses `.glassEffect(.regular)` on iOS 26+ with graceful fallback

### 2.6 `Core/Design System/TextField/` (6 files)
| File | Component | Purpose |
|------|-----------|---------|
| `BrandTextField.swift` | `BrandTextField` | Standard text input |
| `BrandPasswordField.swift` | `BrandPasswordField` | Secure field with toggle visibility |
| `BrandSearchField.swift` | `BrandSearchField` | Search-specific input |
| `BrandNumericalField.swift` | `BrandNumericalField` | Number-only input |
| `BrandTextEditor.swift` | `BrandTextEditor` | Multi-line text area |
| `InputState.swift` | `InputState` enum | `.normal`, `.error`, `.success` states |

### 2.7 `Core/Design System/Components/` (24+ files)
Reusable UI components built from the design system:

| Component | Purpose |
|-----------|---------|
| `ServiceCard` | Card displaying a job service |
| `ServiceCardSkeleton` | Loading placeholder |
| `MessageBubble` | Chat message bubble |
| `ReviewCard` | User review display |
| `ApplicantCard` | Applicant info card |
| `ApplicationBadge` | Status badge for applications |
| `ErrorStateView` | Reusable error display |
| `LoadingStateView` | Reusable loading spinner |
| `ConfettiView` | Celebration animation |
| `StarRatingPicker` | Interactive star rating |
| `TypingIndicatorView` | Chat typing dots animation |

### Checkpoint Quiz — Phase 2
- [ ] Why does the app use `SemanticColor` instead of referencing hex values directly in views?
- [ ] What Swift API makes colors automatically adapt to light/dark mode in this design system?
- [ ] What is the `.glassEffect` modifier and why is there an `@available` check?

---

# Phase 3: Core Utilities & Error Handling

> **Goal:** Understand the shared infrastructure that every feature depends on.

### 3.1 `Core/AppConstants.swift`
**Pattern: Compile-Safe String Keys**
```swift
enum AppConstants {
    enum Firestore {
        static let users = "users"          // Never inline "users" — a typo here
        static let services = "services"    // is a BUILD error, not a silent bug
    }
    enum Storage {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
}
```
**Why:** A typo in a string literal silently reads `nil`; a typo in a constant is a **compile error**.

### 3.2 `Core/Error/AppError.swift`
- **`AppError` enum** — 5 cases: `.authentication`, `.network`, `.firestore`, `.validation`, `.unknown`
- Conforms to `LocalizedError` (user-facing messages) + `Identifiable` (SwiftUI alerts)
- **Factory method:** `AppError.from(_ error: Error)` — auto-classifies any error by its domain

### 3.3 `Core/Error/ErrorHandler.swift`
- **`ErrorHandler`** — `@Observable` class injected via environment
- Provides `handle(_:retryAction:)` and `dismiss()` for consistent error UX
- Supports optional retry closures for recoverable errors

### 3.4 `Core/StateKey.swift`
- **Generic `StateKey<T>`** — type-safe wrapper for `UserDefaults` / `@AppStorage` keys
- Prevents key typos: `StateKeys.hasSeenOnboarding` instead of raw strings

### 3.5 `Core/CalendarService.swift`
- Singleton (`CalendarService.shared`) for adding job events to the user's iOS calendar
- Uses `EventKit` with proper permission handling (iOS 17+ `requestWriteOnlyAccessToEvents`)
- Custom `CalendarError.accessDenied` error type

### 3.6 `Core/Protocols/` (3 files)
**Protocol-Oriented Design for Testability:**

| Protocol | Defines | Implemented By |
|----------|---------|---------------|
| `AuthProvider` | `signUp`, `signIn`, `signOut`, state properties | `AuthenticationManager` |
| `FirestoreProvider` | CRUD for User, Service, Application, Review, Transaction | `FirestoreService` |
| `StorageProvider` | Image upload operations | `StorageService` |

**Why protocols?** → Enables `MockFirestoreService` and `MockStorageService` in `Core/DI/Mocks/`

### 3.7 `Core/DI/Mocks/`
- `MockFirestoreService.swift` — in-memory implementation of `FirestoreProvider`
- `MockStorageService.swift` — returns fake URLs for image uploads
- Used for Xcode Previews and unit tests

### Checkpoint Quiz — Phase 3
- [ ] Why is `AppError` both `LocalizedError` and `Identifiable`?
- [ ] What does `AppError.from(_ error: Error)` do and why is it useful?
- [ ] How does the Protocol → Mock pattern improve testability?

---

# Phase 4: Domain Models — Data Layer

> **Goal:** Understand every data structure the app works with.

### 4.1 `Models/Account/User.swift` ⭐ (Most Important Model)
**Fields:**
```swift
struct User: Codable, Identifiable, Hashable {
    var id: String               // Firebase UID
    var email: String
    var displayName: String?
    var photoURL: String?
    var isJobSeeker: Bool        // ← Dual-role support
    var isServiceProvider: Bool  // ← Toggle via Profile
    var walletBalance: Double
    var averageRating: Double
    var totalReviews: Int
    // ... addresses, skills, categories, etc.
}
```

**Key Concepts:**
- **Dual-role model:** A single user has both `isJobSeeker` and `isServiceProvider` flags
- **Profile completion logic:** `getCompletionPercentage(forRole:)` calculates per-role completeness
- **Firestore mapping:** `toFirestore()` / `User.fromFirestore(id:data:)` for manual Codable bridging
- **Denormalization:** Fields like `averageRating` and `totalReviews` are stored directly on the user document to avoid expensive queries

### 4.2 `Models/Services/JobService.swift`
**The central marketplace entity.** A job/service posted by a provider.

| Field | Type | Purpose |
|-------|------|---------|
| `id` | String | Firestore document ID |
| `providerId` | String | Who posted it |
| `title`, `description` | String | Display info |
| `category` | `ServiceCategoryType` | Cleaning, Tutoring, etc. |
| `status` | `ServiceStatus` | `.draft` → `.published` → `.inProgress` → `.completed` |
| `price` | Double | Cost in local currency |
| `serviceDates` | [Date] | When the job occurs |
| `location` | embedded | City, area, coordinates |
| `imageURLs` | [String] | Firebase Storage URLs |

**Lifecycle:** `draft → published → inProgress → completed` (never skips a step)

### 4.3 `Models/Services/ServiceValidator.swift`
- Static validation methods: `canPublish(_:)`, `canCreateEarning(amount:forServiceWithId:)`
- Enforces business rules before Firestore writes

### 4.4 `Models/Applications/JobApplication.swift`
**Connects a seeker to a service.**

| Field | Purpose |
|-------|---------|
| `seekerId` | Who applied |
| `serviceId` | Which job |
| `status` | `.pending` → `.accepted` / `.rejected` / `.withdrawn` |
| `appliedAt` | Timestamp |
| `message` | Cover note |

### 4.5 `Models/Messaging/Conversation.swift` & `Message.swift`
- **Conversation:** Links two participants, tracks `lastMessage`, `lastMessageTime`, `isPinned`
- **Message:** Individual chat messages with `senderId`, `text`, `timestamp`, `isRead`
- **TypingIndicator:** Separate Firestore subcollection for real-time "is typing" dots

### 4.6 `Models/Reviews/Review.swift`
**Bidirectional review system:**
- `reviewerRole: .provider | .seeker` — both sides can review each other
- `reviewerId` / `revieweeId` — who reviewed whom
- Denormalized fields: `reviewerName`, `serviceName` (avoids extra queries)

### 4.7 `Models/Wallet/Transaction.swift`
**4 transaction types:**
| Type | Sign | Example |
|------|------|---------|
| `.earning` | + | Payment for completed job |
| `.topUp` | + | User added funds |
| `.withdrawal` | − | Cash out to bank |
| `.fee` | − | Platform commission |

### 4.8 `Models/Currency/CurrencyManager.swift`
- Manages `Currency.current` (symbol, code)
- Persisted via `@AppStorage("appCurrency")`

### 4.9 `Core/Notifications/Models/Notification.swift`
- Rich notification model with `NotificationPayload` containing contextual data (jobId, applicationId, conversationId, amount, etc.)
- `isExpired` computed property (90-day TTL)
- `timeAgo` computed property for display

### 4.10 `Core/Notifications/Models/NotificationType.swift`
- **20 notification types** split by role (Job Seeker vs Provider)
- Each type has: `displayName`, `category`, `priority`, `isActionable`
- 7 categories: applications, messages, jobs, reviews, earnings, matching, ratings

### Checkpoint Quiz — Phase 4
- [ ] How does the app support a user being both a job seeker and a service provider?
- [ ] What are the 4 stages of `ServiceStatus`?
- [ ] Why does `Review` store `reviewerName` directly instead of just `reviewerId`?
- [ ] What does `NotificationPayload` contain and why?

---

# Phase 5: Firebase Data Access Layer

> **Goal:** Understand how the app reads/writes to Firestore.

### 5.1 `Models/Firebase/FirestoreService.swift` ⭐
**The central data access layer.** A singleton that wraps all Firestore operations.

**Pattern: Manual Codable Bridge**
```swift
// Instead of Firestore's automatic Codable (which has quirks),
// every model defines toFirestore() / fromFirestore() methods.
func saveService(_ service: JobService) async throws {
    try await db.collection("services").document(service.id)
        .setData(service.toFirestore())
}
```

**Collections managed:**
| Collection | Document Type |
|------------|--------------|
| `users` | User profiles |
| `services` | Job service listings |
| `applications` | Job applications |
| `reviews` | User reviews |
| `transactions` | Wallet transactions |
| `conversations` | Chat conversations (subcollection: `messages`) |
| `notifications/{userId}/messages` | Per-user notifications |

**Critical method — `deleteUserData(userId:)`:**
Cascading deletion across ALL collections when a user deletes their account.

### 5.2 `Models/Firebase/ListenerManager.swift` ⭐
**Protocol: `ListenerManaging`**
```swift
protocol ListenerManaging: AnyObject {
    var activeListeners: [String: ListenerRegistration] { get set }
    var listenerSetupState: [String: Bool] { get set }
    func removeAllListeners()
}
```

**Default implementations:**
- `addListener(id:listener:)` — registers and tracks
- `isListenerActive(id:)` — prevents duplicate listeners
- `removeAllListeners()` — cleans up on logout

**Every store** (`ServicesStore`, `ApplicationsStore`, `WalletStore`, etc.) conforms to this protocol. This is the **single most important architectural pattern** in the app — it prevents memory leaks and ensures clean session resets.

### 5.3 `Core/Notifications/Services/FCMService.swift`
- `MessagingDelegate` — receives FCM token from Firebase
- Stores token in `users/{userId}/fcmTokens/{token}` subcollection
- Includes device metadata (platform, appVersion, osVersion, deviceModel)

### 5.4 `Core/Notifications/Environment/NotificationsStoreKey.swift`
- `EnvironmentKey` for injecting `NotificationsStore` via SwiftUI's `@Environment`

### Checkpoint Quiz — Phase 5
- [ ] Why does the app use manual `toFirestore()` / `fromFirestore()` instead of automatic Codable?
- [ ] What does the `ListenerManaging` protocol guarantee?
- [ ] What happens if `removeAllListeners()` is NOT called on logout?

---

# Phase 6: Real-Time Stores — State Management

> **Goal:** Understand how each store manages state, listeners, and reacts to real-time data.

### Common Pattern (All Stores)
```swift
@Observable
class SomeStore: ListenerManaging {
    // Protocol requirements
    var activeListeners: [String: ListenerRegistration] = [:]
    var listenerSetupState: [String: Bool] = [:]

    // State
    var items: [Item] = []
    var isLoading: Bool = false
    var error: AppError? = nil

    // Lifecycle
    func setupListeners(userId: String) async throws { ... }
    func removeAllListeners() { ... }

    deinit { removeAllListeners() }
}
```

### 6.1 `Models/Services/ServicesStore.swift`
- **Paginated fetching** for browse views (load more on scroll)
- Manages service lifecycle: publish, pause, resume, complete
- `bulkUpdateSharedFields(for:fields:)` — efficient batch Firestore updates
- Dual data: `myServices` (current user's) vs paginated browse services

### 6.2 `Models/Applications/ApplicationsStore.swift`
- Two Firestore listeners: one for "applications I sent" (seeker), one for "applications to my services" (provider)
- `acceptApplication(_:)` — orchestrates: accept one → reject all others → update service status to `.inProgress`
- Status transitions: `.pending` → `.accepted` / `.rejected` / `.withdrawn`

### 6.3 `Models/Messaging/ConversationsStore.swift`
- Listener on `conversations` where `participantIds` contains current user
- Sorted by `lastMessageTime` (descending), with pinned conversations first
- `searchConversations(_:)` — client-side text search
- `pinConversation(_:isPinned:)` — toggle pin state

### 6.4 `Models/Messaging/MessagesStore.swift`
- Per-conversation listener (only active when user is in chat view)
- **Pagination:** `loadMoreMessages()` fetches older messages
- **Typing indicators:** Reads/writes `typing/{conversationId}/{userId}` subcollection
- Marks messages as read on view appearance

### 6.5 `Models/Wallet/WalletStore.swift`
- **Two listeners:** transactions list + user's `walletBalance` field
- Balance is the **authoritative source** (stored on User document, updated with `FieldValue.increment`)
- `createEarningTransaction`, `createWithdrawal`, `createTopUp` — typed factory methods

### 6.6 `Models/Reviews/ReviewsStore.swift`
- Tracks both "reviews I wrote" and "reviews I received"
- Used by `DashboardViewModel` for average rating calculation

### 6.7 `Core/Notifications/Stores/NotificationsStore.swift`
- Listener on `notifications/{userId}/messages` (subcollection pattern)
- Filters out `deleted` and `isExpired` notifications client-side
- Preferences listener on `users/{userId}/notificationPreferences/settings`
- `unreadCount(for role:)` — role-specific badge counts
- Search, filter by category/priority

### Checkpoint Quiz — Phase 6
- [ ] Why does `ApplicationsStore.acceptApplication` reject all other pending applications?
- [ ] How does `WalletStore` keep the balance in sync (hint: `FieldValue.increment`)?
- [ ] Why does `MessagesStore` use a separate listener per conversation instead of one global listener?
- [ ] What is the "subcollection pattern" used by `NotificationsStore`?

---

# Phase 7: Navigation & Coordinator Pattern

> **Goal:** Master the app's navigation architecture — tabs, stacks, sheets, and deep links.

### 7.1 `Core/Navigation/AppCoordinator.swift`
**The root navigation hub.** Manages:
- Which role-specific coordinator is active (JobSeeker vs ServiceProvider)
- Role switching logic (`switchUserRole(to:)`)
- Cross-role navigation (e.g., deep-linking from a push notification)
- `navigateToChat(conversationId:)` — handles deep-link into chat from any context

### 7.2 `Core/Navigation/JobSeekerCoordinator.swift`
**Tabs:** Dashboard | Chat | My Jobs | Profile

```swift
@Observable
final class JobSeekerCoordinator {
    var selectedTab: JobSeekerTab = .dashboard

    // One NavigationPath per tab (independent stacks)
    var dashboardPath = NavigationPath()
    var chatPath = NavigationPath()
    var myJobsPath = NavigationPath()
    var profilePath = NavigationPath()

    // Sheet stack for modal layering
    var sheetStack: [SheetDestination] = []
}
```

**Key insight:** Each tab has its **own** `NavigationPath`, so pushing a view in Dashboard doesn't affect Chat's back stack.

### 7.3 `Core/Navigation/ServiceProviderCoordinator.swift`
**Tabs:** Home | Chat | Jobs | Search | Profile

Same pattern as `JobSeekerCoordinator` but with 5 tabs instead of 4.

### 7.4 `Core/Navigation/NavigationDestinations.swift`
**The type-safe route definitions:**

| Type | Purpose |
|------|---------|
| `JobSeekerDestination` | Push destinations: `.serviceDetail`, `.categoryDetail`, `.chatDetail` |
| `ServiceProviderDestination` | Push destinations: `.serviceDetail`, `.applicationsList`, `.createJob`, etc. |
| `SheetDestination` | Modal sheets: `.walletSheet`, `.notificationDrawer`, `.applyToService`, etc. |
| `ServiceTimeFilter` | Date-range filters: `.thisWeek`, `.tomorrow`, `.byDate`, `.byTag` |
| `JobSeekerTab` / `ServiceProviderTab` | Tab bar enums |

### 7.5 Navigation Wiring (in Feature views)
```swift
// Push navigation
coordinator.navigate(to: .serviceDetail(service))

// Present sheet
coordinator.presentSheet(.walletSheet)

// Cross-tab navigation
coordinator.selectTabAndNavigate(to: .chat, destination: .chatDetail(conversationId: id))
```

### Checkpoint Quiz — Phase 7
- [ ] Why does each tab have its own `NavigationPath`?
- [ ] What is the `sheetStack` pattern and why is it an array (not a single optional)?
- [ ] How does `selectTabAndNavigate` work for cross-tab deep linking?

---

# Phase 8: Authentication Feature

> **Goal:** Understand the full auth flow from sign-up to session management.

### 8.1 `Models/Authentication/AuthenticationManager.swift`
**Core responsibilities:**
- Firebase Auth state listener (`Auth.auth().addStateDidChangeListener`)
- `signUp(email:password:fullName:)` → creates Firebase user → creates Firestore user document
- `signIn`, `signInAnonymously`, `signOut`
- `deleteAccount()` → calls `FirestoreService.deleteUserData()` → deletes Auth user
- Publishes `authState: .signedOut | .signedIn`
- Caches `currentUser: User?` locally via `UserCache`

### 8.2 `Models/Account/UserCache.swift`
- `@Observable` class that holds the current `User` in memory
- Syncs changes back to Firestore via `updateUser(_:)`
- Prevents redundant Firestore reads when user data hasn't changed

### 8.3 `Features/Authentication/AuthenticationView.swift`
- SwiftUI view with email/password fields using `BrandTextField` and `BrandPasswordField`
- Toggle between Sign In / Sign Up modes
- Error handling via `AppError` alerts

### Checkpoint Quiz — Phase 8
- [ ] What happens to Firestore data when `deleteAccount()` is called?
- [ ] Why does the app use a `UserCache` instead of always reading from Firestore?
- [ ] What triggers `MainView` to switch from `AuthenticationView` to the main content?

---

# Phase 9: Onboarding Feature

> **Goal:** Understand the dual-path onboarding funnel.

### 9.1 `Features/Onboarding/OnboardingState.swift`
**Two paths based on role selection:**

| Path A (Job Seeker) — 12 screens | Path B (Provider) — 10 screens |
|---|---|
| welcome → roleSplit → goal → painPoints → socialProof → tinderCards → solution → categoryPrefs → locationPerm → processing → demo → notifPerm → paywall → account | welcome → roleSplit → goal → painPoints → socialProof → solution → comparison → processing → demo → notifPerm → paywall → account |

**State tracked:**
- `pathA_categories: Set<ServiceCategoryType>` — preferred job categories
- `pathA_savedShiftIds: Set<String>` — demo shifts the user "saved" (Tinder-card interaction)
- `pathB_categories`, `pathB_painPoints`

### 9.2 `Features/Onboarding/OnboardingView.swift`
- A `NavigationStack` with programmatic navigation (no back-button overrides)
- Progress bar calculated per-path via `OnboardingScreen.progressValue(for:)`
- Analytics tracked at every step via `AnalyticsService.track(.onboardingStepViewed(...))`

### 9.3 `Features/Onboarding/PathA/` & `PathB/`
- Individual screen views for each onboarding step
- Reusable shared components in `Features/Onboarding/Shared/`

### 9.4 Analytics Integration
Every onboarding action fires an event:
```swift
AnalyticsService.shared.track(.onboardingRoleSelected(role: "jobSeeker"))
AnalyticsService.shared.track(.onboardingCardSwiped(index: 3, agreed: true))
AnalyticsService.shared.track(.onboardingCategoriesSelected(categories: [...], role: "provider"))
```

### Checkpoint Quiz — Phase 9
- [ ] How many onboarding screens does a Job Seeker see vs a Service Provider?
- [ ] What is the "Tinder cards" step and how does it relate to `pathA_savedShiftIds`?
- [ ] What analytics events fire during onboarding?

---

# Phase 10: Notifications & Push (FCM)

> **Goal:** Understand the full notification pipeline — from push delivery to in-app display.

### Pipeline
```
Cloud Function sends FCM push
    ↓
iOS delivers to AppDelegate
    ↓
AppDelegate parses NotificationType
    ↓
AppCoordinator deep-links to relevant screen
    ↓
NotificationsStore updates in-app badge
    ↓
NotificationDrawerView shows notification list
```

### Files

| File | Purpose |
|------|---------|
| `Models/Notification.swift` | Data model with payload, expiry, read state |
| `Models/NotificationType.swift` | 20 types, 7 categories, 3 priority levels |
| `Models/NotificationPreferences.swift` | Per-category enable/disable settings |
| `Services/FCMService.swift` | Token management, permission requests |
| `Stores/NotificationsStore.swift` | Real-time listener, mark read, delete |
| `Views/NotificationDrawerView.swift` | Sheet showing notification list |
| `Views/NotificationCardView.swift` | Individual notification cell |
| `Views/NotificationBadgeView.swift` | Badge overlay component |

### Checkpoint Quiz — Phase 10
- [ ] Where does the FCM token get stored in Firestore?
- [ ] How does a push notification result in the app navigating to the right screen?
- [ ] What is the notification subcollection pattern (`notifications/{userId}/messages`)?

---

# Phase 11: Feature Views — UI Layer

> **Goal:** Understand how feature views compose stores, coordinators, and design system components.

### Provider-Role Views (`MainViews/ProviderViews/`)

| File | Purpose |
|------|---------|
| `HomeView.swift` | Provider dashboard — stats, calendar with job indicators, quick actions |
| `myJobs.swift` | Service management — list, status tabs, create/edit |
| `CreateJobSheet.swift` | Multi-step job creation form |
| `JobProvider.swift` | Tab wrapper for provider experience |

### Student/Seeker-Role Views (`MainViews/StudentViews/`)

| File | Purpose |
|------|---------|
| `DashboardView.swift` | Seeker homepage — browse by category, recent activity, search |
| `BrowseJobs.swift` | Category-filtered service listing with pagination |
| `AppliedJobsView.swift` | "My Applications" list with status filtering |
| `NeedWork.swift` | Tab wrapper for seeker experience |

### Shared Views (`MainViews/`)

| File | Purpose |
|------|---------|
| `ChatView.swift` | Conversation list with search, pin, delete |
| `ProfileView.swift` | Profile header, settings, role switcher |

### Feature-Specific (`Features/`)

| Feature | Key Views |
|---------|-----------|
| `Chat/` | `ChatDetailView` — message list, input bar, typing indicator |
| `CreateJobSheet/` | Multi-step: category → details → pricing → dates → images → review → publish |
| `Dashboard/` | `DashboardViewModel`, `AllActivitiesView` |
| `ServiceDetail/` | Full service page — images, description, map, apply button |
| `Reviews/` | Review submission & display views |
| `WalletView/` | Balance display, transaction list, withdraw/top-up |
| `Search/` | Global search across services |
| `FilteredServices/` | Date/tag filtered service lists |
| `JobCompletion/` | End-of-job flow — mark complete, trigger reviews |
| `Profile/` | Edit profile, addresses, settings |

### UI Pattern: Environment-Driven Views
```swift
struct ChatView: View {
    @Environment(ConversationsStore.self) var conversationsStore
    @Environment(AuthenticationManager.self) var authManager
    @Environment(AppCoordinator.self) var appCoordinator

    var body: some View {
        // Views read directly from stores — no view model needed
        // Navigation actions go through the coordinator
    }
}
```

### Checkpoint Quiz — Phase 11
- [ ] How does `DashboardView` get its data (stores? view model? both?)
- [ ] What is the multi-step flow for creating a new job?
- [ ] How does `ChatView` handle swipe-to-delete and swipe-to-pin?

---

# Phase 12: Analytics & Observability

> **Goal:** Understand how user actions are tracked.

### 12.1 `Core/Analytics/AnalyticsService.swift`
- **Amplitude SDK** singleton
- `identify(userId:)` — links Amplitude profile to Firebase UID
- `setUserProperties(role:)` — segments users by role
- `track(_ event: AnalyticsEvent)` — fires events with properties
- `reset()` — clears identity on sign-out

### 12.2 `Core/Analytics/AnalyticsEvent.swift`
**68 tracked events across 10 categories:**

| Category | Key Events |
|----------|-----------|
| Auth | `signed_up`, `logged_in`, `logged_out`, `guest_sign_in` |
| Onboarding | `onboarding_completed`, `onboarding_step_viewed`, `onboarding_card_swiped` |
| Paywall | `paywall_viewed`, `paywall_dismissed`, `paywall_trial_started` |
| Job Creation | `job_creation_started`, `job_creation_step_completed`, `job_published` |
| Core Funnel | `job_viewed`, `job_applied`, `application_accepted`, `job_completed` |
| Reviews | `review_submitted` |
| Messaging | `chat_opened`, `message_sent` |
| Search | `search_performed`, `filter_applied` |
| Permissions | `permission_prompted`, `permission_granted`, `permission_denied` |
| Errors | `application_failed`, `job_publish_failed` |

Each event is a **Swift enum case with associated values**, making it impossible to send malformed event data.

### Checkpoint Quiz — Phase 12
- [ ] Why are analytics events defined as enum cases instead of raw strings?
- [ ] What is the difference between `identify()` and `setUserProperties()`?

---

# Phase 13: Testing & Mocks

> **Goal:** Understand the testing infrastructure.

### 13.1 `Core/Protocols/` — Abstraction Layer
The three provider protocols (`AuthProvider`, `FirestoreProvider`, `StorageProvider`) define the interface boundary between the app and Firebase.

### 13.2 `Core/DI/Mocks/MockFirestoreService.swift`
- In-memory arrays replace Firestore collections
- Implements full CRUD matching `FirestoreProvider`
- Used in Xcode Previews and unit tests

### 13.3 `Core/DI/Mocks/MockStorageService.swift`
- Returns deterministic fake URLs
- No actual Firebase Storage dependency

### Testing Strategy
```
Production:  View → Store → FirestoreService → Firestore
Testing:     View → Store → MockFirestoreService → In-Memory
Previews:    View → MockData (static sample arrays on each model)
```

Every model includes `static let sampleData` for previews:
```swift
extension JobService {
    static let sampleData: [JobService] = [...]
}
```

### Checkpoint Quiz — Phase 13
- [ ] How would you write a unit test for `ApplicationsStore.acceptApplication` without hitting Firestore?
- [ ] Why does every model include `sampleData`?

---

# Phase 14: Putting It All Together

> **Goal:** Trace a complete user flow end-to-end.

## Flow: "Provider creates a job and a seeker applies"

```
1.  Provider opens app → GoodShiftApp @main
2.  MainView checks authState → .signedIn → checks role → ServiceProvider
3.  AppCoordinator activates ServiceProviderCoordinator
4.  Provider taps "Create Job" → coordinator.presentSheet(.createJob(...))
5.  CreateJobSheet → multi-step form → calls ServicesStore.createService()
6.  ServicesStore.createService() → FirestoreService.saveService() → Firestore write
7.  Service appears in browse feed (ServicesStore listener on other devices)

8.  Seeker opens app → DashboardView → BrowseJobs
9.  Seeker taps service → coordinator.navigate(to: .serviceDetail(service))
10. Seeker taps "Apply" → coordinator.presentSheet(.applyToService(...))
11. ApplySheet → calls ApplicationsStore.submitApplication()
12. ApplicationsStore → FirestoreService.saveApplication() → Firestore write

13. Provider's ApplicationsStore listener fires → new application appears
14. Provider taps "Accept" → ApplicationsStore.acceptApplication()
    → Update this app to .accepted
    → Reject all other pending apps
    → Update service status to .inProgress
    → All in a single batch

15. Cloud Function (not in client code) sends:
    → Push to seeker: "Your application was accepted!"
    → Push to rejected seekers: "Application not selected"

16. Seeker's NotificationsStore listener fires → badge count updates
17. AppDelegate receives push → AppCoordinator deep-links to job detail
```

---

## 🎯 Quick Reference: Architecture Decision Log

| Decision | Rationale |
|----------|-----------|
| `@Observable` over `ObservableObject` | Simpler, no `@Published` boilerplate, Swift-native |
| Manual Firestore mapping | More control than automatic Codable, handles Timestamps |
| `ListenerManaging` protocol | Prevents memory leaks, consistent cleanup |
| Coordinator pattern | Decouples navigation from views |
| Per-tab `NavigationPath` | Independent back stacks per tab |
| `TaskGroup` for session setup | Parallel store initialization (6 stores) |
| Compile-safe constants | Typos become build errors, not runtime bugs |
| Denormalized fields | Faster reads, fewer Firestore queries |
| Protocol-based DI | Testability without frameworks |
| `SemanticColor` abstraction | Theme-agnostic, dark-mode-safe |

---

## 📚 Glossary

| Term | Meaning |
|------|---------|
| **Store** | `@Observable` class holding domain state + Firestore listeners |
| **Coordinator** | Navigation controller managing tabs, stacks, and sheets |
| **Listener** | Firestore `addSnapshotListener` for real-time updates |
| **Semantic Color** | Role-based color name (e.g., `.appBackground`) vs raw hex |
| **Token** | Raw color value (e.g., `#37857D`) in the design system |
| **Denormalization** | Storing derived data (e.g., `reviewerName`) to avoid extra queries |
| **Subcollection** | Firestore collection nested under a document (e.g., `users/{id}/fcmTokens`) |
| **TaskGroup** | Swift Concurrency API for parallel async work |

---

> **End of Master Course. Good luck! 🚀**
