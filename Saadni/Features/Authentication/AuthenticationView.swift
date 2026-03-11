import SwiftUI

struct AuthenticationView: View {
 @Environment(AuthenticationManager.self) var authManager
 @State private var email = ""
 @State private var password = ""
 @State private var displayName = ""
 @State private var isSignUp = false
 @State private var isLoading = false
 
 var body: some View {
  ZStack {
   Colors.swiftUIColor(.appBackground)
    .ignoresSafeArea()
   
   ScrollView {
    VStack(spacing: 24) {
     // Logo/Branding
     VStack(spacing: 8) {
      Image(systemName: "hands.and.sparkles.fill")
       .font(.system(size: 60))
       .foregroundStyle(.accent)
      
      Text("Saadni")
       .font(.largeTitle)
       .fontWeight(.bold)
       .foregroundStyle(Colors.swiftUIColor(.textMain))
      
      Text(isSignUp ? "Create your account" : "Welcome back")
       .font(.subheadline)
       .foregroundStyle(Colors.swiftUIColor(.textSecondary))
     }
     .padding(.top, 60)
     .padding(.bottom, 20)
     
     VStack(spacing: 16) {
      if isSignUp {
       BrandTextField(hasTitle: false, title: "", placeholder: "Display Name", text: $displayName)
      }
      
      BrandTextField(hasTitle: false, title: "", placeholder: "Email", text: $email)
       .textInputAutocapitalization(.never)
       .keyboardType(.emailAddress)
      
      BrandPasswordField(hasTitle: false, title: "", placeholder: "Password", text: $password)
      
     }
     
     // Error Message
     if let error = authManager.errorMessage {
      Text(error)
       .font(.caption)
       .foregroundStyle(.red)
       .padding(.horizontal)
     }
     
     // Submit Button
     BrandButton(
      isSignUp ? "Create Account" : "Sign In",
      size: .large,
      isDisabled: !isFormValid || isLoading,
      hasIcon: false,
      icon: "",
      secondary: false
     ) {
      Task {
       await handleAuthentication()
      }
     }
     .padding(.top, 8)
     
     // Toggle Sign Up/Sign In
     Button {
      isSignUp.toggle()
      authManager.errorMessage = nil
     } label: {
      HStack(spacing: 4) {
       Text(isSignUp ? "Already have an account? " : "Don't have an account? ")
        .foregroundStyle(.gray)
       Text(isSignUp ? "Sign In" : "Sign Up")
        .foregroundStyle(.accent)
        .fontWeight(.semibold)
      }
      .font(.subheadline)
     }
     .padding(.top, 8)
     
     // Anonymous Sign In (for testing)
     Button {
      Task {
       isLoading = true
       try? await authManager.signInAnonymously()
       isLoading = false
      }
     } label: {
      Text("Continue as Guest")
       .font(.subheadline)
       .foregroundStyle(Colors.swiftUIColor(.textSecondary))
     }
     .padding(.top, 16)
     
     Spacer()
    }
    .padding(.horizontal, 24)
   }
  }
 }
 
 private var isFormValid: Bool {
  if isSignUp {
   return !email.isEmpty && !password.isEmpty &&
   !displayName.isEmpty && password.count >= 6
  } else {
   return !email.isEmpty && !password.isEmpty
  }
 }
 
 private func handleAuthentication() async {
  isLoading = true
  
  do {
   if isSignUp {
    try await authManager.signUp(
     email: email,
     password: password,
     displayName: displayName
    )
   } else {
    try await authManager.signIn(
     email: email,
     password: password
    )
   }
  } catch {
   print("Authentication failed: \(error)")
  }
  
  isLoading = false
 }
}


#Preview {
 AuthenticationView()
  .environment(UserCache())
  .environment(AuthenticationManager(userCache: UserCache()))
}
