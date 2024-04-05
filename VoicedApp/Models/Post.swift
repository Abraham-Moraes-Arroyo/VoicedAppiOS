//
//  Post.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Post: Identifiable, Hashable, Codable {
    
    
    let id: String
    let ownerUid: String?
    let title: String
    let caption: String?
    var likes: Int
    var dislikes: Int
    var favorites: Int
    var comments: Int
    let imageUrl: String?
    let timestamp: Timestamp
    var user: User?
    var category: PostCategory
    
    // properties below are unique to the current user:
    
    var didLike: Bool? = false
    var didDislike: Bool? = false
    var didBookmark: Bool? = false
    
    private enum CodingKeys: String, CodingKey {
        case id, ownerUid, title, caption, likes, dislikes, favorites, comments, imageUrl, timestamp, user, category
    }
    
    var isUserGenerated: Bool {
        return ownerUid != nil && !ownerUid!.isEmpty
    }
}
extension Post {
    static let MOCK_POSTS: [Post] = [
        .init(id: UUID().uuidString,
              ownerUid: User.MOCK_USERS[0].id,
              title: "Community Cleanup Event",
              caption: "Join us this weekend for a community park cleanup.",
              likes: 120,
              dislikes: 10,
              favorites: 3,
              comments: 5,
              imageUrl: "post-0",
              timestamp: Timestamp(),
              user: User.MOCK_USERS[0],
              category: PostCategory.events),
        
        .init(id: UUID().uuidString,
              ownerUid: User.MOCK_USERS[1].id,
              title: "Shocking Scene at the Neighborhood Festival!",
              caption: "What started as a fun-filled day ended in whispers and gasps as two well-known community members were overheard in a heated exchange behind the food stalls. Details are sparse, but rumors are swirling about a longstanding rivalry coming to light. Has anyone else heard more?",
              likes: 85,
              dislikes: 4,
              favorites: 11,
              comments: 4,
              imageUrl: "post-1",
              timestamp: Timestamp(),
              user: User.MOCK_USERS[1],
              category: PostCategory.happyHighlights),
        
        .init(id: UUID().uuidString,
              ownerUid: User.MOCK_USERS[2].id,
              title: "Education Reform Meeting",
              caption: "A meeting on the new education reforms will be held tomorrow.",
              likes: 95,
              dislikes: 4,
              favorites: 2,
              comments: 11,
              imageUrl: "post-2",
              timestamp: Timestamp(),
              user: User.MOCK_USERS[2],
              category: PostCategory.businesses),
        
        .init(id: UUID().uuidString,
              ownerUid: User.MOCK_USERS[3].id,
              title: "Crime Watch Alert!",
              caption: "Be on the lookout for suspicious activities in our neighborhood.",
              likes: 150,
              dislikes: 6,
              favorites: 1,
              comments: 3,
              imageUrl: "post-3",
              timestamp: Timestamp(),
              user: User.MOCK_USERS[3],
              category: PostCategory.reports),
        
        .init(id: UUID().uuidString,
              ownerUid: nil,
              title: "February 2024",
              caption: "hi",
              likes: 150,
              dislikes: 6,
              favorites: 21,
              comments: 1,
              imageUrl: "feb-24-dashboard",
              timestamp: Timestamp(),
              user: nil,
              category: PostCategory.reports)
        
        
    ]
}

