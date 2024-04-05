//
//  PostReply.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/2/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct PostReply: Codable, Identifiable {
    @DocumentID var replyId: String?
    
    // represents which post the reply is referring to
    let postId: String
    let replyText: String
    
    // the owner of the reply
    let postReplyOwnerUid: String
    
    // owner of post
    let postOwnerUid: String
    let timestamp: Timestamp
    
    var post: Post?
    var replyUser: User?
    
    
    var id: String {
        return replyId ?? NSUUID().uuidString
    }
    
    
}

extension PostReply {
    static let MOCK_REPLIES: [PostReply] = [
        .init(postId: Post.MOCK_POSTS[0].id,
              replyText: "sample reply",
              postReplyOwnerUid: User.MOCK_USERS[0].id,
              postOwnerUid: User.MOCK_USERS[1].id,
              timestamp: Timestamp())
    
    ]
    
}

