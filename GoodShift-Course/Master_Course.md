# GoodShift Master Course: Swift & iOS Development

## 👨‍🏫 How Your Teacher (Claude) Will Teach You

When you say **"Start Phase X"**, Claude will act as a patient teacher using the **ELI5-then-Expert** method. Here is exactly what happens in each lesson:

### Lesson Structure (Every Phase Follows This)

**1. 📋 Phase Overview**
Claude opens by telling you: what topic this phase covers, which files you'll read, and what you'll be able to understand or build by the end.

**2. 🔁 Swift Concept Refreshers**
Before touching the actual code, Claude gives you clear, simple reminders of every Swift rule or concept that appears in this phase's files. Examples:
- "In this phase we use protocols. A protocol is like a contract — it says 'any type that adopts me must have these properties and methods.'"
- "We'll see `async/await`. Think of it like ordering food: you place the order and come back when it's ready, instead of standing at the counter."

**3. 🤔 The Problem First**
Before showing you the solution, Claude introduces a problem:
> "We need the app to know which user is logged in from anywhere. How would you design that?"
You think about it, respond, and then Claude reveals how this codebase solves it.

**4. 🧪 Simple Example**
Claude shows you the concept in a tiny, isolated example — not the real app code yet. For example, before showing `AppContainer`, Claude shows a 10-line dependency injection example.

**5. 🔍 The Real Code Walkthrough**
Now Claude opens the actual file(s) and walks through every meaningful line:
- What this line does
- Why it was written this way
- Whether this is a modern pattern or legacy code
- Any alternative approaches

**6. 🏁 Modernness Verdict**
At the end of each file, Claude gives a verdict:
- ✅ **Modern** — "This uses `@Observable`, which is the iOS 17+ best practice."
- ⚠️ **Could Be Improved** — "This uses `ObservableObject`. It works, but Apple now recommends `@Observable` for new code."
- ❌ **Legacy / Anti-Pattern** — "This uses `NavigationView` which is deprecated since iOS 16. Here is how you'd rewrite it."

**7. 💡 Improvement Hint**
Claude ends each lesson with one of two conclusions:
- "This code is well-written. Here is why Apple would be happy with it."
- "Here's one thing you could improve — think about how you'd refactor this before the next lesson."

---

## 🗺️ App Architecture Map

The **GoodShift** app embraces iOS 17+ latest paradigms heavily.
- **App Lifecycle**: Follows the SwiftUI `@main` struct starting with `GoodShiftApp`, which injects dependencies using `.environment`.
- **State Management & DI**: Powered by `@Observable` instead of `ObservableObject`. Dependencies are cleanly contained in an `AppContainer` pattern. Stores encapsulate global data (e.g. `WalletStore`, `ConversationsStore`) and handle real-time fetching via Firebase listeners.
- **Architectural Flow**: It primarily uses an MV-Store architecture (or MVVM variant mapping models directly onto SwiftUI via Stores) with strong Dependency Injection to decouple backend/UI.
- **Backend & Networking**: Firebase is the heavy lifter. `FirestoreProvider`, `StorageProvider`, and `AuthProvider` define the contracts via protocols. `AnalyticsService` handles the telemetry.
- **Navigation Flow**: Custom SwiftUI navigation handled via `@Environment(\.notificationsStore)` and custom sub-coordinators where necessary.

---

## ⚙️ Technical Files Overview

- **Info.plist**: Base application properties, build numbers, and SDK keys.
- **GoodShift.entitlements**: App capabilities like push notifications or background modes.
- **Assets.xcassets**: Includes imagery for job categories, icons, and dynamic color sets mapped to semantic colors.
- **GoogleService-Info.plist**: Direct keys for Firebase initialization inside `GoodShiftApp`.
- **Localizable.strings / *.xcstrings**: Translates the app logic. We note support for AR/EN logic heavily used in components.

---

## 📚 Curriculum & Phase Tracker

