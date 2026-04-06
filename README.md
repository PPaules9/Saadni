<div align="center">

# GoodShift

### The On-Demand Gig Services Marketplace

**Post a shift. Get it filled. Earn on your schedule.**

GoodShift connects businesses and individuals who need reliable, short-notice workers with skilled local providers — instantly. Whether you need staff for a shift or want to earn income on your own terms, GoodShift makes it seamless.

[![Swift](https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17%2B-007AFF?logo=apple&logoColor=white)](https://www.apple.com/ios)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Declarative_UI-5856D6?logo=swift&logoColor=white)](https://developer.apple.com/swiftui)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-34C759.svg)](LICENSE)

[Overview](#overview) · [How It Works](#how-it-works) · [Features](#-core-features) · [Tech Stack](#-tech-stack) · [Architecture](#-architecture) · [Roadmap](#-roadmap) · [Contributing](#-contributing)

</div>

---

## Overview

**GoodShift** is a native iOS two-sided marketplace built for the gig economy. It connects **Job Posters** — businesses and individuals needing workers for shifts and tasks — with **Service Providers** — freelancers, students, and skilled workers ready to earn flexibly.

The platform targets industries that rely on short-notice staffing: food & beverage, retail, logistics, hospitality, security, cleaning, and more. No recruitment agencies, no middlemen — just direct connections between people who need work done and people ready to do it.

| Role | What You Do |
|---|---|
| **Job Poster** | Describe the shift, set pay, location, and requirements — then choose from applicants who respond in real time. |
| **Service Provider** | Browse available shifts across 25+ categories, apply with optional cover messages or counter-offers, and earn on your schedule. |

---

## How It Works

```
┌─────────────────────────────────────────────────────────┐
│                    GoodShift Flow                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. Sign Up        →  Google or Apple Sign-In           │
│  2. Choose Role    →  "I need help" or "I can help"     │
│  3. Post / Browse  →  Create a shift or find one        │
│  4. Apply & Hire   →  Review applicants, accept, chat   │
│  5. Complete       →  Mark done, rate, and get paid     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**For Job Posters:**
1. Tap **"Post a Job"** and fill in the shift details
2. Specify category, pay, location, schedule, dress code, and number of workers needed
3. Review incoming applications from providers with profiles and ratings
4. Accept an applicant and coordinate via **in-app messaging**
5. Confirm completion and leave a review — payment is tracked in-app

**For Service Providers:**
1. Browse available shifts filtered by category, location, and pay rate
2. Apply with an optional cover message or counter-offer price
3. Communicate with the job poster and confirm shift details via chat
4. Complete the shift, request payment confirmation, and build your reputation

---

## ✨ Core Features

### Dual-Role System
One account, two modes. Switch seamlessly between posting jobs and offering services. Each role gets a tailored dashboard, navigation, and workflow without requiring separate accounts.

### 25+ Service Categories
GoodShift covers industry-specific shift categories organized into 9 groups:

| Group | Examples |
|---|---|
| Food & Beverage | Baristas, kitchen staff, servers, delivery |
| Retail & Malls | Sales associates, stockroom, cashiers |
| Logistics & Warehousing | Packing, sorting, loading, inventory |
| Cleaning & Maintenance | Office cleaning, deep cleaning, maintenance |
| Petrol & Automotive | Fuel attendants, car wash, detailing |
| Security & Crowd Management | Event security, access control, guards |
| Hospitality & Events | Event setup, hosting, catering, cleanup |
| Moving & Labour | Heavy lifting, relocation, furniture assembly |
| Community & Outdoor | Landscaping, community events, outdoor work |

### Job Posting Wizard
A guided 6-step creation flow captures everything a provider needs: title, description, category, pay rate, payment timing, location (with floor/unit/landmark support), dress code, break duration, branch name, and number of workers required.

### Application System
Providers apply with optional cover messages and counter-offer pricing. Job posters review applications, view provider profiles and ratings, and accept or reject with a response message. Application status updates are tracked end-to-end.

### Real-Time In-App Messaging
Firestore-powered chat between job posters and providers. Conversations are sorted by most recent activity. Tapping a push notification deep-links directly into the relevant conversation.

### Ratings & Reviews
Two-way reviews after every completed shift. 5-star rating with optional text comments. Review history tracked separately for received and submitted reviews. Providers build verified reputations over time.

### Push Notifications
Full Firebase Cloud Messaging (FCM) integration covering 14+ notification types:
- New application received, accepted, or rejected
- New message from a provider or poster
- Shift start reminders and expiry warnings
- Completion requests, disputes, and confirmations
- Earnings received, withdrawals processed, top-ups completed
- Low rating alerts

### Digital Wallet
Real-time transaction history covering earnings, withdrawals, top-ups, and platform fees. Balance tracking with the last 50 transactions displayed, categorized by transaction type.

### User Profiles
Provider profiles include ratings, review counts, response time, completion rate, acceptance rate, verification level, and badge indicators. Task posters have their own profile with posting history and trust signals.

### Multi-Language Support
Full localization for English and Arabic, including RTL layout support.

---

## 🛠 Tech Stack

### Core

| Layer | Technology | Details |
|---|---|---|
| **Language** | Swift 5.9+ | `async/await`, `@Observable`, strict concurrency |
| **UI Framework** | SwiftUI | Declarative UI, iOS 17+ features, `@Observable` state |
| **Minimum Target** | iOS 17.0+ | Required for `@Observable` macro support |
| **IDE** | Xcode 15.0+ | Swift Package Manager for dependencies |

### Backend & Infrastructure

| Service | Provider | Purpose |
|---|---|---|
| **Database** | Firebase Firestore | Real-time NoSQL — all app data (users, jobs, messages, reviews, wallet) |
| **Authentication** | Firebase Auth | Google Sign-In, Apple Sign-In, session management |
| **File Storage** | Firebase Storage | Profile photos, service/job images |
| **Push Notifications** | Firebase Cloud Messaging (FCM) | 14+ notification types, multi-device token management, deep linking |
| **Cloud Functions** | Firebase Functions (Node.js) | Server-side logic, notification dispatch, business rule enforcement |
| **Remote Config** | Firebase Remote Config | Feature flags and remote configuration |

### Third-Party Libraries

| Library | Version | Purpose |
|---|---|---|
| **Kingfisher** | Latest | Async image loading with in-memory (100 MB) and disk (500 MB, 7-day) caching |
| **AmplitudeSwift** | 7.x | Product analytics — event tracking, user identification, session management |

### Architecture & Patterns

| Pattern | Implementation |
|---|---|
| **MVVM** | `@Observable` ViewModels with `@MainActor` isolation |
| **Coordinator** | `AppCoordinator` → `ProviderCoordinator` / `StudentCoordinator` |
| **Dependency Injection** | `AppContainer` — centralized store and service initialization |
| **Repository Pattern** | `FirestoreService`, `StorageService`, `AuthenticationManager` |
| **Store Pattern** | Real-time `@Observable` stores with Firestore snapshot listeners |

---

## 📋 Requirements

| Requirement | Version |
|---|---|
| Xcode | 15.0+ |
| Swift | 5.9+ |
| iOS Deployment Target | 17.0+ |
| Firebase Project | Required (Firestore, Auth, Storage, FCM enabled) |

---

## 🏗 Architecture

GoodShift is built on a **feature-first MVVM + Coordinator** architecture, using Swift's `@Observable` macro for automatic, efficient state propagation throughout the app.

```
┌─────────────────────────────────────────────────────────┐
│                      View Layer                         │
│             (SwiftUI Views & Components)                │
├─────────────────────────────────────────────────────────┤
│                   ViewModel Layer                       │
│        (@Observable classes, @MainActor isolated)       │
├─────────────────────────────────────────────────────────┤
│                     Store Layer                         │
│    (Real-time @Observable stores, Firestore listeners)  │
├─────────────────────────────────────────────────────────┤
│                     Data Layer                          │
│        (FirestoreService, StorageService, Auth)         │
└─────────────────────────────────────────────────────────┘
```

### Key Design Decisions

- **Feature-Based Modules** — Code organized by feature (`Chat`, `Dashboard`, `ServiceDetail`, etc.). Each module owns its views, view models, and any local models.
- **Coordinator Navigation** — `AppCoordinator` delegates to role-specific coordinators (`ProviderCoordinator`, `StudentCoordinator`), keeping views completely decoupled from routing logic.
- **AppContainer (DI)** — A central `AppContainer` initializes and owns all stores and services. Session setup (`setupUserSession`) activates all real-time listeners concurrently. Logout (`clearUserSession`) removes listeners and clears state cleanly.
- **`@Observable` + `@MainActor`** — All ViewModels and Stores use Swift's `@Observable` macro, ensuring automatic SwiftUI re-renders with zero boilerplate. `@MainActor` isolation guarantees thread-safe UI updates.
- **ListenerManaging Protocol** — All Firestore-backed stores implement a common `ListenerManaging` protocol, ensuring consistent listener lifecycle (attach, detach, cleanup).

### Project Structure

```
GoodShift/
├── App/
│   ├── Bootstrap/
│   │   ├── AppDelegate.swift          # FCM setup, notification handling
│   │   ├── AppContainer.swift         # Central DI container
│   │   └── AppStateManager.swift      # App-level state
│   ├── GoodShiftApp.swift             # Main entry point
│   └── MainView.swift                 # Auth state routing
├── Core/
│   ├── Analytics/                     # Amplitude event tracking
│   ├── Design System/                 # UI components, color tokens, typography
│   ├── DI/                            # Mock services for testing
│   ├── Error/                         # Centralized error handling
│   ├── Navigation/                    # Coordinators and routing destinations
│   ├── Notifications/                 # FCM, notification types, NotificationsStore
│   ├── Protocols/                     # Shared abstract interfaces
│   └── Resources/                     # GoogleService-Info.plist, Info.plist, assets
├── Features/
│   ├── Authentication/                # Sign-in flows (Google, Apple)
│   ├── Chat/                          # Chat ViewModels
│   ├── ChatViews/                     # Chat UI (list + detail)
│   ├── CreateJobSheet/                # 6-step job posting wizard
│   ├── Dashboard/                     # Role-specific dashboards
│   ├── JobCompletion/                 # Completion request and dispute flow
│   ├── Onboarding/                    # First-launch experience
│   ├── Profile/                       # User profile and account management
│   ├── Reviews/                       # Review submission UI
│   ├── Role Selection/                # Role picker
│   ├── Search/                        # Search filters and discovery
│   ├── ServiceDetail/                 # Job detail view + application flow
│   ├── ServiceManagement/             # Provider service listing management
│   └── WalletView/                    # Earnings and transaction history
├── MainViews/
│   ├── ProviderViews/                 # Job poster tab UI
│   ├── StudentViews/                  # Service provider tab UI
│   └── Shared/                        # Shared tab views (Chat, Profile)
└── Models/                            # Data models, Firestore stores, service layer
```

---

## 🗺 Roadmap

### ✅ Phase 1 — Core Platform *(Shipped)*

**Authentication & Onboarding**
- [x] Google Sign-In and Apple Sign-In via Firebase Auth
- [x] Role selection at first launch (Job Poster / Service Provider)
- [x] Guided onboarding flow per role

**Job Posting & Discovery**
- [x] 6-step job creation wizard (title, category, pay, location, schedule, requirements)
- [x] 25+ service categories across 9 industry groups
- [x] Paginated job feed (infinite scroll, 20 items per page)
- [x] Category-based filtering and real-time search

**Application & Hiring Flow**
- [x] Apply to jobs with optional cover message and counter-offer pricing
- [x] Job poster reviews applicants, views profiles and ratings
- [x] Accept / reject applications with response messages
- [x] End-to-end application status tracking

**Communication**
- [x] Real-time in-app messaging via Firestore snapshot listeners
- [x] Conversation list sorted by most recent activity
- [x] Push notification deep-linking directly to conversations

**Completion & Payments**
- [x] Completion request flow with dispute handling
- [x] Two-way ratings and reviews (5-star + text)
- [x] Digital wallet with transaction history (earnings, fees, withdrawals, top-ups)

**Notifications**
- [x] Firebase Cloud Messaging (FCM) with 14+ notification types
- [x] Multi-device FCM token management
- [x] Foreground notification handling (banners, sounds, badges)
- [x] Notification preferences management

**Profiles & Trust**
- [x] Provider stats: response time, completion rate, acceptance rate
- [x] User verification levels and account status
- [x] Profile completion percentage per role
- [x] Multi-address management (saved addresses per user)

**Platform**
- [x] Multi-language support (English + Arabic, RTL layout)
- [x] Firebase Cloud Functions (server-side logic and notification dispatch)
- [x] Amplitude analytics integration
- [x] Kingfisher image caching

---

### 🔄 Phase 2 — Growth & Payments *(In Progress)*

**Payments**
- [ ] Payment gateway integration (in-app payments, not just tracking)
- [ ] Escrow: funds held until both parties confirm completion
- [ ] Automated payout scheduling

**Discovery**
- [ ] Map-based job discovery with proximity radius filtering
- [ ] Advanced multi-filter search (distance, pay range, rating, availability)
- [ ] Saved searches and job alerts

**Messaging**
- [ ] Image sharing in chat
- [ ] Voice messages

**Trust & Verification**
- [ ] Government or university ID verification for providers
- [ ] Background check badge (optional, third-party integrated)
- [ ] Dispute resolution and mediation flow

---

### 📅 Phase 3 — Scale & Intelligence *(Planned — Q4 2026)*

**Provider Growth**
- [ ] Provider analytics dashboard (earnings trends, completion rates, category breakdown)
- [ ] Performance coaching tips based on ratings, response time, and completion rate
- [ ] Priority listing for high-performing providers
- [ ] Skill badge certifications (e.g., "Verified Barista", "Top-Rated Security")

**Automation & Intelligence**
- [ ] Recurring shift automation ("Re-post this shift every Friday")
- [ ] Smart shift suggestions based on past activity and seasonal trends
- [ ] AI-assisted job description generation for posters

**Platform**
- [ ] Provider storefronts with branded pages, portfolio, availability calendar
- [ ] Referral rewards program for both roles
- [ ] Scheduling and calendar integration
- [ ] Android app

---

## 🤝 Contributing

Contributions are welcome. Here's how to get involved:

1. **Fork** the repository
2. **Branch** from `Develop`: `git checkout -b feature/your-feature`
3. **Implement** your changes following the conventions below
4. **Commit** with clear messages: `git commit -m "Add: clear description"`
5. **Push** to your fork: `git push origin feature/your-feature`
6. **Open** a Pull Request against `Develop` with a detailed description

### Code Conventions

- Follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use `@Observable` + `@MainActor` for all ViewModels
- Organize code by feature, not by architectural layer
- Use `async/await` for all asynchronous operations
- Activate and deactivate Firestore listeners through the `ListenerManaging` protocol
- Zero compiler warnings required before submitting

### Reporting Issues

Use [GitHub Issues](https://github.com/PPaules9/GoodShift/issues) — include device model, iOS version, and clear reproduction steps. Screenshots or screen recordings are always helpful.

---

## 📄 License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for full terms.

---

<div align="center">

**Built by [Pavly Paules](https://github.com/PPaules9)**

[GitHub Issues](https://github.com/PPaules9/GoodShift/issues) · [Discussions](https://github.com/PPaules9/GoodShift/discussions)

If GoodShift is useful to you, consider starring the repository.

---

*GoodShift — Work Made Simple. Connections Made Easy.*

[Back to Top](#goodshift)

</div>
