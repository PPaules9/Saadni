<div align="center">

# GoodShift 🤝

### The On-Demand Services Marketplace for Your Community

**Post a task. Get it done. Earn on your schedule.**

GoodShift connects people who need everyday services with trusted local providers — instantly. Whether you need a hand around the house or want to earn extra income with your skills, GoodShift makes it effortless.

[![Swift](https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17%2B-007AFF?logo=apple&logoColor=white)](https://www.apple.com/ios)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Declarative_UI-5856D6?logo=swift&logoColor=white)](https://developer.apple.com/swiftui)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-34C759.svg)](LICENSE)

[Overview](#overview) · [How It Works](#how-it-works) · [Features](#-core-features) · [Tech Stack](#-tech-stack) · [Architecture](#-architecture) · [Roadmap](#-roadmap) · [Future Vision](#-future-vision) · [Contributing](#-contributing)

</div>

---

## Overview

**GoodShift** (Arabic: ساعدني — *"Help Me"*) is a native iOS marketplace that eliminates the friction between needing a service and getting it done. The platform operates on a simple principle: **anyone can post a task, and anyone with the right skills can fulfill it.**

The app serves two audiences through a single, unified experience:

| Role | What You Do |
|---|---|
| **Task Poster** | Describe what you need, set your budget, and choose from applicants who respond in real time. |
| **Service Provider** | Browse open tasks in your area, apply to the ones that match your skills, and earn money on your own terms. |

GoodShift is purpose-built for communities where trusted, affordable help is hard to find — and where students, freelancers, and skilled workers are ready to earn. No agencies. No middlemen. Just people helping people.

---

## How It Works

```
┌─────────────────────────────────────────────────────┐
│                    GoodShift FLOW                      │
├─────────────────────────────────────────────────────┤
│                                                     │
│   1. Sign Up       →  Google or Apple Sign-In       │
│   2. Choose Role   →  "I need help" or "I can help" │
│   3. Post / Browse →  Create a task or find one     │
│   4. Connect       →  In-app messaging & details    │
│   5. Complete      →  Rate, review, and get paid    │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**For Task Posters:**
1. Tap **"Post a Task"** and describe what you need
2. Select a category from **25+ service types**
3. Set your budget and preferred timing
4. Review incoming applications and choose a provider
5. Communicate directly through **in-app messaging**
6. Mark the task complete and leave a review

**For Service Providers:**
1. Browse available tasks filtered by category, location, and budget
2. Apply to tasks that match your skills
3. Coordinate details with the task poster via chat
4. Complete the work, get rated, and build your reputation

---

## ✨ Core Features

### Dual-Role System
Switch seamlessly between posting tasks and offering services — no need for separate accounts. Each role gets its own tailored dashboard, navigation, and workflows.

### 25+ Service Categories
From home maintenance to personal errands, Saadni covers a wide range of everyday needs:

> 🏠 Home Cleaning · ⚡ Electrical Work · 🔧 Plumbing · 🪑 Furniture Assembly · 🎨 Painting · 🌿 Gardening · 🐾 Pet Care · 👶 Babysitting · 📦 Moving Assistance · 🚗 Car Services · 🍳 Cooking · 📸 Photography · 💻 Tech Support · 🧹 Laundry · and more...

### Smart Job Discovery
Browse, search, and filter available tasks by category, urgency, and budget. Real-time updates ensure you see new opportunities the moment they go live.

### Service Portfolio Management
Providers can create and manage their service listings — complete with descriptions, pricing, and availability — building a professional profile that attracts more work.

### Personal Dashboard
Track your active tasks, pending applications, earnings history, and performance metrics — all from a unified, role-aware dashboard.

### In-App Messaging
Secure, real-time chat between task posters and providers. Coordinate scheduling, share requirements, and confirm details without leaving the app.

### Ratings & Reviews
Every completed task generates a two-way review. Over time, top-rated providers stand out — and task posters build a track record of fair, reliable postings.

### Digital Wallet
Track earnings, view transaction history, and manage your balance directly within the app.

### Modern Authentication
Fast, secure sign-in with **Google** and **Apple** — powered by Firebase Authentication. No passwords to remember.

---

## 🛠 Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **UI** | SwiftUI | Declarative, reactive interface with iOS 17+ capabilities |
| **Language** | Swift 5.9+ | Type-safe, modern concurrency with `async/await` |
| **Architecture** | MVVM + `@Observable` | Clean separation of concerns with feature-based modules |
| **Backend** | Firebase Firestore | Real-time NoSQL database for tasks, users, and messages |
| **Auth** | Firebase Auth | Secure Google & Apple Sign-In |
| **Storage** | Firebase Storage | Image uploads for service portfolios and profiles |
| **Messaging** | Firestore Listeners | Real-time chat with live message delivery |
| **DI** | Custom Container | Lightweight dependency injection for testability |
| **Navigation** | Coordinator Pattern | Centralized, type-safe navigation management |

---

## 📋 Requirements

| Requirement | Minimum Version |
|---|---|
| Xcode | 15.0+ |
| Swift | 5.9+ |
| iOS Deployment Target | 17.0+ |
| Firebase Account | Required |

---

## 🏗 Architecture

Saadni follows a **feature-first MVVM architecture** powered by Swift's `@Observable` macro for efficient, automatic state management.

```
┌──────────────────────────────────────────────────┐
│                   View Layer                     │
│          (SwiftUI Views & Components)            │
├──────────────────────────────────────────────────┤
│                ViewModel Layer                   │
│      (@Observable classes, business logic)       │
├──────────────────────────────────────────────────┤
│                  Model Layer                     │
│       (Data models, StateKey system)             │
├──────────────────────────────────────────────────┤
│                  Data Layer                      │
│     (Firebase Services, Local Persistence)       │
└──────────────────────────────────────────────────┘
```

### Key Design Decisions

- **Feature-Based Modules** — Code is organized by feature (`Chat`, `Dashboard`, `ServiceManagement`, etc.), not by architectural layer. Each module owns its views, view models, and models.
- **Type-Safe StateKey System** — A custom `StateKey<T>` pattern eliminates magic strings and ensures compile-time safety for all app-state operations.
- **Coordinator Navigation** — Centralized `AppCoordinator` manages the full navigation graph, keeping views decoupled from routing logic.
- **Dependency Injection Container** — A lightweight `AppContainer` provides all dependencies, enabling clean initialization and testability.
- **`@MainActor` Concurrency** — All UI-bound state is isolated to the main actor, ensuring thread-safe updates without boilerplate.

### Project Structure

```
Saadni/
├── App/                    # App entry point, AppCoordinator, AppContainer
├── Core/
│   ├── Constants/          # StateKey definitions, app-wide constants
│   ├── DI/                 # Dependency injection container
│   ├── Design System/      # Reusable UI components, brand tokens
│   ├── Error/              # Centralized error handling
│   ├── Navigation/         # Coordinator and routing logic
│   └── Resources/          # Assets, colors, fonts
├── Features/
│   ├── Authentication/     # Sign-in flows (Google, Apple)
│   ├── Chat/               # Real-time messaging
│   ├── CreateJobSheet/     # Task creation wizard
│   ├── Dashboard/          # Role-specific dashboards
│   ├── Onboarding/         # First-launch experience
│   ├── Profile/            # User profile management
│   ├── Reviews/            # Ratings & review system
│   ├── Search/             # Task discovery & filtering
│   ├── ServiceDetail/      # Task detail views
│   ├── ServiceManagement/  # Provider service listings
│   └── WalletView/         # Earnings & transaction tracking
├── MainViews/
│   ├── JobProviderViews/   # Task poster UI
│   ├── NeedWorkViews/      # Service provider UI
│   └── ChatViews/          # Messaging UI
└── Modules/
    ├── Account/            # User account services
    ├── Applications/       # Job application logic
    ├── Authentication/     # Auth service layer
    ├── Firebase/           # Firebase configuration
    ├── Messaging/          # Chat backend services
    ├── Reviews/            # Review data services
    ├── Services/           # Service listing management
    └── Wallet/             # Wallet & transaction services
```

---

## 🗺 Roadmap

### ✅ Phase 1 — Foundation *(Complete)*
- [x] Dual-role authentication (Google & Apple Sign-In)
- [x] Role-based onboarding with guided walkthroughs
- [x] Type-safe state management with `StateKey` + `@Observable`
- [x] 25+ service category system
- [x] Task creation and posting workflow
- [x] Service provider portfolio and listing management
- [x] Real-time in-app messaging with Firestore
- [x] Dashboard with active tasks, earnings, and metrics
- [x] Ratings and reviews system
- [x] Digital wallet and transaction history
- [x] User profile and account management
- [x] Search and discovery with category filtering

### 🔄 Phase 2 — Enhancement *(In Progress)*
- [ ] Map-based location discovery and proximity filtering
- [ ] Push notifications for new tasks, messages, and status updates
- [ ] Advanced search with multi-filter support (price, distance, rating)
- [ ] Payment gateway integration
- [ ] Media sharing in chat (images, voice notes)

### 📅 Phase 3 — Scale *(Planned — Q3 2026)*
- [ ] Provider verification and badge system
- [ ] Scheduling and calendar integration
- [ ] Repeat task automation
- [ ] Analytics dashboard for top providers
- [ ] Referral rewards program

---

## 🔮 Future Vision

Beyond the current roadmap, Saadni is evolving into a **context-aware services platform** — one that doesn't just list tasks, but actively anticipates what users need and connects them to help in seconds. Here's where we're headed:

---

### 🎯 Instant Task Matching — *"Need It Now" Scenarios*

Saadni will introduce **smart, contextual prompts** that surface the right service at the right time — turning common needs into one-tap actions.

#### 🎪 Event Staffing On Demand

> **Organizing an event?** Whether it's a private party, a corporate gathering, or a campus event — you shouldn't have to scramble for staff. Saadni will let event organizers instantly post shifts for **security personnel, event setup crews, servers, photographers, or cleanup teams**. Providers in the area see the shift, claim it, and show up. No agencies, no phone calls — just tap, post, and staff your event in minutes.
>
> **How it works:**
> - Select **"I'm organizing an event"** from the quick-action menu
> - Choose the type of help you need (security, catering staff, setup crew, etc.)
> - Set the date, time, location, and pay rate
> - The shift goes live immediately — nearby providers can claim it in real time
> - Track confirmations and communicate with your team directly in-app

#### 🚗 On-Demand Car Care

> **Need your car washed but don't have time to drive to a car wash?** Saadni will bring the service to you. Post a mobile car wash request, and a nearby provider handles it at your location — at home, at the office, or wherever your car is parked. It's convenient for you and it's income for students and freelancers looking to earn on a flexible schedule.
>
> **How it works:**
> - Tap **"Car Care"** and select the service (exterior wash, interior detailing, full service)
> - Drop a pin or share your current location
> - Set your preferred time window
> - A verified provider accepts and heads to your location
> - Track their arrival, confirm completion, and pay — all in-app

---

### 🧠 Smart Service Suggestions

Over time, Saadni will learn from usage patterns and proactively suggest services:

- **Recurring tasks** — "You booked a home cleaning last month. Want to schedule another?"
- **Seasonal prompts** — "Summer's here — need your garden maintained?"
- **Event-aware** — "Graduation season is coming. Looking for photographers or caterers?"
- **Time-of-day awareness** — "Running late? Get someone to handle your errands."

The goal is to reduce friction to zero: **you think it, Saadni offers it.**

---

### 🏪 Service Provider Storefronts

Top-rated providers will be able to create **branded storefronts** — a dedicated page showcasing their services, pricing tiers, availability calendar, portfolio images, and reviews. Clients will be able to browse storefronts, compare providers, and book directly.

---

### 🤝 Community Trust Layer

Saadni will introduce an **enhanced trust system** designed to make both sides of every transaction feel safe:

- **Identity verification** — Government ID or university ID verification for providers
- **Background check badges** — Optional, verified badges that signal trustworthiness
- **Escrow payments** — Funds held securely until the task is marked complete by both parties
- **Dispute resolution** — Built-in mediation for edge cases, protecting both posters and providers

---

### 📊 Provider Growth Tools

For providers who treat Saadni as a primary income source, we'll offer:

- **Earnings analytics** — Weekly and monthly breakdowns with trend insights
- **Performance coaching** — Tips based on response time, completion rate, and review scores
- **Priority listing** — High-performing providers surface first in search results
- **Skill badges** — Earn certifications for categories (e.g., "Verified Electrician", "Top-Rated Cleaner")

---

## 🤝 Contributing

Contributions are welcome. Here's how to get involved:

1. **Fork** the repository
2. **Branch** from `main`: `git checkout -b feature/your-feature`
3. **Implement** your changes following the conventions below
4. **Commit** with clear messages: `git commit -m "Add: clear description"`
5. **Push** to your fork: `git push origin feature/your-feature`
6. **Open** a Pull Request with a detailed description

### Code Conventions

- Follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use `@Observable` + `@MainActor` for all view models
- Organize code by feature, not by layer
- Use `async/await` for all asynchronous operations
- Ensure zero compiler warnings before submitting

### Reporting Issues

Use [GitHub Issues](https://github.com/PPaules9/Saadni/issues) — include device model, iOS version, and clear reproduction steps. Screenshots and screen recordings are always helpful.

---

## 📄 License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for full terms.

---

<div align="center">

**Built by [Pavly Paules](https://github.com/PPaules9)**

📧 [GitHub Issues](https://github.com/PPaules9/Saadni/issues) · 💬 [Discussions](https://github.com/PPaules9/Saadni/discussions)

⭐ If Saadni is useful to you, consider starring the repository.

---

*Saadni — Help Made Simple. Connections Made Easy.*

[⬆ Back to Top](#saadni-)

</div>