### Phase 1: App Lifecycle & Entry Point

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/App/GoodShiftApp.swift` | GoodShiftApp | async/await | ✅ |
| `GoodShift/App/Bootstrap/AppDelegate.swift` | AppDelegate | async/await | ✅ |

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied

- [ ] `GoodShift/App/GoodShiftApp.swift`
- [ ] `GoodShift/App/Bootstrap/AppDelegate.swift`

### Phase 2: App Architecture — Container & State

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/App/Bootstrap/AppStateManager.swift` | AppStateManager | @Observable, async/await | ✅ |
| `GoodShift/App/Bootstrap/AppContainer.swift` | AppContainer | @Observable, async/await | ✅ |

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied

- [ ] `GoodShift/App/Bootstrap/AppStateManager.swift`
- [ ] `GoodShift/App/Bootstrap/AppContainer.swift`

### Phase 3: Navigation & Coordinators

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Core/Navigation/ServiceProviderCoordinator.swift` | ServiceProviderCoordinator | @Observable | ✅ |
| `GoodShift/Core/Navigation/AppCoordinator.swift` | AppCoordinator | @Observable | ✅ |
| `GoodShift/Core/Navigation/JobSeekerCoordinator.swift` | JobSeekerCoordinator | @Observable | ✅ |
| `GoodShift/Core/Navigation/NavigationDestinations.swift` | Helper/View/Model | Swift Basics | ✅ |

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied

- [ ] `GoodShift/Core/Navigation/ServiceProviderCoordinator.swift`
- [ ] `GoodShift/Core/Navigation/AppCoordinator.swift`
- [ ] `GoodShift/Core/Navigation/JobSeekerCoordinator.swift`
- [ ] `GoodShift/Core/Navigation/NavigationDestinations.swift`

### Phase 4: Core Utilities & Constants

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Core/AppConstants.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Core/StateKey.swift` | StateKey | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ErrorStateView.swift` | ErrorStateView | async/await | ✅ |
| `GoodShift/Core/Error/AppError.swift` | ErrorAlert | Swift Basics | ✅ |
| `GoodShift/Core/Error/ErrorHandler.swift` | ErrorHandler | @Observable, async/await | ✅ |
| `GoodShift/Models/Services/Date+ActivityFormatting.swift` | Helper/View/Model | Swift Basics | ✅ |

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied

- [ ] `GoodShift/Core/AppConstants.swift`
- [ ] `GoodShift/Core/StateKey.swift`
- [ ] `GoodShift/Core/Design System/Components/ErrorStateView.swift`
- [ ] `GoodShift/Core/Error/AppError.swift`
- [ ] `GoodShift/Core/Error/ErrorHandler.swift`
- [ ] `GoodShift/Models/Services/Date+ActivityFormatting.swift`

### Phase 5: Backend & Protocols

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Core/Protocols/AuthProvider.swift` | AuthProvider | async/await, Protocols | ✅ |
| `GoodShift/Core/Protocols/StorageProvider.swift` | StorageProvider | async/await, Protocols | ✅ |
| `GoodShift/Core/Protocols/FirestoreProvider.swift` | FirestoreProvider | async/await, Protocols | ✅ |
| `GoodShift/Models/Firebase/StorageService.swift` | StorageService | async/await | ✅ |
| `GoodShift/Models/Firebase/ListenerManager.swift` | ListenerManaging, extension | Protocols | ✅ |
| `GoodShift/Models/Firebase/FirestoreService.swift` | FirestoreService | async/await | ✅ |

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied

- [ ] `GoodShift/Core/Protocols/AuthProvider.swift`
- [ ] `GoodShift/Core/Protocols/StorageProvider.swift`
- [ ] `GoodShift/Core/Protocols/FirestoreProvider.swift`
- [ ] `GoodShift/Models/Firebase/StorageService.swift`
- [ ] `GoodShift/Models/Firebase/ListenerManager.swift`
- [ ] `GoodShift/Models/Firebase/FirestoreService.swift`

