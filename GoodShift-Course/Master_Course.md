# Saadni Master Course: Swift & iOS Development

Welcome to your personalized, comprehensive Swift and iOS curriculum built directly on top of the **Saadni** codebase. 

This living document will hold our overarching plan, all the files we need to cover, and eventually serve as the notebook for all the lessons we complete. 

## How This Course Works
1. **Phased Approach:** Rather than going strictly alphabetically, we are going to learn by tracing the execution flow of the app (from boot, to core services, to UI, to specific feature slices).
2. **Interactive Lessons:** When you are ready for a phase, just ask! I will break down the files in that phase, explain the code block by block, and test your understanding.
3. **Swift Basics Integration:** For every file, I will explicitly connect the code back to foundational Swift concepts (structs vs classes, functions, parameters, properties, etc.).
4. **Apple Best Practices:** I will analyze the current project code against Apple's official guidelines and modern architecture standards, pointing out areas where the code could be improved or highlighting if it is already written perfectly.
5. **Living Document:** After each lesson, you will be prompted to edit this file (and append new files in this folder) to write down your notes and summarize what you learned.

---

## 📚 Curriculum & Phase Tracker

Here is the exhaustive list of every Swift file in the Saadni project grouped into logical learning blocks. We will check these off together as we proceed.

### Phase 1: App Lifecycle & Dependency Injection
*Goal: Understand how the app starts up, how state is structured, and how our central container provides dependencies.*
- [ ] `Saadni/App/SaadniApp.swift`
- [ ] `Saadni/App/MainView.swift`
- [ ] `Saadni/App/Bootstrap/AppDelegate.swift`
- [ ] `Saadni/App/Bootstrap/AppContainer.swift`
- [ ] `Saadni/App/Bootstrap/AppStateManager.swift`

### Phase 2: Core Architecture, Navigation, & Utilities
*Goal: Learn Coordinator patterns for routing, error handling, and core app constants.*
- [ ] `Saadni/Core/Constants/AppConstants.swift`
- [ ] `Saadni/Core/Constants/StateKey.swift`
- [ ] `Saadni/Core/Error/AppError.swift`
- [ ] `Saadni/Core/Error/ErrorHandler.swift`
- [ ] `Saadni/Core/Navigation/AppCoordinator.swift`
- [ ] `Saadni/Core/Navigation/AppError.swift`
- [ ] `Saadni/Core/Navigation/JobSeekerCoordinator.swift`
- [ ] `Saadni/Core/Navigation/ServiceProviderCoordinator.swift`
- [ ] `Saadni/Core/Navigation/NavigationDestinations.swift`

### Phase 3: Domain Models & the Backend Layer (Modules)
*Goal: Master data modeling, Firebase integration, protocols, and how to write clean Core domains.*
**3.1 Backend & Base Services**
- [ ] `Saadni/Core/Protocols/AuthProvider.swift`
- [ ] `Saadni/Core/Protocols/FirestoreProvider.swift`
- [ ] `Saadni/Core/Protocols/StorageProvider.swift`
- [ ] `Saadni/Modules/Authentication/AuthenticationManager.swift`
- [ ] `Saadni/Modules/Firebase/FirestoreService.swift`
- [ ] `Saadni/Modules/Firebase/ListenerManager.swift`
- [ ] `Saadni/Modules/Firebase/StorageService.swift`

**3.2 Account & Wallet Domain**
- [ ] `Saadni/Modules/Account/User.swift` & extensions (`User+Formatting`, `User+Permissions`)
- [ ] `Saadni/Modules/Account/UserCache.swift`
- [ ] `Saadni/Modules/Account/UserValueObjects.swift`
- [ ] `Saadni/Modules/Account/UserScoreCalculator.swift`
- [ ] `Saadni/Modules/Wallet/WalletStore.swift`
- [ ] `Saadni/Modules/Wallet/Transaction.swift`

