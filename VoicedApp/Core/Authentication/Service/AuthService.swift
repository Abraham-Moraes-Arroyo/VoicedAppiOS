//
//  AuthService.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/19/24.
//

// has all the functions related to authenticating a user when a user registers

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase

enum AuthServiceError: Error {
    case userNotLoggedIn
    case reauthenticationFailed
}

class AuthService {
    
    // user session routes the user based on if they are logged in / signed out
    @Published var userSession: FirebaseAuth.User?
    
    @Published var currentUser: User?
    
    static let shared = AuthService()
    
    
    init() {
        Task { try await loadUserData() }
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
        } catch {
            print("DEBUG: failed to login with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
        func createUser(email: String, password: String, username: String, additionalData: [String: Any]) async throws {
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                self.userSession = result.user
                // Now passing additionalData along with basic user info
                await uploadUserData(uid: result.user.uid, username: username, email: email, additionalData: additionalData)
            } catch {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
            }
        }
        
    
    @MainActor
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = userSession?.uid else { return }
        self.currentUser = try await UserService.fetchUser(withUid: currentUid)
        
        
        // here the user object is being decoded
    }
    
    @MainActor
        func deleteUser() async throws {
            guard let currentUser = Auth.auth().currentUser else { return }

            do {
                // Refresh the user's token asynchronously
                try await currentUser.getIDTokenResult(forcingRefresh: true)
                
                // Perform actions before deletion (if needed)
                
                // Delete user data from Firestore
                try await
                Firestore.firestore().collection("users").document(currentUser.uid).delete()
                
                // Delete the user from Firebase Authentication
                try await currentUser.delete()
                
                // Set userSession to nil after deletion
                self.userSession = nil
            } catch {
                print("DEBUG: Failed to delete user with error \(error.localizedDescription)")
                throw error
            }
        }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
        
    }
    
    func sendPasswordResetEmail(toEmail email: String) async throws {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
            } catch {
                print("DEBUG: Failed to send email with error \(error.localizedDescription)")
                throw error
            }
        }
        
    
    private func uploadUserData(uid: String, username: String, email: String, additionalData: [String: Any]) async {
            var userDict: [String: Any] = [
                "id": uid,
                "username": username,
                "email": email
            ]
            // Add the additional registration data to the dictionary
            additionalData.forEach { key, value in
                userDict[key] = value
            }
    
            try? await Firestore.firestore().collection("users").document(uid).setData(userDict)
        }
    




    func reauthenticate(password: String) async throws {
        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email else {
            throw AuthServiceError.userNotLoggedIn
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        do {
            try await currentUser.reauthenticate(with: credential)
        } catch {
            throw AuthServiceError.reauthenticationFailed
        }
    }
    
}