### Phase 6: Domain Models

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Core/Notifications/Models/Notification.swift` | Notification, NotificationPayload | Swift Basics | ✅ |
| `GoodShift/Core/Notifications/Models/NotificationPreferences.swift` | NotificationPreferences, CategoryPreference | Swift Basics | ✅ |
| `GoodShift/Core/Notifications/Models/NotificationType.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/Models/ServiceLocation.swift` | ServiceLocation | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/Models/CreateJobViewModel.swift` | CreateJobViewModel | @Observable, async/await | ✅ |
| `GoodShift/Features/CreateJobSheet/Models/ServiceCategoryType.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/Models/ServiceCategory.swift` | ServiceCategory | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/Models/ServiceImage.swift` | ServiceImage | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/Models/ServiceStatus.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Models/Applications/JobApplication.swift` | JobApplication | Swift Basics | ✅ |
| `GoodShift/Models/Wallet/Transaction.swift` | Transaction | Swift Basics | ✅ |
| `GoodShift/Models/Account/User+Permissions.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Models/Account/UserCache.swift` | UserCache | @Observable, async/await | ✅ |
| `GoodShift/Models/Account/UserScoreCalculator.swift` | UserScoreCalculator | Swift Basics | ✅ |
| `GoodShift/Models/Account/User+Formatting.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Models/Account/User.swift` | SavedAddress, User | Swift Basics | ✅ |
| `GoodShift/Models/Account/UserValueObjects.swift` | Badge | Swift Basics | ✅ |
| `GoodShift/Models/Messaging/Conversation.swift` | Conversation | Swift Basics | ✅ |
| `GoodShift/Models/Messaging/TypingIndicator.swift` | TypingIndicator | Swift Basics | ✅ |
| `GoodShift/Models/Messaging/Message.swift` | Message | Swift Basics | ✅ |
| `GoodShift/Models/Messaging/NotificationService.swift` | NotificationService | async/await | ✅ |
| `GoodShift/Models/Services/JobService+SampleData.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Models/Services/ServiceValidator.swift` | ServiceValidator | Swift Basics | ✅ |
| `GoodShift/Models/Services/JobService.swift` | JobService | Swift Basics | ✅ |
| `GoodShift/Models/Services/ServiceCategoryGroup.swift` | ServiceItemCard | Swift Basics | ✅ |
| `GoodShift/Models/Services/JobServiceFirestoreMapper.swift` | JobServiceFirestoreMapper | Swift Basics | ✅ |
| `GoodShift/Models/Services/ServiceActivity.swift` | ServiceActivity | Swift Basics | ✅ |
| `GoodShift/Models/Reviews/Review.swift` | Review | Swift Basics | ✅ |

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied

- [ ] `GoodShift/Core/Notifications/Models/Notification.swift`
- [ ] `GoodShift/Core/Notifications/Models/NotificationPreferences.swift`
- [ ] `GoodShift/Core/Notifications/Models/NotificationType.swift`
- [ ] `GoodShift/Features/CreateJobSheet/Models/ServiceLocation.swift`
- [ ] `GoodShift/Features/CreateJobSheet/Models/CreateJobViewModel.swift`
- [ ] `GoodShift/Features/CreateJobSheet/Models/ServiceCategoryType.swift`
- [ ] `GoodShift/Features/CreateJobSheet/Models/ServiceCategory.swift`
- [ ] `GoodShift/Features/CreateJobSheet/Models/ServiceImage.swift`
- [ ] `GoodShift/Features/CreateJobSheet/Models/ServiceStatus.swift`
- [ ] `GoodShift/Models/Applications/JobApplication.swift`
- [ ] `GoodShift/Models/Wallet/Transaction.swift`
- [ ] `GoodShift/Models/Account/User+Permissions.swift`
- [ ] `GoodShift/Models/Account/UserCache.swift`
- [ ] `GoodShift/Models/Account/UserScoreCalculator.swift`
- [ ] `GoodShift/Models/Account/User+Formatting.swift`
- [ ] `GoodShift/Models/Account/User.swift`
- [ ] `GoodShift/Models/Account/UserValueObjects.swift`
- [ ] `GoodShift/Models/Messaging/Conversation.swift`
- [ ] `GoodShift/Models/Messaging/TypingIndicator.swift`
- [ ] `GoodShift/Models/Messaging/Message.swift`
- [ ] `GoodShift/Models/Messaging/NotificationService.swift`
- [ ] `GoodShift/Models/Services/JobService+SampleData.swift`
- [ ] `GoodShift/Models/Services/ServiceValidator.swift`
- [ ] `GoodShift/Models/Services/JobService.swift`
- [ ] `GoodShift/Models/Services/ServiceCategoryGroup.swift`
- [ ] `GoodShift/Models/Services/JobServiceFirestoreMapper.swift`
- [ ] `GoodShift/Models/Services/ServiceActivity.swift`
- [ ] `GoodShift/Models/Reviews/Review.swift`

