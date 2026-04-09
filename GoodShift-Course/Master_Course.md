# 🎓 GoodShift — Master Course

> **Version:** 2.0 &nbsp;|&nbsp; **Generated:** April 8, 2026
> **For:** A junior developer working with an AI tutor (Claude) to master this codebase phase-by-phase.

---

## How to Use This Document

1. **Hand this file to your AI tutor** at the start of every session.
2. Work through **one Phase at a time**, in order.
3. Each phase is broken into **small sub-parts** (Part A, Part B, etc.) — study ONE sub-part at a time.
4. For each file listed, open it in Xcode and discuss it with your tutor.
5. Each sub-part has a **🔬 Hardware Deep Dive** — understand what the CPU, memory, stack, and heap are doing.
6. After finishing ALL sub-parts in a Phase, your tutor will ask: **"Want to start practicing?"**
7. Complete the **🏋️ Practice Zone** before advancing — exercises go Easy → Medium → Hard for every concept.
8. If you still don't get a concept, choose **"Practice More"** to get additional exercises.
9. **Never skip to the next Phase until you've completed practice.**
10. If you get stuck, your tutor has all the context needed to help.

---

## 📚 How to Actually Study Each Part (Science-Based)

> **Read this before every single Part. It takes 30 seconds and prevents wasted sessions.**

### The Core Problem to Avoid

Most developers study like this:
> Read → feel like they understood → move on → forget everything in 3 days

That is **passive learning**. The brain only keeps what it **works hard to retrieve**. Reading feels like learning but almost nothing sticks. Every step below is designed to force retrieval.

---

### One Part = One Session (30–60 min)

```
┌──────────────────────────────────────────────────┐
│  EVERY PART follows this exact sequence:         │
│                                                  │
│  1. Read the Part once        (10 min)           │
│  2. Close everything & recall (10 min)  ← KEY   │
│  3. Open Xcode, find the code (10 min)           │
│  4. Feynman: explain it simply (5 min)           │
│  5. Practice Zone for that Part                  │
└──────────────────────────────────────────────────┘
```

---

### Step 1 — Read Once (10 min)
Read the Part in this document. Do not highlight. Do not copy. Read with one goal: **understand the shape of the concept, not memorize it.**

While reading, ask yourself:
- What problem does this solve?
- What would break if this code didn't exist?

---

### Step 2 — Close Everything. Write What You Remember. (10 min) ← Most Important Step

Close this document. Open **Notability**. Write from memory:
- What does this concept do? (your own words, Arabic or English — whatever comes naturally)
- What does the code roughly look like? (write it from memory, even if wrong)
- What happens at the hardware level?

**Do not look back until you finish writing. Being wrong is fine — that is when learning happens.**

> **Why this works:** The "testing effect" (Roediger & Karpicke, 2006) showed that a single retrieval attempt after reading produces **50% better retention at one week** than re-reading three times. Your brain builds a stronger memory trace when it has to struggle to find the answer.

---

### Step 3 — Go to Xcode. Find the Real Code. (10 min)
Open the actual GoodShift file mentioned in the Part. Read the real code. Compare it to what you wrote from memory.

Ask:
- Where was I right?
- Where was I wrong?
- What did I miss that I now understand?

Write corrections in Notability in a **different color**.

---

### Step 4 — Feynman It (5 min)
Pretend you are explaining this concept to someone who knows nothing about programming. Say it out loud or write it in simple sentences.

If you cannot explain it simply → you do not understand it yet. That is a signal to re-read only that specific part.

> **Why this works:** The "generation effect" — producing an explanation in your own words forms stronger memory traces than reading someone else's explanation.

---

### Step 5 — Practice Zone
Tell your tutor: **"Ready for practice."** Work through Easy → Medium → Hard. Do not skip levels. If a Hard question breaks you, that is the concept to study again before moving on.

---

### Notability Structure (Set This Up Once)

```
📓 GoodShift — Swift Course
│
├── 📄 Phase 0 — Architecture
│   └── [your hand-drawn data flow diagram]
│
├── 📄 Phase 1 — Part A: Entry Point
│   ├── [memory dump — what you recalled without looking]
│   ├── [corrections in a different color]
│   └── [your own simple explanation]
│
├── 📄 Phase 1 — Part B: AppContainer
│   └── ... (one page per Part)
│
├── 📄 🔴 Confusing Things  ← running list
│   └── [concepts that keep tripping you up]
│
└── 📄 ⚡ Swift Rules — My Cheatsheet
    └── [rules in your own words, built up over time]
```

**One page per Part. Never mix Parts. Writing on iPad is itself a retrieval exercise.**

---

### When to Use Each Resource

| Resource | When to Use It |
|----------|---------------|
| **This course doc** | First read of each Part — primary source |
| **Xcode (GoodShift)** | Every session — see the live production code |
| **Apple Docs** | When you hit a specific API (`withTaskGroup`, `@Observable`, etc.) — go to the source |
| **Claude / Perplexity** | When stuck on WHY something works — ask a specific question |
| **YouTube** | Only for hard-to-visualize concepts (stack vs heap, ARC) — watch once, then close and retrieve |
| **Articles / Books** | Rarely — only if Apple Docs are unclear on a specific topic |
| **Writing by hand** | Always — every session. Writing cements memory far better than typing |

**What NOT to do:**
- Do not watch general "SwiftUI tutorial" videos — different mental model from reading production code
- Do not read multiple sources on the same concept in the same session — pick one, retrieve, move on
- Do not copy-paste code examples without first trying to write them from memory

---

### Spaced Repetition (5 min per review)

After finishing a Part, review it again at these intervals:
- **Next day** — open Notability, cover your notes, recall the main ideas
- **3 days later** — same thing, 5 minutes
- **1 week later** — look at your Swift Rules cheatsheet only

If you can recall it → memory is consolidating. If you blank → re-read only that Part, not the whole Phase.

---

### Keeping It Positive

The feeling of **not understanding** something is not failure — it is the exact moment learning is happening.

| Negative thought | Reframe |
|-----------------|---------|
| "I don't get this" | "My brain is building a new connection — this is what learning feels like" |
| "I forgot what I just read" | "Forgetting is normal — retrieval practice will fix it" |
| "This is too hard" | "Hard = high value. Easy = I already know it" |
| "I should understand faster" | "Swift is not my first language — connecting new to old takes time" |

**Two rules for every session:**
1. Never end on confusion — if you are lost, ask your tutor immediately and write the answer before closing Notability. Always end on a small win.
2. One Part per session — you are not racing. One Part done well beats three Parts skimmed.

---

### Your First Session Checklist

- [ ] Open Notability → create notebook **"GoodShift Swift Course"**
- [ ] Create first page: "Phase 0 — Architecture"
- [ ] Read Phase 0 in this document
- [ ] Close it → draw the data flow diagram from memory (Views → Stores → Firestore)
- [ ] Open GoodShift in Xcode → look at the real folder structure
- [ ] Correct your drawing in a different color
- [ ] Tell your tutor: **"Ready for Phase 0 practice"**

That is your first session. ~45 minutes. One concept. Solid foundation.

---

## 🧠 Learning Structure (Per Phase)

```
┌─────────────────────────────────────────┐
│  Phase N                                │
│                                         │
│  Part A: [concept]                      │
│    └─ 📖 Learn the code                 │
│    └─ 🔬 Hardware Deep Dive             │
│         (stack, heap, registers, memory) │
│                                         │
│  Part B: [concept]                      │
│    └─ 📖 Learn the code                 │
│    └─ 🔬 Hardware Deep Dive             │
│                                         │
│  ... more parts ...                     │
│                                         │
│  ✅ Checkpoint Quiz                     │
│                                         │
│  🏋️ PRACTICE ZONE                      │
│    └─ Concept 1: Easy → Medium → Hard   │
│    └─ Concept 2: Easy → Medium → Hard   │
│    └─ ... per concept ...               │
│    └─ 🔄 "Practice More" option         │
│                                         │
│  ✅ Ready? → Next Phase                 │
└─────────────────────────────────────────┘
```

### 🔬 What is a Hardware Deep Dive?

After each sub-part, your tutor will explain **what the hardware is actually doing** when that code runs:

