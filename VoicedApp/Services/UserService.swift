//
//  UserService.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/20/24.
//

import Foundation
import Firebase

struct UserService {
    
    static func fetchUser(withUid uid: String) async throws -> User {
        
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchAllUsers() async throws -> [User] {
        
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
    }
    
    static func blockUser(currentUserId: String, userToBlockId: String) async throws {
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(currentUserId)
            
            try await userRef.updateData([
                "blockedUsers": FieldValue.arrayUnion([userToBlockId])
            ])
        }
    
    static func unblockUser(currentUserId: String, blockUserId: String) async throws {
            let userRef = Firestore.firestore().collection("users").document(currentUserId)
            try await userRef.updateData([
                "blockedUsers": FieldValue.arrayRemove([blockUserId])
            ])
        }
    
    static func fetchBlockedUsers(forUserId userId: String) async throws -> [String] {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        let user = try snapshot.data(as: User.self)
        return user.blockedUsers ?? [] // Defaults to an empty array if `blockedUsers` is nil
    }
}
