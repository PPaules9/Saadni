import SwiftUI
import Kingfisher

struct OnboardingView: View {
 @State private var currentPage = 0
 @Environment(AppStateManager.self) var appStateManager

 var body: some View {
  ZStack {
   Color(uiColor: .systemBackground)
    .ignoresSafeArea()
   
   VStack(spacing: 0) {
    // TabView with 3 pages
    TabView(selection: $currentPage) {
     // Page 1
     OnboardingPage(
      title: "Two Simple Rules",
      subtitle: "Respect everyone and provide genuine help. Our community thrives on trust, kindness, and mutual support."
     )
     .tag(0)
     
     // Page 2
     OnboardingPage(
      title: "Empowering Students",
      subtitle: "Get the academic support you need, exactly when you need it. Connect with peers and mentors to excel in your studies quickly and easily."
     )
     .tag(1)
     
     // Page 3
     OnboardingPage(
      title: "Help at a Fixed Low Price",
      subtitle: "Everyone deserves access to quality assistance. Get expert help for a simple, low, and fixed price with no hidden fees or complications."
     )
     .tag(2)
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    
    // Bottom Action Area
    VStack(spacing: 24) {
     // Navigation Button
     BrandButton(currentPage < 2 ? "Continue" : "Get Started", hasIcon: false, icon: "", secondary: false) {
      nextPage()
     }
     .padding(.horizontal, 24)
     
     // Footer Indicator or Sign In Link
     ZStack {
      if currentPage < 2 {
       HStack(spacing: 8) {
        ForEach(0..<3, id: \.self) { index in
         Capsule()
          .fill(currentPage == index ? Color.accentColor : Colors.swiftUIColor(.textSecondary).opacity(0.3))
          .frame(width: currentPage == index ? 24 : 8, height: 8)
          .animation(.easeInOut, value: currentPage)
        }
       }
      } else {
       Button {
        Task {
         try await appStateManager.completeOnboarding()
        }
       } label: {
        Text("Sign In")
         .font(.subheadline)
         .fontWeight(.semibold)
         .foregroundStyle(Colors.swiftUIColor(.textSecondary))
       }
      }
     }
     .frame(height: 20) // Stable height to prevent layout jumps
    }
    .padding(.top, 16)
    .padding(.bottom, 32)
   }
  }
 }
 
 private func nextPage() {
  if currentPage < 2 {
   withAnimation(.easeInOut(duration: 0.3)) {
    currentPage += 1
   }
  } else {
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

 var body: some View {
  VStack(spacing: 32) {
   // Image Container
   GeometryReader { geometry in
    let imageSize = min(geometry.size.width - 48, geometry.size.height - 32)
    ZStack {
     RoundedRectangle(cornerRadius: 32, style: .continuous)
      .fill(Color.accentColor.opacity(0.1))
     
     // Wrap the existing GIF inside this premium container shape
     if let url = Bundle.main.url(forResource: "onBoarding", withExtension: "gif") {
      KFAnimatedImage(source: .provider(LocalFileImageDataProvider(fileURL: url)))
       .scaledToFill()
       .frame(width: imageSize, height: imageSize)
       .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
     }
    }
    .frame(width: imageSize, height: imageSize)
    .shadow(color: Color.black.opacity(0.04), radius: 15, x: 0, y: 8)
    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
   }
   
   // Text Block
   VStack(spacing: 16) {
    Text(title)
     .font(.system(size: 28, weight: .bold))
     .foregroundStyle(Colors.swiftUIColor(.textMain))
     .multilineTextAlignment(.center)
     .lineLimit(2)
     .padding(.horizontal, 24)
    
    Text(subtitle)
     .font(.system(size: 16, weight: .regular))
     .lineSpacing(4)
     .foregroundStyle(Colors.swiftUIColor(.textSecondary))
     .multilineTextAlignment(.center)
     .padding(.horizontal, 32)
   }
   
   Spacer(minLength: 40)
  }
  .padding(.top, 24)
 }
}

#Preview {
 OnboardingView()
  .environment(AppStateManager())
}