| Concept | What You'll Learn |
|---------|-------------------|
| **Stack** | Where local variables and function call frames live. LIFO structure, super fast. |
| **Heap** | Where objects (`class` instances) are allocated. Slower, managed by ARC. |
| **Registers** | Tiny ultra-fast CPU storage (e.g., x0–x30 on ARM). Where computations actually happen. |
| **Memory Layout** | How structs vs classes are laid out in memory. Value types vs reference types. |
| **ARC (Automatic Reference Counting)** | How Swift tracks object lifetimes via retain/release. |
| **CPU Cache** | L1/L2/L3 caches, why sequential memory access is faster. |
| **Virtual Memory** | How iOS gives each app its own address space. |

### 🏋️ How Practice Works

1. Tutor asks: **"Want to start practicing?"**
2. For EACH concept in the phase, you get:
   - 🟢 **Easy** — Fill in the blank, true/false, explain in your own words
   - 🟡 **Medium** — Write small code snippets, predict output, find the bug
   - 🔴 **Hard** — Design a solution, refactor code, explain the hardware behavior
3. After all concepts: **"Did you get everything? Or want to practice more on any concept?"**
4. If you choose **Practice More** → tutor generates fresh exercises for that concept
5. Only move on when YOU say you're ready

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

### 🏋️ Practice Zone — Phase 0

**Concept: App Architecture**
- 🟢 **Easy:** List the 4 main folders in the project and what each contains.
- 🟡 **Medium:** Draw the data flow from a SwiftUI View to Firestore and back. Label each layer.
- 🔴 **Hard:** If you had to add a new feature (e.g., "Favorites"), which folders would you need to touch and why?

**Concept: User Roles**
- 🟢 **Easy:** True/False — A user can only be a Job Seeker OR a Service Provider, not both.
- 🟡 **Medium:** Explain how the app determines which UI to show for each role.
- 🔴 **Hard:** What architectural changes would be needed to add a third role (e.g., "Admin")?

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 1: App Lifecycle & Dependency Injection

> **Goal:** Understand exactly what happens from cold launch to the first pixel on screen.

## Part A: The Entry Point (`@main`)

### Files to Study

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

#### 🔬 Hardware Deep Dive — Part A

| What Happens | Hardware Level |
|-------------|----------------|
| `@main` is called | CPU jumps to the app's entry point address. The OS loader maps the binary into **virtual memory**. |
| `struct GoodShiftApp` is created | This is a **value type** — it lives on the **stack**. No heap allocation needed. |
| `@State private var container = AppContainer()` | `AppContainer` is a **class** — `init()` allocates it on the **heap**. A pointer (8 bytes) is stored on the stack. **ARC retain count = 1**. |
| `FirebaseApp.configure()` | Opens network sockets, reads `GoogleService-Info.plist` from disk into RAM. File I/O involves **kernel syscalls**. |
| `.environment(container.authManager)` | Copies a **reference** (pointer) into SwiftUI's environment storage on the heap. ARC bumps retain count. |

> **Key insight:** Every `@Observable` store injected via `.environment()` adds +1 to its ARC retain count. The `GoodShiftApp` struct holds the root reference — when it's deallocated, ARC cascades `release` through all stores.

---

## Part B: The Dependency Container

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

#### 🔬 Hardware Deep Dive — Part B

| What Happens | Hardware Level |
|-------------|----------------|
| `AppContainer()` init | Heap allocation via `swift_allocObject`. The CPU writes the object header (metadata pointer + retain count) then each stored property. |
| `TaskGroup` in `setupUserSession` | Each `group.addTask {}` creates a **Swift Task** — a lightweight coroutine. The runtime allocates a small **async frame** on the heap (not a full OS thread). |
| 6 tasks run concurrently | The Swift concurrency runtime schedules tasks across a **cooperative thread pool** (usually = CPU core count). Each task may suspend at `await`, freeing the thread for another task. |
| `try? await self.servicesStore.setupListeners(...)` | `self` is captured by the closure — ARC increments retain count to prevent deallocation while the task runs. |
| `teardownUserSession()` | `removeAllListeners()` triggers Firestore SDK to close WebSocket connections. ARC decrements counts; when a listener's count hits 0, `swift_deallocObject` frees it. |

> **Key insight:** `TaskGroup` ≠ threads. Swift's async runtime uses **continuation stealing** — when a task suspends, another task can resume on the same thread. This is why 6 listeners can start concurrently with only 2–4 actual OS threads.

---

## Part C: The State Machine (MainView)

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

#### 🔬 Hardware Deep Dive — Part C

| What Happens | Hardware Level |
|-------------|----------------|
| `switch authManager.authState` | CPU loads the enum's **tag byte** (discriminator) from the `authManager` object on the heap into a **register**, then uses a branch table to jump to the matching case. |
| SwiftUI re-renders on state change | `@Observable` uses `withObservationTracking` — when a tracked property changes, SwiftUI marks the view as **dirty** and schedules a re-render on the **main thread** (required for UIKit under the hood). |
| `Group { ... }` | `Group` is a **zero-cost abstraction** — it produces no UIKit view. The `ViewBuilder` result is a conditional enum stored inline. |
| View switch (e.g., signedOut → signedIn) | Old view's UIKit backing (`UIHostingController`) is **deallocated** (heap freed), new one is allocated. This triggers a cascade of `deinit` → ARC release → potential deallocation of child views. |

---

## Part D: Push Notifications & App State

### 1.4 `App/Bootstrap/AppDelegate.swift`
**Path:** `GoodShift/App/Bootstrap/AppDelegate.swift`

**ELI5:** The mailman. Whenever iOS receives a push notification, it delivers it here. This file unwraps the notification, figures out what type it is, and tells the app where to navigate.

**Expert Concepts:**
- `UNUserNotificationCenterDelegate` — handles foreground + tapped notifications
- `MessagingDelegate` — receives FCM token updates
- Notification payload parsing → maps to `NotificationType` enum
- Deep-link routing via `AppCoordinator`

---

#### 🔬 Hardware Deep Dive — Part D

| What Happens | Hardware Level |
|-------------|----------------|
| Push notification arrives | iOS kernel wakes the app process (or launches it in background). The **APNS daemon** delivers the payload via **Mach IPC** (inter-process communication). |
| `AppDelegate` method called | The Objective-C runtime dispatches the selector — involves a **vtable lookup** in memory. The `userInfo` dictionary is an `NSDictionary` on the heap. |
| FCM token storage | A `String` (token) is copied from the Messaging SDK's heap allocation into your Firestore write buffer. The network stack serializes it and writes to a **socket buffer** in kernel memory. |

---

## Part E: Lightweight App State

### 1.5 `Models/Account/AppStateManager.swift`
**What It Does:** Tracks lightweight app-level state like `hasSeenOnboarding` via `@AppStorage`, keeping it separate from user data.

#### 🔬 Hardware Deep Dive — Part E

| What Happens | Hardware Level |
|-------------|----------------|
| `@AppStorage` read | Reads from `UserDefaults`, which is an **in-memory plist** (loaded from disk on app launch). Data is in the app's **heap**. No disk I/O on reads after launch. |
| `@AppStorage` write | Writes to the in-memory cache immediately, then **asynchronously** flushes to a `.plist` file on disk. The kernel batches disk writes. |

---

### Checkpoint Quiz — Phase 1
- [ ] What does `@UIApplicationDelegateAdaptor` do?
- [ ] Why does `setupUserSession` use a `TaskGroup` instead of sequential `await` calls?
- [ ] Draw the state machine in `MainView` — what are the 4 possible screens?
- [ ] What happens to all listeners when a user signs out?

### 🏋️ Practice Zone — Phase 1

**Concept: @main & App Entry Point**
- 🟢 **Easy:** What attribute marks the entry point of a SwiftUI app?
- 🟡 **Medium:** What would happen if you called a Firebase API *before* `FirebaseApp.configure()`? Why?
- 🔴 **Hard:** Explain what happens in memory (stack vs heap) when `GoodShiftApp` struct is created and its `AppContainer` class property is initialized.

**Concept: Dependency Injection via AppContainer**
- 🟢 **Easy:** Is `AppContainer` a struct or class? Why does that matter?
- 🟡 **Medium:** Rewrite `setupUserSession` to run listeners **sequentially** instead of in parallel. What's the downside?
- 🔴 **Hard:** If `setupUserSession` creates 6 concurrent tasks, how many OS threads does the Swift runtime actually use? Explain continuation stealing.

