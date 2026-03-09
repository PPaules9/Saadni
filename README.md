# Saadni 🤝

<div align="center">

**Help Made Simple. Connections Made Easy.**

Connect with skilled service providers nearby or offer your services to earn money.

[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange?logo=swift)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17%2B-blue?logo=apple)](https://www.apple.com/ios)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Modern-purple?logo=swift)](https://developer.apple.com/swiftui)

[About](#about) • [Features](#features) • [Tech Stack](#tech-stack) • [Installation](#installation) • [Architecture](#architecture) • [Contributing](#contributing)

</div>

---

## About

**Saadni** (Arabic for "Help Me") is a community-driven iOS marketplace that bridges the gap between people needing services and skilled service providers. Built with modern Swift and SwiftUI, Saadni provides a seamless experience for both job seekers looking to earn extra income and users seeking reliable local services across 25+ categories.

The app features a sophisticated dual-role system, real-time state management with @Observable, and Firebase integration for secure authentication and data persistence.

---

## ✨ Features

- **🎯 Dual-Role System** – Seamless switching between Job Seeker and Service Provider modes with role-specific dashboards
- **🏠 25+ Service Categories** – Home cleaning, electrical work, plumbing, furniture assembly, painting, gardening, pet care, babysitting, moving assistance, and more
- **📱 Intuitive Job Discovery** – Browse, filter, and apply to nearby service requests with real-time availability
- **💼 Service Portfolio** – Create and manage your service offerings with descriptions, images, and pricing
- **📊 Personal Dashboard** – Track active jobs, earnings, bookings, transaction history, and performance metrics
- **💬 In-App Messaging** – Secure, real-time communication to arrange logistics and service details
- **🔐 Modern Authentication** – Google & Apple Sign-In with Firebase backend
- **🎨 Type-Safe State Management** – Custom `StateKey` system with `@Observable` for reliable app state handling
- **📍 Location-Based Matching** – Find services and providers in your neighborhood
- **⭐ Ratings & Reviews** – Build trust with transparent community feedback

---

## 📸 Screenshots

| Onboarding | Role Selection | Job Seeker Dashboard | Service Provider |
|------------|----------------|----------------------|------------------|
| ![Onboarding](https://via.placeholder.com/300x600?text=Onboarding) | ![Role Selection](https://via.placeholder.com/300x600?text=Role+Selection) | ![Job Seeker](https://via.placeholder.com/300x600?text=Job+Seeker) | ![Provider](https://via.placeholder.com/300x600?text=Provider) |

*Screenshots coming soon. .....:*
```
/Resources/Screenshots/
├── onboarding.png
├── role-selection.png
├── job-seeker-dashboard.png
└── service-provider-dashboard.png
```

---

## 🛠 Tech Stack

| Layer | Technology | Details |
|-------|-----------|---------|
| **UI Framework** | SwiftUI | Modern, declarative UI with @Observable |
| **Language** | Swift 5.9+ | Type-safe, concurrency-aware code |
| **Architecture** | MVVM + @Observable | Feature-based module organization |
| **Backend** | Firebase | Firestore (database), Authentication, Storage |
| **State Management** | @Observable + StateKey | Type-safe, observable state with async/throws |
| **Authentication** | Firebase Auth | Google & Apple Sign-In |
| **Real-time Messaging** | Firestore Listeners | Live messaging & notifications |
| **Image Handling** | Firebase Storage | Secure image uploads & retrieval |

---

## 📋 Requirements

- **Xcode:** 15.0 or later
- **Swift:** 5.9 or later
- **iOS:** 17.0 or later
- **CocoaPods:** For Firebase dependency management
- **Firebase Account:** For backend services

---

## 📖 Usage

### For Job Seekers

1. **Sign Up** – Use Google or Apple Sign-In to create your account
2. **Select Role** – Choose "I want to earn money" during onboarding
3. **Browse Jobs** – Explore available services in your area
4. **Apply** – Select a job and submit your application
5. **Communicate** – Use in-app messaging to arrange details
6. **Complete & Earn** – Finish the service and receive ratings & payments

### For Service Providers

1. **Sign Up** – Use Google or Apple Sign-In to create your account
2. **Select Role** – Choose "I need help with something" during onboarding
3. **Post Service** – Describe what you need and select from 25+ categories
4. **Wait for Applications** – Receive applications from available job seekers
5. **Select & Communicate** – Choose a provider and arrange logistics
6. **Rate & Review** – Provide feedback after service completion

### Key Flows

```
App Launch
    ↓
[Onboarding Check] → Show onboarding if needed
    ↓
[Role Selection Check] → Direct to role-specific dashboard
    ↓
[Authenticated] → Main dashboard
    └─ Job Seeker Mode: Browse, apply, message, earn
    └─ Service Provider Mode: Post, receive offers, message, pay
```

---

## 🏗 Architecture

### MVVM with @Observable

Saadni uses a modern MVVM architecture with Swift's `@Observable` macro (iOS 17+):

```
View Layer (SwiftUI)
    ↓ (observes)
ViewModel (@Observable class)
    ↓ (coordinates)
Model Layer (Data structures, StateKey)
    ↓ (persists)
Data Layer (Firebase, UserDefaults)
```

### Key Architectural Components

**AppStateManager**
- Manages global app state (onboarding status, role selection)
- Uses `@Observable` for automatic SwiftUI binding
- Implements `PersistenceProvider` protocol for flexible storage
- Includes async/throws error handling

**StateKey System**
- Type-safe key-value storage
- Prevents magic string errors
- Supports any type with `StateKey<T>`
- Located in: `Saadni/Core/Constants/StateKey.swift`

**Feature Modules**
- Organized by feature, not layer
- Each feature has Views, ViewModels, Models, Services
- Example: `Features/AddService/`, `MainViews/JobSeekerMainView/`

**Async/Await Concurrency**
- All async operations use Swift's modern async/await
- Error handling with throws and try/catch
- Main thread updates with `@MainActor`

### Memory & Performance

- **ARC (Automatic Reference Counting)** for automatic memory management
- **Stack vs Heap** allocation optimized for value vs reference types
- **Observable Macro** ensures efficient change detection
- **UserDefaults Caching** for fast app state restoration

---

## 🗺 Roadmap

### Phase 1 (Current)
- [x] Dual-role authentication system
- [x] Role-based onboarding flows
- [x] Type-safe state management
- [ ] Service category management
- [ ] Job listing & discovery

### Phase 2 (Q2 2026)
- [ ] In-app messaging system
- [ ] Real-time notifications
- [ ] Map-based location discovery
- [ ] Application management

### Phase 3 (Q3 2026)
- [ ] Ratings & reviews system
- [ ] Payment integration
- [ ] Advanced filtering & search
- [ ] Push notifications

### Phase 4 (Q4 2026)
- [ ] Analytics & performance dashboards
- [ ] Referral program
- [ ] Service portfolio marketplace
- [ ] Advanced messaging with media

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Getting Started

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Write or update tests
5. Commit with clear messages: `git commit -m "Add: clear description"`
6. Push to your fork: `git push origin feature/your-feature`
7. Open a Pull Request

### Contribution Guidelines

- Follow Swift [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable and function names
- Add comments for complex logic
- Ensure code compiles without warnings
- Test on iOS 17+ devices/simulators
- Update README if adding new features

### Code Style

```swift
// ✅ Good
@Observable
class UserViewModel {
    @MainActor var isLoading = false

    func fetchUser() async throws {
        // Implementation
    }
}

// ❌ Avoid
class UserVM {
    var loading: Bool = false
    func fetch() {
        // Implementation
    }
}
```

### Reporting Issues

- Use [GitHub Issues](https://github.com/PPaules9/Saadni/issues)
- Include device model, iOS version, and steps to reproduce
- Attach screenshots or screen recordings when helpful

---

## 📄 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

The MIT License permits free use, modification, and distribution of the code, provided that the original license and copyright notice are included.

---

## 📬 Contact & Author

**Developer:** Pavly Paules
**GitHub:** [@PPaules9](https://github.com/PPaules9)
**Email:** [your-email@example.com](mailto:your-email@example.com)
**LinkedIn:** [Your LinkedIn Profile](https://linkedin.com/in/yourprofile)

### Support

- 📧 Report bugs: [GitHub Issues](https://github.com/PPaules9/Saadni/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/PPaules9/Saadni/discussions)
- ⭐ Found it helpful? Star the repository!

---

<div align="center">

**Made with ❤️ by Pavly Paules**

*Help Made Simple. Connections Made Easy.*

[⬆ Back to Top](#saadni-)

</div>