**3.3 Core Entities (Jobs, Messaging, Reviews)**
- [ ] `Saadni/Modules/Services/JobService.swift` & related (`JobServiceFirestoreMapper`, `ServiceValidator`, etc.)
- [ ] `Saadni/Modules/Services/ServicesStore.swift`
- [ ] `Saadni/Modules/Applications/ApplicationsStore.swift` & `JobApplication.swift`
- [ ] `Saadni/Modules/Messaging/Conversation.swift` & `ConversationsStore.swift`
- [ ] `Saadni/Modules/Messaging/Message.swift` & `MessagesStore.swift`
- [ ] `Saadni/Modules/Reviews/Review.swift` & `ReviewsStore.swift`

### Phase 4: Push Notifications Architecture
*Goal: Understand the complete flow of local and remote notifications.*
- [ ] `Saadni/Core/Notifications/Environment/NotificationsStoreKey.swift`
- [ ] `Saadni/Core/Notifications/Models/Notification.swift`
- [ ] `Saadni/Core/Notifications/Models/NotificationType.swift`
- [ ] `Saadni/Core/Notifications/Models/NotificationPreferences.swift`
- [ ] `Saadni/Core/Notifications/Services/FCMService.swift`
- [ ] `Saadni/Core/Notifications/Stores/NotificationsStore.swift`

### Phase 5: Design System & Reusable UI
*Goal: Master SwiftUI view construction, styling, tokens, and making code highly reusable.*
- [ ] `Saadni/Core/Design System/Colors/...` (Themes, Tokens, Semantic Colors, Provider)
- [ ] `Saadni/Core/Design System/Buttons/DesignSystemButtons.swift`
- [ ] `Saadni/Core/Design System/TextField/...` (BrandTextField, BrandPasswordField, InputState, etc.)
- [ ] `Saadni/Core/Design System/Components/...` (30+ files including CarouselCard, MessageBubble, ErrorStateView, ReviewCard, ProfileMenuRow)

### Phase 6: Top-Level Main Views (The Shell)
*Goal: Analyze the main tab-views and primary layouts for our two main workflows.*
- [ ] `Saadni/MainViews/JobProviderViews/` (HomeView, JobProvider, myJobs)
- [ ] `Saadni/MainViews/NeedWorkViews/` (DashboardView, BrowseJobs, Dashboard, NeedWork...)
- [ ] `Saadni/MainViews/ChatViews/` (ChatView, ChatListView, ChatDetailView)
- [ ] `Saadni/MainViews/ProfileView.swift`

### Phase 7: Deep Dive Features & Workflows
*Goal: Pull it all together by following exact task flows from View -> ViewModel -> Service.*
- [ ] **Onboarding & Auth:** `LaunchScreen`, `OnboardingView`, `AuthenticationView`, `RoleSelectionView`
- [ ] **Job Creation Flow (Multi-step):** `Features/CreateJobSheet/` (`Tabs 1-6`, `CreateJobViewModel`, Modals & Models like `ServiceCategory`, `ServiceLocation`)
- [ ] **Applying for Jobs:** `Features/ServiceDetail/` (`ServiceDetailView`, `ApplyJobSheet`, `ServiceCompletionView`)
- [ ] **Profile & Account Management:** `Features/Profile/` (`ProfileViewModel`, `EditProfileSheet`, `MyAddressesView`)
- [ ] **Search & Explore:** `Features/Search/SearchViewModel.swift`
- [ ] **Reviews & Ratings:** `Features/Reviews/`
- [ ] **Dashboards & Flow:** `Features/Dashboard/`, `Features/ServiceManagement/`

---

## 📝 Lecture Notes

*(After each lesson, this is where you will add your notes, reflections, and key takeaways. Feel free to create new `.md` files in this folder for extremely long lessons and link to them here.)*

- **Lesson 1:** [Pending...]
- **Lesson 2:** [Pending...]