**Concept: MainView State Machine**
- 🟢 **Easy:** List the 4 possible screens MainView can show.
- 🟡 **Medium:** What SwiftUI mechanism causes MainView to re-render when `authState` changes?
- 🔴 **Hard:** When the view switches from `AuthenticationView` to `Dashboard`, what happens to the old view in memory? Trace the ARC lifecycle.

**Concept: AppDelegate & Push Notifications**
- 🟢 **Easy:** What protocol does AppDelegate conform to for handling push notifications?
- 🟡 **Medium:** Trace the path of a push notification from iOS delivery to in-app navigation.
- 🔴 **Hard:** Explain at the hardware level how a push notification wakes your app process using Mach IPC.

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 2: Design System & Theming

> **Goal:** Learn the 4-layer color system and reusable UI components.

## Part A: Color Token System

### Architecture: Tokens → Semantics → Palette → Provider

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

#### 🔬 Hardware Deep Dive — Part A

| What Happens | Hardware Level |
|-------------|----------------|
| `enum ColorToken` with string raw values | Each enum case is stored as a **single byte** (tag). The raw string values are in the binary's **__TEXT segment** (read-only, memory-mapped). |
| `Color(hex: "#37857D")` | Parses hex string into RGB floats. These 3 `Float` values (12 bytes) end up in **CPU registers** for the GPU color pipeline. |
| `SemanticColor` indirection | Zero runtime cost — the compiler **inlines** the mapping. The final machine code directly uses the hex value, no dictionary lookup at runtime. |

---

## Part B: Theme Mapping & Provider

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

#### 🔬 Hardware Deep Dive — Part B

| What Happens | Hardware Level |
|-------------|----------------|
| `UIColor(dynamicProvider:)` | Creates a **closure** allocated on the **heap**. The closure captures the palette mapping. When iOS changes appearance, UIKit calls this closure to get the resolved color. |
| Dark mode toggle | iOS posts a `traitCollectionDidChange` notification. UIKit walks the **view hierarchy** (stored as a tree in heap memory) and re-resolves all dynamic colors. |
| `Colors.swiftUIColor()` static method | The static `ColorProvider` lives in the **global data segment** (not stack, not heap). It's initialized once (lazy thread-safe init via `swift_once`). |

---

## Part C: Buttons & Text Fields

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

#### 🔬 Hardware Deep Dive — Part C

| What Happens | Hardware Level |
|-------------|----------------|
| `struct BrandButton: View` | Value type on the **stack**. When SwiftUI creates the view tree, it copies this struct (cheap — just a few bytes of properties). |
| Button tap | UIKit captures a **touch event** via the IOKit driver. The event travels: touchscreen digitizer → kernel → SpringBoard → your app's **main run loop** → UIKit hit testing → SwiftUI action closure. |
| `@available` check for iOS 26 | Compiled as a **runtime branch** — the CPU checks the OS version number stored in kernel memory. Both code paths exist in the binary. |
| `InputState` enum | 1 byte in memory (3 cases = 2 bits needed). When used in a struct, the compiler may **pack** it alongside other small fields to minimize padding. |

---

## Part D: Reusable Components

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

#### 🔬 Hardware Deep Dive — Part D

| What Happens | Hardware Level |
|-------------|----------------|
| `ServiceCard` renders | SwiftUI diffing compares the **previous** and **new** view tree (both in heap). Only changed properties trigger UIKit layer updates, which are sent to the **GPU** via Metal/Core Animation. |
| `ServiceCardSkeleton` shimmer animation | The shimmer is a **CAGradientLayer** with animated position. The GPU renders this — zero CPU cost during animation. The animation timing uses `CADisplayLink` synced to the **display refresh rate** (60/120 Hz). |
| `ConfettiView` particles | Each particle is a `CAEmitterCell` processed by the **GPU's vertex shader**. Hundreds of particles = negligible CPU load because the GPU has thousands of cores for parallel rendering. |

### Checkpoint Quiz — Phase 2
- [ ] Why does the app use `SemanticColor` instead of referencing hex values directly in views?
- [ ] What Swift API makes colors automatically adapt to light/dark mode in this design system?
- [ ] What is the `.glassEffect` modifier and why is there an `@available` check?

### 🏋️ Practice Zone — Phase 2

**Concept: Color Token System**
- 🟢 **Easy:** What are the 4 layers of the color system? List them in order.
- 🟡 **Medium:** Add a new semantic color `.warningOrange` — write the code changes needed in each layer.
- 🔴 **Hard:** Explain why `SemanticColor` has zero runtime cost (hint: compiler inlining). What would happen to performance if it used a Dictionary lookup instead?

**Concept: Dynamic Colors & Dark Mode**
- 🟢 **Easy:** What does `UIColor(dynamicProvider:)` do?
- 🟡 **Medium:** If you hardcoded a hex color instead of using `Colors.swiftUIColor()`, what breaks in dark mode?
- 🔴 **Hard:** When the user toggles dark mode, trace the full process from the Settings app to the pixel change on screen. Include: traitCollection, dynamic provider closure, GPU re-render.

**Concept: Reusable Components**
- 🟢 **Easy:** Why is `BrandButton` a struct and not a class?
- 🟡 **Medium:** Create a new `BrandChip` component (tag/badge) using the existing design system colors and patterns.
- 🔴 **Hard:** Explain why `ServiceCardSkeleton` shimmer animation uses zero CPU during animation. What hardware component runs it?

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 3: Core Utilities & Error Handling

> **Goal:** Understand the shared infrastructure that every feature depends on.

## Part A: Constants & Type Safety

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

### 3.4 `Core/StateKey.swift`
- **Generic `StateKey<T>`** — type-safe wrapper for `UserDefaults` / `@AppStorage` keys
- Prevents key typos: `StateKeys.hasSeenOnboarding` instead of raw strings

#### 🔬 Hardware Deep Dive — Part A

| What Happens | Hardware Level |
|-------------|----------------|
| `enum AppConstants` with static lets | Static strings live in the binary's **__DATA segment**. They're loaded into memory when the app launches and never deallocated. |
| `static let users = "users"` | The string literal is in read-only memory (**__TEXT segment**). The `static let` is a pointer in __DATA that points to it. |
| Compile-time type checking | The compiler catches typos **before** any code runs. This happens entirely on your Mac's CPU during build — zero runtime cost. |
| `StateKey<T>` generic | The compiler generates **specialized versions** for each `T` (monomorphization). `StateKey<Bool>` and `StateKey<String>` are different types in the binary. |

---

## Part B: Error Handling System

### 3.2 `Core/Error/AppError.swift`
- **`AppError` enum** — 5 cases: `.authentication`, `.network`, `.firestore`, `.validation`, `.unknown`
- Conforms to `LocalizedError` (user-facing messages) + `Identifiable` (SwiftUI alerts)
- **Factory method:** `AppError.from(_ error: Error)` — auto-classifies any error by its domain

### 3.3 `Core/Error/ErrorHandler.swift`
- **`ErrorHandler`** — `@Observable` class injected via environment
- Provides `handle(_:retryAction:)` and `dismiss()` for consistent error UX
- Supports optional retry closures for recoverable errors

#### 🔬 Hardware Deep Dive — Part B

| What Happens | Hardware Level |
|-------------|----------------|
| `enum AppError` (5 cases) | Stored as **1 byte** (tag/discriminator). Associated values (if any) are stored inline after the tag. |
| `AppError.from(_ error: Error)` | Uses **dynamic dispatch** (witness table lookup) because `Error` is a protocol. The CPU reads the error's type metadata from heap memory, then dispatches to the correct handler. |
| `ErrorHandler` as `@Observable` class | Lives on the **heap**. When `handle()` sets the error property, the Observation framework triggers a notification to all views tracking that property. |
| `throw` statement | CPU pushes error info onto the **stack** and unwinds call frames until it finds a `catch`. This is similar to how C++ exceptions work — relatively expensive vs returning a `Result`. |

---

## Part C: Protocols & Mocking

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

#### 🔬 Hardware Deep Dive — Part C

| What Happens | Hardware Level |
|-------------|----------------|
| `protocol FirestoreProvider` | Protocols use a **witness table** (similar to a C++ vtable) — a pointer table stored in the binary's __DATA segment. Each conforming type fills in its own function pointers. |
| `CalendarService.shared` singleton | Initialized via `swift_once` (like `dispatch_once`) — the CPU uses an **atomic compare-and-swap** instruction to ensure thread-safe initialization. The singleton lives in the **global data segment**. |
| Mock vs Real: same protocol | At the call site, the CPU reads a function pointer from the witness table and **jumps** to it. Whether it's `FirestoreService.saveUser()` or `MockFirestoreService.saveUser()`, the calling code is identical — only the pointer differs. |
| `EventKit` permission request | Triggers an **IPC call** to the `tccd` daemon (TCC = Transparency, Consent, and Control). The kernel mediates the permission check. |