### Phase 7: Data Stores & State

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Core/Notifications/Stores/NotificationsStore.swift` | NotificationsStore | @Observable, async/await | ✅ |
| `GoodShift/Core/Notifications/Environment/NotificationsStoreKey.swift` | NotificationsStoreKey | Swift Basics | ✅ |
| `GoodShift/Models/Applications/ApplicationsStore.swift` | ApplicationsStore | @Observable, async/await | ✅ |
| `GoodShift/Models/Wallet/WalletStore.swift` | WalletStore | @Observable, async/await | ✅ |
| `GoodShift/Models/Messaging/MessagesStore.swift` | MessagesStore | @Observable, async/await | ✅ |
| `GoodShift/Models/Messaging/ConversationsStore.swift` | ConversationsStore | @Observable, async/await | ✅ |
| `GoodShift/Models/Authentication/AuthenticationManager.swift` | AuthenticationManager | @Observable, async/await | ✅ |
| `GoodShift/Models/Currency/CurrencyManager.swift` | CurrencyService | @Observable | ✅ |
| `GoodShift/Models/Services/ServicesStore.swift` | ServicesStore | @Observable, async/await | ✅ |
| `GoodShift/Models/Reviews/ReviewsStore.swift` | ReviewsStore | @Observable, async/await | ✅ |

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied

- [ ] `GoodShift/Core/Notifications/Stores/NotificationsStore.swift`
- [ ] `GoodShift/Core/Notifications/Environment/NotificationsStoreKey.swift`
- [ ] `GoodShift/Models/Applications/ApplicationsStore.swift`
- [ ] `GoodShift/Models/Wallet/WalletStore.swift`
- [ ] `GoodShift/Models/Messaging/MessagesStore.swift`
- [ ] `GoodShift/Models/Messaging/ConversationsStore.swift`
- [ ] `GoodShift/Models/Authentication/AuthenticationManager.swift`
- [ ] `GoodShift/Models/Currency/CurrencyManager.swift`
- [ ] `GoodShift/Models/Services/ServicesStore.swift`
- [ ] `GoodShift/Models/Reviews/ReviewsStore.swift`

### Phase 8: Notifications Architecture

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Core/Notifications/Views/NotificationDrawerView.swift` | NotificationDrawerView, FilterPill | NavigationStack, async/await | ✅ |
| `GoodShift/Core/Notifications/Views/NotificationCardView.swift` | NotificationCardView | Swift Basics | ✅ |
| `GoodShift/Core/Notifications/Views/NotificationBadgeView.swift` | NotificationBadgeView | Swift Basics | ✅ |
| `GoodShift/Core/Notifications/Services/FCMService.swift` | FCMService | async/await | ✅ |

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied

- [ ] `GoodShift/Core/Notifications/Views/NotificationDrawerView.swift`
- [ ] `GoodShift/Core/Notifications/Views/NotificationCardView.swift`
- [ ] `GoodShift/Core/Notifications/Views/NotificationBadgeView.swift`
- [ ] `GoodShift/Core/Notifications/Services/FCMService.swift`

