import Foundation
import FirebaseAuth
import Observation

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated(User)
}

@Observable
class AuthenticationManager {
    // MARK: - State
    var authState: AuthenticationState = .unauthenticated
    var errorMessage: String?

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    // MARK: - Computed Properties
    var isAuthenticated: Bool {
        if case .authenticated = authState {
            return true
        }
        return false
    }

    var currentUser: User? {
        if case .authenticated(let user) = authState {
            return user
        }
        return nil
    }

    var currentUserId: String? {
        return currentUser?.id
    }

    // MARK: - Initialization
    init() {
        // Delay auth setup to allow Firebase to initialize
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.registerAuthStateHandler()
        }
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Auth State Listener
    private func registerAuthStateHandler() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self = self else { return }

            if let firebaseUser = firebaseUser {
                // User is signed in
                let user = User(from: firebaseUser)
                self.authState = .authenticated(user)

                // Update user in Firestore (will implement in Phase 2)
                Task {
                    await self.updateUserInFirestore(user)
                }
            } else {
                // User is signed out
                self.authState = .unauthenticated
            }
        }
    }

    // MARK: - Sign In Methods

    /// Sign in with email and password
    func signIn(email: String, password: String) async throws {
        authState = .authenticating
        errorMessage = nil

        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = User(from: authResult.user)
            authState = .authenticated(user)
        } catch {
            authState = .unauthenticated
            errorMessage = error.localizedDescription
            throw error
        }
    }

    /// Create account with email and password
    func signUp(email: String, password: String, displayName: String) async throws {
        authState = .authenticating
        errorMessage = nil

        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)

            // Update profile with display name
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()

            // Create user object
            var user = User(from: authResult.user)
            user.displayName = displayName

            authState = .authenticated(user)

            // Save to Firestore
            await updateUserInFirestore(user)
        } catch {
            authState = .unauthenticated
            errorMessage = error.localizedDescription
            throw error
        }
    }

    /// Sign in anonymously (useful for testing)
    func signInAnonymously() async throws {
        authState = .authenticating
        errorMessage = nil

        do {
            let authResult = try await Auth.auth().signInAnonymously()
            let user = User(from: authResult.user)
            authState = .authenticated(user)

            await updateUserInFirestore(user)
        } catch {
            authState = .unauthenticated
            errorMessage = error.localizedDescription
            throw error
        }
    }

    /// Sign out
    func signOut() throws {
        try Auth.auth().signOut()
        authState = .unauthenticated
    }

    // MARK: - Firestore Integration (stub for Phase 2)
    private func updateUserInFirestore(_ user: User) async {
        // Will implement in Phase 2
        print("📝 User \(user.id) would be saved to Firestore")
    }
}