### Checkpoint Quiz — Phase 3
- [ ] Why is `AppError` both `LocalizedError` and `Identifiable`?
- [ ] What does `AppError.from(_ error: Error)` do and why is it useful?
- [ ] How does the Protocol → Mock pattern improve testability?

### 🏋️ Practice Zone — Phase 3

**Concept: Compile-Safe Constants**
- 🟢 **Easy:** What's the difference between `"users"` (inline string) and `AppConstants.Firestore.users`?
- 🟡 **Medium:** Add a new constant `AppConstants.Firestore.favorites` and explain where it lives in memory.
- 🔴 **Hard:** Explain monomorphization — how does `StateKey<Bool>` vs `StateKey<String>` look different in the compiled binary?

**Concept: Error Handling**
- 🟢 **Easy:** List the 5 `AppError` cases.
- 🟡 **Medium:** Write a `do/catch` block that calls a Firestore method and converts the error using `AppError.from()`.
- 🔴 **Hard:** Compare the performance of `throw/catch` vs returning a `Result<T, AppError>` at the hardware level (stack unwinding vs return value in register).

**Concept: Protocol-Based Dependency Injection**
- 🟢 **Easy:** What is a witness table?
- 🟡 **Medium:** Write a `MockStorageService` that conforms to `StorageProvider` and returns a fake URL.
- 🔴 **Hard:** Explain why protocol dispatch is slower than direct function calls. When would the compiler optimize it away (hint: devirtualization)?

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 4: Domain Models — Data Layer

> **Goal:** Understand every data structure the app works with.

## Part A: User Model & Dual-Role System

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

#### 🔬 Hardware Deep Dive — Part A

| What Happens | Hardware Level |
|-------------|----------------|
| `struct User: Codable` | Value type — but because it has many fields (strings, arrays), each `String` and `Array` is a **heap allocation** with a pointer on the stack. Copying a `User` struct is NOT cheap — it triggers ARC retain on every reference-type field. |
| `Hashable` conformance | `hashValue` combines all fields using a **hash function**. The CPU runs arithmetic operations (XOR, multiply, rotate) in **registers**. The result is an `Int` (8 bytes). |
| `toFirestore() → [String: Any]` | Creates a `Dictionary` on the **heap**. Each key-value pair involves boxing Swift types into Objective-C `NSObject` types (because Firestore SDK is Obj-C). This bridging allocates temporary objects on the heap. |
| `isJobSeeker: Bool` | Stored as **1 byte** in the struct's memory layout. The compiler aligns it to a byte boundary. Two bools (`isJobSeeker` + `isServiceProvider`) = 2 bytes, but padding may add more. |

---

## Part B: Job Service & Status Lifecycle
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

#### 🔬 Hardware Deep Dive — Part B

| What Happens | Hardware Level |
|-------------|----------------|
| `enum ServiceStatus` (4 cases) | 1 byte tag. The lifecycle is enforced at the **software** level — the CPU doesn't know about business rules. The compiler encodes transitions as conditional branches. |
| `[Date]` array for `serviceDates` | `Array<Date>` is a **copy-on-write** (CoW) heap buffer. `Date` is a struct wrapping a `Double` (8 bytes = time interval since reference date). The array stores these inline: 8 contiguous bytes per date — excellent for **CPU cache locality**. |
| `ServiceValidator.canPublish()` static method | Static methods have **no dynamic dispatch** — the compiler emits a direct function call (`bl` instruction on ARM). No vtable, no witness table, maximum speed. |

---

## Part C: Applications, Messaging & Transactions

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

#### 🔬 Hardware Deep Dive — Part C

| What Happens | Hardware Level |
|-------------|----------------|
| `struct JobApplication: Codable` | All `String` fields are **heap pointers** (8 bytes each on ARM64). The struct itself is a contiguous block of pointers + inline value types. |
| `struct Message` with `timestamp: Date` | `Date` is 8 bytes (a `Double` representing seconds since 2001). Stored **inline** in the struct, no heap allocation. |
| `enum TransactionType` (4 cases) | 1 byte. The `sign` (+/-) is computed via a `switch` — the CPU uses a **branch table** (array of jump addresses) for fast dispatch. |
| `@AppStorage("appCurrency")` | Reads from `UserDefaults` in-memory cache (heap). The string key `"appCurrency"` is in the binary's read-only text segment. |

---

## Part D: Notifications Model

### 4.9 `Core/Notifications/Models/Notification.swift`
- Rich notification model with `NotificationPayload` containing contextual data (jobId, applicationId, conversationId, amount, etc.)
- `isExpired` computed property (90-day TTL)
- `timeAgo` computed property for display

### 4.10 `Core/Notifications/Models/NotificationType.swift`
- **20 notification types** split by role (Job Seeker vs Provider)
- Each type has: `displayName`, `category`, `priority`, `isActionable`
- 7 categories: applications, messages, jobs, reviews, earnings, matching, ratings

#### 🔬 Hardware Deep Dive — Part D

| What Happens | Hardware Level |
|-------------|----------------|
| `enum NotificationType` (20 cases) | Still 1 byte (needs 5 bits for 20 cases). Each case's associated properties (`displayName`, etc.) are computed — implemented as a switch statement that the compiler may optimize into a **lookup table** in the data segment. |
| `isExpired` computed property | CPU loads `createdAt` (a `Date`/`Double`) and the current time into **floating-point registers**, subtracts, and compares against the 90-day constant. Single instruction comparison. |
| `NotificationPayload` with optional fields | Optionals in Swift are **1 extra byte** for the "has value" flag, plus the value. A `String?` is 9 bytes (8-byte pointer + 1-byte flag). |

### Checkpoint Quiz — Phase 4
- [ ] How does the app support a user being both a job seeker and a service provider?
- [ ] What are the 4 stages of `ServiceStatus`?
- [ ] Why does `Review` store `reviewerName` directly instead of just `reviewerId`?
- [ ] What does `NotificationPayload` contain and why?

### 🏋️ Practice Zone — Phase 4

**Concept: User Model & Dual Roles**
- 🟢 **Easy:** What two Bool fields enable dual-role support? What are their names?
- 🟡 **Medium:** Write a `getCompletionPercentage(forRole:)` method that checks 5 fields. What percentage for a user with 3/5 fields filled?
- 🔴 **Hard:** Copying a `User` struct triggers ARC retain on every String field. Estimate how many ARC operations a copy performs for a fully-populated User. Is this a performance concern?

**Concept: Service Lifecycle**
- 🟢 **Easy:** List the 4 `ServiceStatus` values in the correct order.
- 🟡 **Medium:** Write validation code that prevents skipping from `.draft` directly to `.completed`.
- 🔴 **Hard:** Why are `serviceDates` stored as `[Date]` (contiguous array of Doubles) instead of `[String]`? Explain the CPU cache advantage.

**Concept: Denormalization**
- 🟢 **Easy:** What does "denormalization" mean? Give one example from the codebase.
- 🟡 **Medium:** What's the tradeoff of storing `reviewerName` on the `Review` doc vs querying the `users` collection?
- 🔴 **Hard:** Design a system where denormalized fields stay in sync when the source changes. What Firestore feature would you use?

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 5: Firebase Data Access Layer

> **Goal:** Understand how the app reads/writes to Firestore.

## Part A: The Firestore Service

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

#### 🔬 Hardware Deep Dive — Part A

| What Happens | Hardware Level |
|-------------|----------------|
| `Firestore.firestore()` singleton | Returns a reference to the Firestore SDK's C++ core, which manages a **gRPC channel** (persistent HTTP/2 connection). The channel uses a **kernel socket buffer** and TLS encryption (AES via hardware acceleration on Apple Silicon). |
| `.setData(service.toFirestore())` | Serializes the dictionary into **Protocol Buffers** (binary format). This serialized data goes into a **write buffer** in the Firestore SDK's heap memory, then is sent over the network via the kernel's TCP/IP stack. |
| `db.collection("services").document(id)` | These are lightweight **reference objects** on the heap. No network call happens here — it just builds a path string. The actual I/O only happens on `.setData()` or `.getDocument()`. |

