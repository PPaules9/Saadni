import SwiftUI

struct OnboardingView: View {
 @State private var currentPage = 0
 @Environment(AppStateManager.self) var appStateManager

 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   VStack(spacing: 0) {
    // TabView with 3 pages
    TabView(selection: $currentPage) {
     // Page 1
     OnboardingPage(
      title: "Find Help Anywhere",
      subtitle: "Discover services and connect with skilled professionals in your area",
      imageName: "magnifyingglass.circle.fill",
      imageColor: .accent
     )
     .tag(0)
     
     // Page 2
     OnboardingPage(
      title: "Offer Your Skills",
      subtitle: "Share your expertise and earn by helping others with what you do best",
      imageName: "briefcase.circle.fill",
      imageColor: .accent
     )
     .tag(1)
     
     // Page 3
     OnboardingPage(
      title: "Build Your Community",
      subtitle: "Rate, review, and build trust with your network",
      imageName: "heart.circle.fill",
      imageColor: .accent
     )
     .tag(2)
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .frame(maxHeight: .infinity)
    
    // Page Indicator
    VStack(spacing: 24) {
     HStack(spacing: 8) {
      ForEach(0..<3, id: \.self) { index in
       Capsule()
        .fill(currentPage == index ? Color.accent : Colors.swiftUIColor(.textSecondary))
        .frame(width: currentPage == index ? 24 : 8, height: 8)
        .animation(.easeInOut, value: currentPage)
      }
     }
     
     // Buttons
     HStack(spacing: 12) {
      // Skip button (only show on first two pages)
      if currentPage < 2 {
       BrandButton("Skip", hasIcon: false, icon: "", secondary: true) {
        Task {
         try await appStateManager.completeOnboarding()
        }
       }
      } else {
       BrandButton("Skip", hasIcon: false, icon: "", secondary: true) {
        nextPage()
       }
      }
      
      // Next/Get Started button
      BrandButton(currentPage == 2 ? "Get Started" : "Next", hasIcon: false, icon: "", secondary: false) {
       nextPage()
      }
     }
    }
    .padding(24)
    .background(Color(Colors.swiftUIColor(.appBackground)))
   }
  }
 }
 
 private func nextPage() {
  if currentPage < 2 {
   withAnimation {
    currentPage += 1
   }
  } else {
   // Tell AppStateManager that user completed onboarding
   Task {
    try await appStateManager.completeOnboarding()
   }
  }
 }
}

// MARK: - Individual Onboarding Page
struct OnboardingPage: View {
 let title: String
 let subtitle: String
 let imageName: String
 let imageColor: Color
 
 var body: some View {
  VStack(spacing: 24) {
   Spacer()
   
   // Icon/Image
   Image(systemName: imageName)
    .font(.system(size: 80))
    .foregroundStyle(imageColor)
    .padding(40)
    .background(
     Circle()
      .fill(imageColor.opacity(0.1))
    )
    .frame(maxWidth: .infinity)
    .frame(maxHeight: .infinity)
    .padding()
    .background(
     RoundedRectangle(cornerRadius: 25)
      .fill(Color.clear)
      .strokeBorder(Colors.swiftUIColor(.textSecondary), lineWidth: 1)
    )
   
   // Text Content
   VStack(spacing: 12) {
    Text(title)
     .font(.title)
     .fontWeight(.bold)
     .foregroundStyle(Colors.swiftUIColor(.textMain))
     .multilineTextAlignment(.center)
    
    Text(subtitle)
     .font(.subheadline)
     .foregroundStyle(Colors.swiftUIColor(.textSecondary))
     .multilineTextAlignment(.center)
     .lineLimit(3)
   }
   
   Spacer()
  }
  .padding(32)
  
 }
}

#Preview {
 OnboardingView()
}