### Phase 9: Design System — Foundation

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Core/Design System/Buttons/DesignSystemButtons.swift` | BrandButton | Swift Basics | ✅ |
| `GoodShift/Core/Design System/TextField/BrandSearchField.swift` | BrandSearchField | Swift Basics | ✅ |
| `GoodShift/Core/Design System/TextField/BrandTextEditor.swift` | BrandTextEditor | Swift Basics | ✅ |
| `GoodShift/Core/Design System/TextField/BrandTextField.swift` | BrandTextField | Swift Basics | ✅ |
| `GoodShift/Core/Design System/TextField/BrandNumericalField.swift` | BrandNumericalField | Swift Basics | ✅ |
| `GoodShift/Core/Design System/TextField/InputState.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Core/Design System/TextField/BrandPasswordField.swift` | BrandPasswordField | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ServiceListCard.swift` | ServiceListCard | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ServiceCard.swift` | ServiceCard | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/StarRatingPicker.swift` | StarRatingPicker | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ProfileMenuRow.swift` | ProfileMenuRow | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/HireRoleRow.swift` | HireRoleRow | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ApplicationStatusBadge.swift` | ApplicationStatusBadge | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ApplicationBadge.swift` | ApplicationBadge | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/MessageBubble.swift` | MessageBubble | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ServiceCategoryCard.swift` | ServiceCategoryCard | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ApplicantCard.swift` | ApplicantCard | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/CustomCalendarWithJobIndicators.swift` | CustomCalendarWithJobIndicators | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ReviewSummaryView.swift` | ReviewSummaryView | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/TypingIndicatorView.swift` | TypingIndicatorView | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/HomeActivityCard.swift` | HomeActivityCard | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/CarouselCard.swift` | CarouselCard | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/AppliedServiceCard.swift` | AppliedServiceCard | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ReviewCard.swift` | ReviewCard | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/ConfettiView.swift` | ConfettiView, ConfettiPiece | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/RoleOptionCard.swift` | RoleOptionCard | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/LoadingStateView.swift` | LoadingStateView | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/CompletionRequestBanner.swift` | CompletionRequestBanner | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/SectionHeader.swift` | SectionHeader | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/Profile/ProfileHeaderView.swift` | ProfileHeaderView | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/Profile/RoleSwitcherView.swift` | RoleSwitcherView | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/Profile/WorkManagementSection.swift` | WorkManagementSection | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Components/Profile/AccountMenuSection.swift` | AccountMenuSection, DeleteAccountSheet | NavigationStack, async/await | ✅ |
| `GoodShift/Core/Design System/Components/Profile/ProfileCompletionPopup.swift` | ProfileCompletionPopup | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Colors/Tokens.swift` | ColorTokensPreview | NavigationStack | ✅ |
| `GoodShift/Core/Design System/Colors/Semantic Colors.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Core/Design System/Colors/Provider.swift` | ColorProvidingSwiftUI, DefaultColorProviderSwiftUI | Protocols | ✅ |
| `GoodShift/Core/Design System/Colors/Colors Themes.swift` | ColorPalette | Swift Basics | ✅ |

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied

- [ ] `GoodShift/Core/Design System/Buttons/DesignSystemButtons.swift`
- [ ] `GoodShift/Core/Design System/TextField/BrandSearchField.swift`
- [ ] `GoodShift/Core/Design System/TextField/BrandTextEditor.swift`
- [ ] `GoodShift/Core/Design System/TextField/BrandTextField.swift`
- [ ] `GoodShift/Core/Design System/TextField/BrandNumericalField.swift`
- [ ] `GoodShift/Core/Design System/TextField/InputState.swift`
- [ ] `GoodShift/Core/Design System/TextField/BrandPasswordField.swift`
- [ ] `GoodShift/Core/Design System/Components/ServiceListCard.swift`
- [ ] `GoodShift/Core/Design System/Components/ServiceCard.swift`
- [ ] `GoodShift/Core/Design System/Components/StarRatingPicker.swift`
- [ ] `GoodShift/Core/Design System/Components/ProfileMenuRow.swift`
- [ ] `GoodShift/Core/Design System/Components/HireRoleRow.swift`
- [ ] `GoodShift/Core/Design System/Components/ApplicationStatusBadge.swift`
- [ ] `GoodShift/Core/Design System/Components/ApplicationBadge.swift`
- [ ] `GoodShift/Core/Design System/Components/MessageBubble.swift`
- [ ] `GoodShift/Core/Design System/Components/ServiceCategoryCard.swift`
- [ ] `GoodShift/Core/Design System/Components/ApplicantCard.swift`
- [ ] `GoodShift/Core/Design System/Components/CustomCalendarWithJobIndicators.swift`
- [ ] `GoodShift/Core/Design System/Components/ReviewSummaryView.swift`
- [ ] `GoodShift/Core/Design System/Components/TypingIndicatorView.swift`
- [ ] `GoodShift/Core/Design System/Components/HomeActivityCard.swift`
- [ ] `GoodShift/Core/Design System/Components/CarouselCard.swift`
- [ ] `GoodShift/Core/Design System/Components/AppliedServiceCard.swift`
- [ ] `GoodShift/Core/Design System/Components/ReviewCard.swift`
- [ ] `GoodShift/Core/Design System/Components/ConfettiView.swift`
- [ ] `GoodShift/Core/Design System/Components/RoleOptionCard.swift`
- [ ] `GoodShift/Core/Design System/Components/LoadingStateView.swift`
- [ ] `GoodShift/Core/Design System/Components/CompletionRequestBanner.swift`
- [ ] `GoodShift/Core/Design System/Components/SectionHeader.swift`
- [ ] `GoodShift/Core/Design System/Components/Profile/ProfileHeaderView.swift`
- [ ] `GoodShift/Core/Design System/Components/Profile/RoleSwitcherView.swift`
- [ ] `GoodShift/Core/Design System/Components/Profile/WorkManagementSection.swift`
- [ ] `GoodShift/Core/Design System/Components/Profile/AccountMenuSection.swift`
- [ ] `GoodShift/Core/Design System/Components/Profile/ProfileCompletionPopup.swift`
- [ ] `GoodShift/Core/Design System/Colors/Tokens.swift`
- [ ] `GoodShift/Core/Design System/Colors/Semantic Colors.swift`
- [ ] `GoodShift/Core/Design System/Colors/Provider.swift`
- [ ] `GoodShift/Core/Design System/Colors/Colors Themes.swift`