---

## Part B: Listener Management

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

#### 🔬 Hardware Deep Dive — Part B

| What Happens | Hardware Level |
|-------------|----------------|
| `ListenerRegistration` | An opaque handle wrapping a **WebSocket connection** to Firestore servers. The kernel maintains the socket in its file descriptor table. |
| `addSnapshotListener` | Firestore SDK opens a **gRPC bidirectional stream**. The kernel allocates a socket buffer (~128KB). Incoming data triggers an **interrupt** which wakes the app's run loop. |
| `activeListeners: [String: ListenerRegistration]` | Dictionary on the heap. Keys are `String` (heap-allocated), values are `ListenerRegistration` objects (heap). ARC tracks retain counts for all. |
| `removeAllListeners()` | Calls `.remove()` on each listener → Firestore SDK closes the gRPC stream → kernel closes the socket → TCP sends FIN packet to server. ARC decrements to 0 → `swift_deallocObject` frees heap memory. |

---

## Part C: FCM & Environment Wiring

### 5.3 `Core/Notifications/Services/FCMService.swift`
- `MessagingDelegate` — receives FCM token from Firebase
- Stores token in `users/{userId}/fcmTokens/{token}` subcollection
- Includes device metadata (platform, appVersion, osVersion, deviceModel)

### 5.4 `Core/Notifications/Environment/NotificationsStoreKey.swift`
- `EnvironmentKey` for injecting `NotificationsStore` via SwiftUI's `@Environment`

#### 🔬 Hardware Deep Dive — Part C

| What Happens | Hardware Level |
|-------------|----------------|
| FCM token (a `String`) stored in Firestore subcollection | The token is ~163 characters. In Swift, short strings use **Small String Optimization** (inline, 15 bytes max). This token is too long — it gets a heap allocation. |
| `EnvironmentKey` default value | Stored as a **static property** in the global data segment. SwiftUI's environment is a **dictionary-like structure** on the heap, keyed by metatype identifiers. |

### Checkpoint Quiz — Phase 5
- [ ] Why does the app use manual `toFirestore()` / `fromFirestore()` instead of automatic Codable?
- [ ] What does the `ListenerManaging` protocol guarantee?
- [ ] What happens if `removeAllListeners()` is NOT called on logout?

### 🏋️ Practice Zone — Phase 5

**Concept: Firestore CRUD**
- 🟢 **Easy:** What method writes a document to Firestore? What method reads one?
- 🟡 **Medium:** Write a `saveReview(_ review: Review)` method following the `toFirestore()` pattern.
- 🔴 **Hard:** When `.setData()` is called, trace the full path from your Swift code to the Firestore server. Include: Protocol Buffers serialization, gRPC, TLS, TCP/IP, kernel socket buffer.

**Concept: Listener Lifecycle**
- 🟢 **Easy:** What does `removeAllListeners()` do?
- 🟡 **Medium:** What happens if you call `setupListeners()` twice without calling `removeAllListeners()` in between? What bug does this cause?
- 🔴 **Hard:** Explain what happens at the OS/kernel level when a Firestore listener is removed (socket close, TCP FIN, memory deallocation).

**Concept: Network & Data Serialization**
- 🟢 **Easy:** What are Protocol Buffers and why does Firestore use them instead of JSON?
- 🟡 **Medium:** Compare the size of a `User` object in JSON vs Protocol Buffers format. Which is smaller and why?
- 🔴 **Hard:** Explain how Apple Silicon's hardware AES acceleration speeds up the TLS encryption used by gRPC connections.

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 6: Real-Time Stores — State Management

> **Goal:** Understand how each store manages state, listeners, and reacts to real-time data.

## Part A: The Store Pattern

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

#### 🔬 Hardware Deep Dive — Part A

| What Happens | Hardware Level |
|-------------|----------------|
| `@Observable class SomeStore` | Class = heap allocation. The `@Observable` macro adds a **registrar** object (also on heap) that tracks which properties are being observed. |
| `var items: [Item] = []` | `Array` uses **copy-on-write** (CoW). The empty array starts with zero heap allocation. On first append, it allocates a buffer. The buffer pointer is stored inline in the class. |
| `var isLoading: Bool = false` | 1 byte in the class layout. When set to `true`, the Observation registrar notifies all watchers via function pointers stored in a linked list on the heap. |
| `deinit { removeAllListeners() }` | Called by ARC when retain count hits 0. The CPU runs the deinit body, then calls `swift_deallocObject` to free the heap memory. |

---

## Part B: Services & Applications Stores

