import Foundation
import FirebaseAuth
import FirebaseCore
import Core

/// Firebase Authentication Service
public final class FirebaseAuthService {
    
    // MARK: - Singleton
    
    public static let shared = FirebaseAuthService()
    
    // MARK: - Properties
    
    private lazy var auth: Auth = {
        // Ensure FirebaseApp is configured
        guard FirebaseApp.app() != nil else {
            fatalError("FirebaseApp must be configured before using FirebaseAuthService. Call FirebaseApp.configure() first.")
        }
        return Auth.auth()
    }()
    
    /// Current user
    public var currentUser: User? {
        return auth.currentUser
    }
    
    /// Check if user is signed in
    public var isSignedIn: Bool {
        return currentUser != nil
    }
    
    // MARK: - Initialization
    
    private init() {
        // Don't initialize Auth here - wait until first access
        Logger.info("Firebase Auth Service initialized (lazy)")
    }
    
    // MARK: - Email/Password Authentication
    
    /// Sign up with email and password
    public func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                Logger.error("Sign up error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                let error = NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user returned"])
                completion(.failure(error))
                return
            }
            
            Logger.info("User signed up: \(user.uid)")
            completion(.success(user))
        }
    }
    
    /// Sign in with email and password
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                Logger.error("Sign in error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                let error = NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user returned"])
                completion(.failure(error))
                return
            }
            
            Logger.info("User signed in: \(user.uid)")
            completion(.success(user))
        }
    }
    
    /// Sign out
    public func signOut() throws {
        try auth.signOut()
        Logger.info("User signed out")
    }
    
    /// Send password reset email
    public func sendPasswordReset(
        email: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                Logger.error("Password reset error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            Logger.info("Password reset email sent")
            completion(.success(()))
        }
    }
    
    /// Update password
    public func updatePassword(
        to newPassword: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let user = currentUser else {
            let error = NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user signed in"])
            completion(.failure(error))
            return
        }
        
        user.updatePassword(to: newPassword) { error in
            if let error = error {
                Logger.error("Update password error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            Logger.info("Password updated successfully")
            completion(.success(()))
        }
    }
    
    /// Update email
    public func updateEmail(
        to newEmail: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let user = currentUser else {
            let error = NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user signed in"])
            completion(.failure(error))
            return
        }
        
        user.updateEmail(to: newEmail) { error in
            if let error = error {
                Logger.error("Update email error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            Logger.info("Email updated successfully")
            completion(.success(()))
        }
    }
    
    /// Delete user account
    public func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = currentUser else {
            let error = NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user signed in"])
            completion(.failure(error))
            return
        }
        
        user.delete { error in
            if let error = error {
                Logger.error("Delete account error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            Logger.info("Account deleted successfully")
            completion(.success(()))
        }
    }
    
    // MARK: - User Profile
    
    /// Update user profile
    public func updateProfile(
        displayName: String? = nil,
        photoURL: URL? = nil,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let user = currentUser else {
            let error = NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user signed in"])
            completion(.failure(error))
            return
        }
        
        let changeRequest = user.createProfileChangeRequest()
        
        if let displayName = displayName {
            changeRequest.displayName = displayName
        }
        
        if let photoURL = photoURL {
            changeRequest.photoURL = photoURL
        }
        
        changeRequest.commitChanges { error in
            if let error = error {
                Logger.error("Update profile error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            Logger.info("Profile updated successfully")
            completion(.success(()))
        }
    }
    
    // MARK: - Auth State Listener
    
    /// Add auth state listener
    public func addAuthStateListener(_ listener: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle {
        return auth.addStateDidChangeListener { _, user in
            listener(user)
        }
    }
    
    /// Remove auth state listener
    public func removeAuthStateListener(_ handle: AuthStateDidChangeListenerHandle) {
        auth.removeStateDidChangeListener(handle)
    }
}