### Phase 10: Design System — Components

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied


### Phase 11: App Shell — Main Views

> **Goal:** Understand the components encapsulated in this module.
>
> **Modernness Level:** Mixed (See table below)

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/App/MainView.swift` | MainView | Swift Basics | ✅ |
| `GoodShift/MainViews/ProfileView.swift` | ProfileView | async/await | ✅ |
| `GoodShift/MainViews/ChatView.swift` | ChatView | async/await | ✅ |
| `GoodShift/MainViews/StudentViews/DashboardView.swift` | DashboardView, ShiftPickerCalendarView | async/await | ⚠️ |
| `GoodShift/MainViews/StudentViews/AppliedJobsView.swift` | AppliedJobsView | async/await | ✅ |
| `GoodShift/MainViews/StudentViews/NeedWork.swift` | ServiceProviderRootView | NavigationStack | ✅ |
| `GoodShift/MainViews/StudentViews/BrowseJobs.swift` | BrowseJobsView | async/await | ✅ |
| `GoodShift/MainViews/ProviderViews/CreateJobSheet.swift` | CreateJobSheet | async/await | ✅ |
| `GoodShift/MainViews/ProviderViews/HomeView.swift` | HomeView, JobCategory | async/await | ✅ |
| `GoodShift/MainViews/ProviderViews/JobProvider.swift` | JobSeekerRootView | NavigationStack | ✅ |
| `GoodShift/MainViews/ProviderViews/myJobs.swift` | ApplicantUsersCache, MyJobsView | @Observable, async/await | ✅ |

#### What the Teacher Will Focus On
- Core responsibilities
- Design patterns applied

- [ ] `GoodShift/App/MainView.swift`
- [ ] `GoodShift/MainViews/ProfileView.swift`
- [ ] `GoodShift/MainViews/ChatView.swift`
- [ ] `GoodShift/MainViews/StudentViews/DashboardView.swift`
- [ ] `GoodShift/MainViews/StudentViews/AppliedJobsView.swift`
- [ ] `GoodShift/MainViews/StudentViews/NeedWork.swift`
- [ ] `GoodShift/MainViews/StudentViews/BrowseJobs.swift`
- [ ] `GoodShift/MainViews/ProviderViews/CreateJobSheet.swift`
- [ ] `GoodShift/MainViews/ProviderViews/HomeView.swift`
- [ ] `GoodShift/MainViews/ProviderViews/JobProvider.swift`
- [ ] `GoodShift/MainViews/ProviderViews/myJobs.swift`

### Phase 12: Feature — LaunchScreen

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/LaunchScreen/LaunchScreen.swift` | LaunchScreen | Swift Basics | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/LaunchScreen/LaunchScreen.swift`

### Phase 13: Feature — ChatViews

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/ChatViews/ChatDetailView.swift` | ChatDetailView | NavigationStack, async/await | ✅ |
| `GoodShift/Features/ChatViews/ChatListView.swift` | ConversationNameLoader, ConversationRow | @Observable, async/await | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/ChatViews/ChatDetailView.swift`
- [ ] `GoodShift/Features/ChatViews/ChatListView.swift`

### Phase 14: Feature — ServiceManagement

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/ServiceManagement/CompletedServicesView.swift` | CompletedServicesView, CompletedServiceCard | async/await | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/ServiceManagement/CompletedServicesView.swift`

### Phase 15: Feature — Chat

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/Chat/ChatDetailViewModel.swift` | ChatDetailViewModel | @Observable, async/await | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/Chat/ChatDetailViewModel.swift`

### Phase 16: Feature — JobCompletion

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/JobCompletion/MarkJobDoneView.swift` | MarkJobDoneView | NavigationStack, async/await | ✅ |
| `GoodShift/Features/JobCompletion/PostJobReviewSheet.swift` | PostJobReviewSheet | Swift Basics | ✅ |
| `GoodShift/Features/JobCompletion/CompletionConfirmationSheet.swift` | CompletionConfirmationSheet | NavigationStack, async/await | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/JobCompletion/MarkJobDoneView.swift`
- [ ] `GoodShift/Features/JobCompletion/PostJobReviewSheet.swift`
- [ ] `GoodShift/Features/JobCompletion/CompletionConfirmationSheet.swift`

### Phase 17: Feature — Role Selection 

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/Role Selection /RoleSelectionView.swift` | RoleChoice, RoleSelectionView | Swift Basics | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/Role Selection /RoleSelectionView.swift`

### Phase 18: Feature — CreateJobSheet

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/CreateJobSheet/CreateJobTab5.swift` | CreateJobTab5 | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/ImagePickerSheet.swift` | ImagePickerSheet | async/await | ✅ |
| `GoodShift/Features/CreateJobSheet/CreateJobTab1.swift` | CreateJobTab1 | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/CreateJobTab3.swift` | CreateJobTab3 | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/CreateJobTab4.swift` | CreateJobTab4 | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/CreateJobTab6.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/CreateJobTab2.swift` | CreateJobTab2, MapSelectionView | @Observable, NavigationStack, async/await | ✅ |
| `GoodShift/Features/CreateJobSheet/CreateJobSummaryModal.swift` | CreateJobSummaryModal, SummaryCard | Swift Basics | ✅ |
| `GoodShift/Features/CreateJobSheet/JobPublishedSuccessModal.swift` | JobPublishedSuccessModal, DetailRow | Swift Basics | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/CreateJobSheet/CreateJobTab5.swift`
- [ ] `GoodShift/Features/CreateJobSheet/ImagePickerSheet.swift`
- [ ] `GoodShift/Features/CreateJobSheet/CreateJobTab1.swift`
- [ ] `GoodShift/Features/CreateJobSheet/CreateJobTab3.swift`
- [ ] `GoodShift/Features/CreateJobSheet/CreateJobTab4.swift`
- [ ] `GoodShift/Features/CreateJobSheet/CreateJobTab6.swift`
- [ ] `GoodShift/Features/CreateJobSheet/CreateJobTab2.swift`
- [ ] `GoodShift/Features/CreateJobSheet/CreateJobSummaryModal.swift`
- [ ] `GoodShift/Features/CreateJobSheet/JobPublishedSuccessModal.swift`

### Phase 19: Feature — Search

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/Search/SearchViewModel.swift` | SearchViewModel | @Observable | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/Search/SearchViewModel.swift`

### Phase 20: Feature — Dashboard

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/Dashboard/DashboardViewModel.swift` | DashboardViewModel | @Observable | ✅ |
| `GoodShift/Features/Dashboard/AllActivitiesView.swift` | AllActivitiesView | NavigationStack | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/Dashboard/DashboardViewModel.swift`
- [ ] `GoodShift/Features/Dashboard/AllActivitiesView.swift`

### Phase 21: Feature — Profile

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/Profile/UserPerformanceView.swift` | UserPerformanceView | NavigationStack | ✅ |
| `GoodShift/Features/Profile/EditProfileSheet.swift` | EditProfileSheet | NavigationStack, async/await | ✅ |
| `GoodShift/Features/Profile/MyAddressesView.swift` | AddressRowView, MyAddressesView | NavigationView, async/await | ❌ |
| `GoodShift/Features/Profile/ProfileSetupView.swift` | ProfileSetupView | async/await | ✅ |
| `GoodShift/Features/Profile/UserProfileSheet.swift` | UserProfileLoader, UserProfileSheet | @Observable, NavigationStack, async/await | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/Profile/UserPerformanceView.swift`
- [ ] `GoodShift/Features/Profile/EditProfileSheet.swift`
- [ ] `GoodShift/Features/Profile/MyAddressesView.swift`
- [ ] `GoodShift/Features/Profile/ProfileSetupView.swift`
- [ ] `GoodShift/Features/Profile/UserProfileSheet.swift`

### Phase 22: Feature — ServiceDetail

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/ServiceDetail/ApplyJobSheet.swift` | PosterInfoLoader, ApplyJobSheet | @Observable, NavigationStack, async/await | ✅ |
| `GoodShift/Features/ServiceDetail/ServiceDetailView.swift` | ServiceDetailView, SectionCard | @Observable, NavigationStack, async/await | ✅ |
| `GoodShift/Features/ServiceDetail/ServiceDetailViewModel.swift` | ServiceDetailViewModel | @Observable, async/await | ✅ |
| `GoodShift/Features/ServiceDetail/ServiceCompletionView.swift` | ServiceCompletionView | NavigationStack, async/await | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/ServiceDetail/ApplyJobSheet.swift`
- [ ] `GoodShift/Features/ServiceDetail/ServiceDetailView.swift`
- [ ] `GoodShift/Features/ServiceDetail/ServiceDetailViewModel.swift`
- [ ] `GoodShift/Features/ServiceDetail/ServiceCompletionView.swift`

### Phase 23: Feature — Authentication

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/Authentication/AuthenticationView.swift` | AuthenticationView | async/await | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/Authentication/AuthenticationView.swift`

### Phase 24: Feature — WalletView

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/WalletView/WalletSheet.swift` | WalletSheet, TransactionRow | async/await | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/WalletView/WalletSheet.swift`

### Phase 25: Feature — Onboarding

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/Onboarding/OnboardingView.swift` | OnboardingView, OnboardingPage | async/await | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/Onboarding/OnboardingView.swift`

### Phase 26: Feature — Reviews

> **Goal:** Implement the Feature.
>
> **Modernness Level:** Mixed

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Features/Reviews/UserReviewsView.swift` | UserReviewsView | NavigationStack, async/await | ✅ |
| `GoodShift/Features/Reviews/SubmitReviewSheet.swift` | SubmitReviewSheet | NavigationStack, async/await | ✅ |

#### What the Teacher Will Focus On
- Feature behavior
- State routing

- [ ] `GoodShift/Features/Reviews/UserReviewsView.swift`
- [ ] `GoodShift/Features/Reviews/SubmitReviewSheet.swift`

### Final Phase: Technical Files

#### Files in This Phase

| File Path | What It Does | Key Concepts | Modern? |
|-----------|-------------|--------------|---------|
| `GoodShift/Core/CalendarService.swift` | CalendarService | async/await | ✅ |
| `GoodShift/Core/DI/Mocks/MockStorageService.swift` | MockStorageService | async/await | ✅ |
| `GoodShift/Core/DI/Mocks/MockFirestoreService.swift` | MockFirestoreService | async/await | ✅ |
| `GoodShift/Core/Resources/Localizable.xcstrings` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Core/Resources/GoodShift.entitlements` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Core/Resources/GoogleService-Info.plist` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Core/Resources/Info.plist` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Core/Analytics/AnalyticsEvent.swift` | Helper/View/Model | Swift Basics | ✅ |
| `GoodShift/Core/Analytics/AnalyticsService.swift` | AnalyticsService | Swift Basics | ✅ |

---

## 📝 Lecture Notes