### 6.1 `Models/Services/ServicesStore.swift`
- **Paginated fetching** for browse views (load more on scroll)
- Manages service lifecycle: publish, pause, resume, complete
- `bulkUpdateSharedFields(for:fields:)` — efficient batch Firestore updates
- Dual data: `myServices` (current user's) vs paginated browse services

### 6.2 `Models/Applications/ApplicationsStore.swift`
- Two Firestore listeners: one for "applications I sent" (seeker), one for "applications to my services" (provider)
- `acceptApplication(_:)` — orchestrates: accept one → reject all others → update service status to `.inProgress`
- Status transitions: `.pending` → `.accepted` / `.rejected` / `.withdrawn`

#### 🔬 Hardware Deep Dive — Part B

| What Happens | Hardware Level |
|-------------|----------------|
| Paginated fetching (load more on scroll) | Each page is a Firestore query with `.limit()` and `.start(afterDocument:)`. The cursor document's **Firestore path** is sent to the server as bytes in the gRPC request. |
| `acceptApplication` batch operation | Firestore batch = single gRPC call with multiple mutations. The server applies them **atomically** (all or nothing) using its internal transaction log. |
| `bulkUpdateSharedFields` | Batch writes are serialized into a single Protocol Buffer message, reducing network round-trips. The server processes them in a **single write transaction** on its distributed database (Spanner). |

---

## Part C: Messaging Stores

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

#### 🔬 Hardware Deep Dive — Part C

| What Happens | Hardware Level |
|-------------|----------------|
| Per-conversation listener | Each open chat creates one gRPC stream = one kernel socket. Having 1 listener per conversation (not one global) avoids downloading ALL messages across ALL chats. |
| `loadMoreMessages()` pagination | Firestore query `.order(by: "timestamp").end(before: oldestMessage)` — the server uses a **B-tree index** on timestamp for O(log n) lookup. |
| Typing indicator writes | Tiny Firestore documents (~50 bytes) written frequently. The Firestore SDK **coalesces** rapid writes to avoid flooding the network. |
| `searchConversations` (client-side) | Loads all conversations into the app's heap, then iterates with `String.contains()`. The CPU uses **SIMD string comparison** instructions on Apple Silicon for speed. |

---

## Part D: Wallet, Reviews & Notifications Stores

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

#### 🔬 Hardware Deep Dive — Part D

| What Happens | Hardware Level |
|-------------|----------------|
| `FieldValue.increment()` | Server-side atomic increment — the Firestore server uses a **compare-and-swap** (CAS) operation on the balance field. No read-modify-write race condition. |
| `unreadCount(for role:)` | Filters an array on the heap using `.filter {}`. The closure is called for each element — the CPU loads each notification's `isRead` flag from contiguous memory (good cache locality). |
| Subcollection listener (`notifications/{userId}/messages`) | Different from a root collection listener — the query path includes the userId, so the server only streams documents for this specific user. Less data over the wire. |

### Checkpoint Quiz — Phase 6
- [ ] Why does `ApplicationsStore.acceptApplication` reject all other pending applications?
- [ ] How does `WalletStore` keep the balance in sync (hint: `FieldValue.increment`)?
- [ ] Why does `MessagesStore` use a separate listener per conversation instead of one global listener?
- [ ] What is the "subcollection pattern" used by `NotificationsStore`?

### 🏋️ Practice Zone — Phase 6

**Concept: The @Observable Store Pattern**
- 🟢 **Easy:** What 3 properties does every store have in common? (Hint: items, loading, error)
- 🟡 **Medium:** Write a minimal `FavoritesStore` class following the store pattern (properties + setupListeners + removeAllListeners + deinit).
- 🔴 **Hard:** Explain copy-on-write for arrays. When does the array buffer actually get duplicated? What CPU instruction triggers the copy?

**Concept: Real-Time Listeners**
- 🟢 **Easy:** What triggers a Firestore listener to fire?
- 🟡 **Medium:** Why does `MessagesStore` create a new listener per conversation instead of one global listener for all messages?
- 🔴 **Hard:** Each listener = one gRPC stream = one kernel socket. If a user has 50 conversations, would 50 listeners be a problem? Explain in terms of file descriptors and memory.

**Concept: Batch Operations & Atomicity**
- 🟢 **Easy:** What does "atomic" mean in the context of `acceptApplication`?
- 🟡 **Medium:** Write pseudocode for accepting an application: accept one + reject others + update service status — all in one batch.
- 🔴 **Hard:** Explain how Firestore's server-side `FieldValue.increment()` prevents race conditions using compare-and-swap at the hardware level.

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 7: Navigation & Coordinator Pattern

> **Goal:** Master the app's navigation architecture — tabs, stacks, sheets, and deep links.

## Part A: The Root Coordinator

### 7.1 `Core/Navigation/AppCoordinator.swift`
**The root navigation hub.** Manages:
- Which role-specific coordinator is active (JobSeeker vs ServiceProvider)
- Role switching logic (`switchUserRole(to:)`)
- Cross-role navigation (e.g., deep-linking from a push notification)
- `navigateToChat(conversationId:)` — handles deep-link into chat from any context

#### 🔬 Hardware Deep Dive — Part A

| What Happens | Hardware Level |
|-------------|----------------|
| `@Observable AppCoordinator` | Heap-allocated class. When `switchUserRole()` changes a property, the Observation registrar iterates its subscriber list and calls update closures. |
| Role switching | Changes a stored property (1 byte enum tag). But the **SwiftUI side effect** is massive: entire view hierarchy is rebuilt. Old views deallocated (cascade of `deinit`), new views allocated. |

---

## Part B: Per-Role Coordinators

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

#### 🔬 Hardware Deep Dive — Part B

| What Happens | Hardware Level |
|-------------|----------------|
| `NavigationPath()` | Internally a **type-erased array** on the heap. Each pushed destination is boxed (heap allocation for type metadata + value). |
| `selectedTab` enum | 1 byte stored in the coordinator on the heap. Setting it triggers SwiftUI to switch which tab's view is active — the inactive tab's view tree stays in memory (not deallocated). |
| `sheetStack: [SheetDestination] = []` | Array of enums on the heap. Using an array (not single optional) enables **stacked modals** — presenting a sheet from within a sheet. |
| Independent `NavigationPath` per tab | Each path is a separate heap allocation. Pushing to Dashboard path doesn't mutate Chat path. This is why back-button works independently per tab. |

---

## Part C: Type-Safe Routes & Wiring

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

#### 🔬 Hardware Deep Dive — Part C

| What Happens | Hardware Level |
|-------------|----------------|
| `enum JobSeekerDestination` with associated values | Each case stores its associated value **inline** after the tag byte. `.serviceDetail(service)` stores the full `JobService` struct (all its bytes) inside the enum. |
| `coordinator.navigate(to:)` | Appends to `NavigationPath` → type-erases the destination (heap box allocation) → triggers SwiftUI observation → `NavigationStack` renders the new destination. |
| `coordinator.presentSheet()` | Appends to `sheetStack` array → SwiftUI's `.sheet()` modifier observes the change → UIKit creates a `UIPresentationController` which manages the presentation animation on the GPU. |

### Checkpoint Quiz — Phase 7
- [ ] Why does each tab have its own `NavigationPath`?
- [ ] What is the `sheetStack` pattern and why is it an array (not a single optional)?
- [ ] How does `selectTabAndNavigate` work for cross-tab deep linking?

### 🏋️ Practice Zone — Phase 7

**Concept: Coordinator Pattern**
- 🟢 **Easy:** What is a Coordinator? How is it different from putting navigation logic in views?
- 🟡 **Medium:** Add a new tab "Favorites" to `JobSeekerCoordinator`. What properties do you need?
- 🔴 **Hard:** Explain the memory layout of `NavigationPath` — how does type-erasure work? What's the cost of pushing a large `JobService` struct?

**Concept: Per-Tab Navigation Stacks**
- 🟢 **Easy:** What happens to the Chat tab's navigation when you push a view in Dashboard?
- 🟡 **Medium:** Write the code for `selectTabAndNavigate(to:destination:)` that switches tab then pushes a destination.
- 🔴 **Hard:** iOS keeps inactive tab views in memory. Estimate the memory cost of 4 tabs, each with a `NavigationPath` and a view tree. When would this be problematic?

**Concept: Sheet Stack**
- 🟢 **Easy:** Why is `sheetStack` an array instead of a single `SheetDestination?`?
- 🟡 **Medium:** What happens if you call `presentSheet` twice in a row? Trace the UI behavior.
- 🔴 **Hard:** When a sheet is presented, UIKit creates a `UIPresentationController`. Explain what this object manages at the GPU/animation level.

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 8: Authentication Feature

> **Goal:** Understand the full auth flow from sign-up to session management.

## Part A: Authentication Manager

### 8.1 `Models/Authentication/AuthenticationManager.swift`
**Core responsibilities:**
- Firebase Auth state listener (`Auth.auth().addStateDidChangeListener`)
- `signUp(email:password:fullName:)` → creates Firebase user → creates Firestore user document
- `signIn`, `signInAnonymously`, `signOut`
- `deleteAccount()` → calls `FirestoreService.deleteUserData()` → deletes Auth user
- Publishes `authState: .signedOut | .signedIn`
- Caches `currentUser: User?` locally via `UserCache`

#### 🔬 Hardware Deep Dive — Part A

| What Happens | Hardware Level |
|-------------|----------------|
| `Auth.auth().addStateDidChangeListener` | Firebase Auth SDK registers a callback in its internal **observer list** (heap). When auth state changes, it dispatches on the **main queue** (GCD sends work to the main thread). |
| `signUp(email:password:)` | Firebase SDK hashes the password using **PBKDF2** (CPU-intensive key derivation). On Apple Silicon, this uses hardware-accelerated crypto instructions. The hash is sent to Firebase servers over TLS. |
| `authState: .signedOut | .signedIn` | 1 byte enum. But changing it triggers `@Observable` notification → `MainView` re-renders → massive view tree swap (as covered in Phase 1). |
| `deleteAccount()` | Cascading async calls. Each `await` is a **suspension point** — the runtime saves the async frame to heap and frees the thread for other work. |

---

## Part B: User Cache & Auth View

### 8.2 `Models/Account/UserCache.swift`
- `@Observable` class that holds the current `User` in memory
- Syncs changes back to Firestore via `updateUser(_:)`
- Prevents redundant Firestore reads when user data hasn't changed

### 8.3 `Features/Authentication/AuthenticationView.swift`
- SwiftUI view with email/password fields using `BrandTextField` and `BrandPasswordField`
- Toggle between Sign In / Sign Up modes
- Error handling via `AppError` alerts

#### 🔬 Hardware Deep Dive — Part B

| What Happens | Hardware Level |
|-------------|----------------|
| `UserCache` as `@Observable` class | Heap allocation. Holds a `User?` which is 1 byte (optional flag) + the size of `User` struct (hundreds of bytes due to all the String pointers). |
| `updateUser()` writes to Firestore | The `User` struct is converted to `[String: Any]` dictionary (heap allocations for each key-value pair), then serialized to Protocol Buffers for the network. |
| `BrandTextField` for email input | Each keystroke triggers: touch event → UIKit text input system → SwiftUI binding update → `@State` change → view re-render. The text buffer grows on the heap with each character. |

### Checkpoint Quiz — Phase 8
- [ ] What happens to Firestore data when `deleteAccount()` is called?
- [ ] Why does the app use a `UserCache` instead of always reading from Firestore?
- [ ] What triggers `MainView` to switch from `AuthenticationView` to the main content?

### 🏋️ Practice Zone — Phase 8

**Concept: Auth State Management**
- 🟢 **Easy:** What are the two possible `authState` values?
- 🟡 **Medium:** Trace the full flow: user taps "Sign Up" → what happens in AuthenticationManager → what changes in MainView?
- 🔴 **Hard:** Explain the hardware steps when Firebase hashes a password (PBKDF2, hardware crypto, TLS). Why is password hashing intentionally CPU-expensive?

**Concept: User Cache**
- 🟢 **Easy:** What is `UserCache` and why does it exist?
- 🟡 **Medium:** What would happen if the app read from Firestore every time it needed the current user? Estimate the latency difference.
- 🔴 **Hard:** `UserCache` holds a `User?`. Explain the memory layout of an optional struct with heap-allocated fields.

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 9: Onboarding Feature

> **Goal:** Understand the dual-path onboarding funnel.

## Part A: Onboarding State Machine

### 9.1 `Features/Onboarding/OnboardingState.swift`
**Two paths based on role selection:**

| Path A (Job Seeker) — 12 screens | Path B (Provider) — 10 screens |
|---|---|
| welcome → roleSplit → goal → painPoints → socialProof → tinderCards → solution → categoryPrefs → locationPerm → processing → demo → notifPerm → paywall → account | welcome → roleSplit → goal → painPoints → socialProof → solution → comparison → processing → demo → notifPerm → paywall → account |

**State tracked:**
- `pathA_categories: Set<ServiceCategoryType>` — preferred job categories
- `pathA_savedShiftIds: Set<String>` — demo shifts the user "saved" (Tinder-card interaction)
- `pathB_categories`, `pathB_painPoints`

#### 🔬 Hardware Deep Dive — Part A

| What Happens | Hardware Level |
|-------------|----------------|
| `enum OnboardingScreen` (12+ cases) | 1 byte tag. The `progressValue(for:)` method is a `switch` that the compiler may optimize into an **indexed lookup table** in the data segment. |
| `Set<ServiceCategoryType>` for selected categories | Sets use a **hash table** on the heap. Inserting a category: hash the enum value (CPU registers), find bucket (memory read), store (memory write). O(1) average. |
| Two paths (12 vs 10 screens) | Both paths exist in the binary. The `switch` on role selects which path to follow. No extra memory cost for the unused path — it's just dead code at runtime. |

---

## Part B: Onboarding Views & Analytics

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

#### 🔬 Hardware Deep Dive — Part B

| What Happens | Hardware Level |
|-------------|----------------|
| `NavigationStack` with programmatic navigation | Uses `NavigationPath` (type-erased array on heap). Each `append()` triggers SwiftUI diffing → new view rendered. |
| Progress bar calculation | Simple division (current step / total steps). Done in a **floating-point register** (FP unit). Result is a `Double` used by SwiftUI to size the progress bar view. |
| `AnalyticsService.shared.track(...)` | Creates an event struct on the stack, serializes to JSON (heap allocation), enqueues to Amplitude SDK's background queue (GCD work item), then batches and sends via HTTP. |
| Tinder-card swipe gesture | `DragGesture` fires on every touch move (~60x/sec). Each callback allocates a `DragGesture.Value` on the stack. The card transform (`CGAffineTransform`) is 6 `CGFloat` values passed to Core Animation → GPU. |

### Checkpoint Quiz — Phase 9
- [ ] How many onboarding screens does a Job Seeker see vs a Service Provider?
- [ ] What is the "Tinder cards" step and how does it relate to `pathA_savedShiftIds`?
- [ ] What analytics events fire during onboarding?

### 🏋️ Practice Zone — Phase 9

**Concept: Dual-Path State Machine**
- 🟢 **Easy:** How many screens does Path A have? Path B?
- 🟡 **Medium:** Add a new screen "testimonials" to Path A after "socialProof". What code changes are needed?
- 🔴 **Hard:** The onboarding state uses `Set<ServiceCategoryType>` for selections. Explain how a hash table works at the memory level (buckets, hashing, collision resolution).

**Concept: Analytics Tracking**
- 🟢 **Easy:** What does `AnalyticsService.shared.track()` do?
- 🟡 **Medium:** Write an analytics event for a new action: user skips the paywall. Include the event name and properties.
- 🔴 **Hard:** Trace the full lifecycle of an analytics event from `track()` call to HTTP request to Amplitude servers. Include: enum → JSON serialization → GCD queue → batching → URLSession → TCP.

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 10: Notifications & Push (FCM)

> **Goal:** Understand the full notification pipeline — from push delivery to in-app display.

## Part A: Push Notification Pipeline

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

#### 🔬 Hardware Deep Dive — Notifications Pipeline

| What Happens | Hardware Level |
|-------------|----------------|
| Cloud Function sends FCM push | Google's server sends to APNs (Apple Push Notification service). APNs routes to device via persistent TCP connection maintained by the iOS kernel. |
| iOS delivers to AppDelegate | The kernel wakes your app process (allocates CPU time). The notification payload (JSON, ~4KB max) is copied from kernel buffer to your app's heap memory. |
| `NotificationsStore` listener fires | Firestore's real-time stream receives the write event. SDK deserializes the Protocol Buffer into Swift objects on the heap. |
| `NotificationDrawerView` renders list | SwiftUI creates one `NotificationCardView` struct per notification. Each is a value type on the stack. The GPU renders the visible ones; off-screen cells are not rendered (lazy loading). |
| Badge count update | `unreadCount` is computed by filtering an array. The result (an `Int`) is stored in a CPU register, then written to the badge view's property, triggering a re-render of just the badge layer on the GPU. |

### Checkpoint Quiz — Phase 10
- [ ] Where does the FCM token get stored in Firestore?
- [ ] How does a push notification result in the app navigating to the right screen?
- [ ] What is the notification subcollection pattern (`notifications/{userId}/messages`)?

### 🏋️ Practice Zone — Phase 10

**Concept: Push Notification Pipeline**
- 🟢 **Easy:** List the 6 steps from "Cloud Function sends push" to "notification shown in app".
- 🟡 **Medium:** What happens if the app is in the background when a push arrives? vs foreground?
- 🔴 **Hard:** Trace the full hardware path: Cloud Function → Google server → APNs → TCP to device → kernel wakes app → AppDelegate → coordinator deep-link. What kernel primitives are involved?

**Concept: Notification Types & Preferences**
- 🟢 **Easy:** How many notification types exist? How many categories?
- 🟡 **Medium:** Add a new notification type `jobExpired` — what properties would it need?
- 🔴 **Hard:** The `NotificationPreferences` doc is per-user. Explain the subcollection storage pattern and why it's better than embedding preferences in the User document.

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 11: Feature Views — UI Layer

> **Goal:** Understand how feature views compose stores, coordinators, and design system components.

## Part A: Provider-Role Views

### Provider-Role Views (`MainViews/ProviderViews/`)

| File | Purpose |
|------|---------|
| `HomeView.swift` | Provider dashboard — stats, calendar with job indicators, quick actions |
| `myJobs.swift` | Service management — list, status tabs, create/edit |
| `CreateJobSheet.swift` | Multi-step job creation form |
| `JobProvider.swift` | Tab wrapper for provider experience |

#### 🔬 Hardware Deep Dive — Part A

| What Happens | Hardware Level |
|-------------|----------------|
| `HomeView` with calendar & stats | Calendar grid = `LazyVGrid` — only visible cells are instantiated (lazy allocation). Stats counters involve integer arithmetic in CPU registers. |
| `CreateJobSheet` multi-step form | Each step is a separate view struct on the stack. Navigation between steps swaps views in the `NavigationStack`. Images selected from photo picker are loaded from disk into heap (potentially MB per image). |

---

## Part B: Seeker-Role Views

### Student/Seeker-Role Views (`MainViews/StudentViews/`)

| File | Purpose |
|------|---------|
| `DashboardView.swift` | Seeker homepage — browse by category, recent activity, search |
| `BrowseJobs.swift` | Category-filtered service listing with pagination |
| `AppliedJobsView.swift` | "My Applications" list with status filtering |
| `NeedWork.swift` | Tab wrapper for seeker experience |

#### 🔬 Hardware Deep Dive — Part B

| What Happens | Hardware Level |
|-------------|----------------|
| `DashboardView` browse by category | `ScrollView` with `LazyVStack` — cells are created on-demand as the user scrolls. Recycled cells have their backing UIKit views **reused** (not deallocated and reallocated). |
| Pagination (load more on scroll) | `onAppear` of the last cell triggers a Firestore query. While waiting for the async response, the UI thread is free (no blocking). New data arrives → array mutation → SwiftUI diffing → only new cells rendered. |

---

## Part C: Shared & Feature-Specific Views

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

#### 🔬 Hardware Deep Dive — Part C

| What Happens | Hardware Level |
|-------------|----------------|
| `@Environment` injection | SwiftUI stores environment values in a **dictionary-like structure** on the heap, keyed by metatype. Lookup is O(1) hash-based. |
| `ChatDetailView` message list | `List` / `LazyVStack` with potentially thousands of messages. Only visible cells exist in memory. Scroll position is tracked by Core Animation on the GPU. |
| `ServiceDetailView` with images | Images from Firebase Storage are downloaded asynchronously. The raw data (JPEG bytes) is decoded by the **Image I/O** framework (hardware-accelerated JPEG decoder on Apple Silicon). Decoded pixels go to a `CGImage` buffer on the heap, then uploaded to GPU texture memory for display. |

### Checkpoint Quiz — Phase 11
- [ ] How does `DashboardView` get its data (stores? view model? both?)
- [ ] What is the multi-step flow for creating a new job?
- [ ] How does `ChatView` handle swipe-to-delete and swipe-to-pin?

### 🏋️ Practice Zone — Phase 11

**Concept: Environment-Driven Views**
- 🟢 **Easy:** What does `@Environment(ConversationsStore.self)` do?
- 🟡 **Medium:** Write a new view that reads from `WalletStore` via environment and displays the balance.
- 🔴 **Hard:** Compare `@Environment` vs `@EnvironmentObject` vs passing stores as init parameters. What are the tradeoffs in terms of memory and coupling?

**Concept: Lazy Loading & Performance**
- 🟢 **Easy:** What is `LazyVStack` and how is it different from `VStack`?
- 🟡 **Medium:** If a list has 1000 items but only 10 are visible, how many view structs exist in memory?
- 🔴 **Hard:** Explain the full lifecycle of an image from Firebase Storage URL to pixels on screen: download → JPEG decode (hardware accelerated) → CGImage → GPU texture → display.

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 12: Analytics & Observability

> **Goal:** Understand how user actions are tracked.

## Part A: Analytics Service & Events

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

#### 🔬 Hardware Deep Dive — Analytics

| What Happens | Hardware Level |
|-------------|----------------|
| `AnalyticsEvent` enum with associated values | Each case + its associated values are stored inline. The enum's size equals the **largest case** (since Swift enums use a single memory layout for all cases). |
| `AnalyticsService.shared.track()` | Creates a dictionary from the enum's properties (heap allocation), then Amplitude SDK enqueues it to a **GCD serial queue** (ensures events are ordered). The queue batches events and sends via `URLSession` on a background thread. |
| `identify(userId:)` | Writes the userId to Amplitude's persistent storage (SQLite on disk). This involves a **file system write** → kernel buffer → disk controller → flash memory. |
| Event batching | Amplitude collects ~10 events in memory, then serializes the batch to JSON and sends one HTTP request. This amortizes the TCP connection setup cost. |

### Checkpoint Quiz — Phase 12
- [ ] Why are analytics events defined as enum cases instead of raw strings?
- [ ] What is the difference between `identify()` and `setUserProperties()`?

### 🏋️ Practice Zone — Phase 12

**Concept: Type-Safe Analytics**
- 🟢 **Easy:** Why use enum cases instead of strings for event names?
- 🟡 **Medium:** Add a new analytics event `favoriteAdded(serviceId: String)` to the `AnalyticsEvent` enum. Write the `eventName` and `properties`.
- 🔴 **Hard:** The enum's memory size equals its largest case. If one case has `[String]` (array of strings) as associated value, how does this affect ALL cases' memory? Is this a problem?

**Concept: Event Pipeline**
- 🟢 **Easy:** What is event batching and why does Amplitude use it?
- 🟡 **Medium:** What happens to analytics events if the user closes the app before the batch is sent?
- 🔴 **Hard:** Explain why Amplitude uses a GCD **serial** queue (not concurrent). What ordering guarantees does this provide?

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 13: Testing & Mocks

> **Goal:** Understand the testing infrastructure.

## Part A: Protocol Abstraction Layer

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

#### 🔬 Hardware Deep Dive — Testing Infrastructure

| What Happens | Hardware Level |
|-------------|----------------|
| Mock vs Production path | Same compiled code, different function pointers in the witness table. At runtime, the CPU follows one pointer or the other — it doesn't know or care if it's "real" or "mock". |
| `MockFirestoreService` with in-memory arrays | Arrays stored on the heap in the test process's address space. No network I/O, no disk I/O, no kernel syscalls — orders of magnitude faster than real Firestore. |
| `static let sampleData` | Static data lives in the app's **global data segment**. Initialized once (lazy, thread-safe). Available across all previews without duplication. |
| Unit test execution | XCTest runs each test in a separate method invocation. The test runner forks the process, allocates a fresh stack frame for each test, and isolates failures. |

### Checkpoint Quiz — Phase 13
- [ ] How would you write a unit test for `ApplicationsStore.acceptApplication` without hitting Firestore?
- [ ] Why does every model include `sampleData`?

### 🏋️ Practice Zone — Phase 13

**Concept: Protocol-Based Mocking**
- 🟢 **Easy:** What is the difference between `FirestoreService` and `MockFirestoreService`?
- 🟡 **Medium:** Write a test that creates a `MockFirestoreService`, saves a `User`, then retrieves it and asserts the fields match.
- 🔴 **Hard:** Why are mock-based tests faster than real Firestore tests? Quantify: network round-trip (~100ms) vs in-memory array access (~10ns). That's a factor of ____.

**Concept: Sample Data & Previews**
- 🟢 **Easy:** What is `sampleData` used for?
- 🟡 **Medium:** Add `sampleData` for a new model `Favorite`. Include 3 realistic sample items.
- 🔴 **Hard:** `static let sampleData` is lazy and thread-safe. Explain how `swift_once` works at the CPU instruction level (atomic compare-and-swap).

> 🔄 **Want to practice more on any concept? Tell your tutor!**

---

# Phase 14: Putting It All Together

> **Goal:** Trace a complete user flow end-to-end.

## Part A: The Full Job Lifecycle Flow

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

#### 🔬 Hardware Deep Dive — Full Flow

| Step | What the Hardware Does |
|------|------------------------|
| User taps "Create Job" | Touch digitizer → IOKit driver → kernel interrupt → UIKit hit test → SwiftUI action closure. |
| `ServicesStore.createService()` | Object created on heap → serialized to ProtoBuf → sent via gRPC over TLS (hardware AES) → TCP packet. |
| Firestore write propagates | Server writes to Spanner (global distributed DB) → triggers listener on other devices → gRPC push → kernel interrupt → SDK callback → `@Observable` update → SwiftUI re-render. |
| Push notification sent | Cloud Function → FCM → APNs → persistent TCP to device → kernel wakes app → AppDelegate → navigation. |
| Batch accept operation | Multiple Firestore mutations in one gRPC call → server applies atomically on Spanner → multiple listeners fire on multiple devices simultaneously. |

---

## Part B: Architecture Decision Review

### 🏋️ Practice Zone — Phase 14

**Concept: End-to-End Tracing**
- 🟢 **Easy:** List the 17 steps in the "Provider creates job, Seeker applies" flow.
- 🟡 **Medium:** Trace a DIFFERENT flow: "Seeker sends a message to Provider." List every component involved (View → Store → Firestore → Listener → View).
- 🔴 **Hard:** For the job creation flow, estimate the total number of heap allocations from button tap to Firestore confirmation. Consider: view structs, dictionaries, ProtoBuf serialization, network buffers.

**Concept: Architecture Decisions**
- 🟢 **Easy:** List 3 architecture decisions from the ADR table and explain each in one sentence.
- 🟡 **Medium:** If you replaced `@Observable` with `ObservableObject + @Published`, what would change in every store? How many lines of code?
- 🔴 **Hard:** The app uses `ListenerManaging` protocol for all stores. Design a scenario where forgetting to call `removeAllListeners()` causes a memory leak, a duplicate-data bug, AND increased Firestore billing. Explain all three.

**Concept: Full-Stack Hardware Understanding**
- 🟢 **Easy:** List the 4 memory regions we've discussed: stack, heap, global data segment, text segment.
- 🟡 **Medium:** For each region, give one example of what GoodShift stores there.
- 🔴 **Hard:** Draw a complete memory map of the GoodShift app at runtime. Include: code (text segment), global data, heap (with stores, views, Firestore SDK), stack (with function frames). Estimate sizes.

> 🔄 **Want to practice more on any concept? Tell your tutor!**

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
