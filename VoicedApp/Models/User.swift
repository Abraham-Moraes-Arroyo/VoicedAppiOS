//
//  User.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, Hashable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var bio: String?
    let email: String
    
    // Storing enums as strings for Firestore compatibility
    var selectedCommunityIssues: [String]?
    var communityIssueOther: String?
    var selectedDiscoveryMethod: [String]?
    var discoveryMethodOther: String?
    
    // property can be used to determine whether to display edit profile or not
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return currentUid == id
    }
    
}
extension User {
    // i didnt add the other optional fields for the other users but it doesnt need to be added
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "alex", profileImageUrl: nil, bio: "Hi", email: "alex@example.com", selectedCommunityIssues: ["Environment", "Education"],
              communityIssueOther: "Local art initiatives",
              selectedDiscoveryMethod: ["Social Media"],
              discoveryMethodOther: nil),
        
        .init(id: NSUUID().uuidString, username: "jason", profileImageUrl: nil, bio: "Hi I'm Jason", email: "jason@example.com"),
        
        .init(id: NSUUID().uuidString, username: "marcial", profileImageUrl: nil, bio: "Hi Im Marcial", email: "marcial@example.com"),
        
            .init(id: NSUUID().uuidString, username: "joanna", profileImageUrl: nil, bio: "Test bio", email: "joanna@example.com")
    
    ]
}

