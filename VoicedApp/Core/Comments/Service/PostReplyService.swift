//
//  PostReplyService.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/2/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct PostReplyService {
    
    private static let postsReplyCollection = Firestore.firestore().collection("replies")
    private static let postsCollection = Firestore.firestore().collection("posts")
     
    static func uploadPostReply(_ reply: PostReply, toPost post: Post) async throws {
        guard let replyData = try? Firestore.Encoder().encode(reply) else { return }
        
        async let _ = try await postsReplyCollection.document().setData(replyData)
        async let _ = try await postsCollection.document(post.id).updateData([
            "comments" : post.comments + 1
        ])
    }
    
    static func fetchPostReplies(forPost post: Post) async throws -> [PostReply] {
        let snapshot = try await postsReplyCollection.whereField("postId", isEqualTo: post.id).getDocuments()
        
        // returns all post replies
        return snapshot.documents.compactMap({ try? $0.data(as: PostReply.self) })
    }
    
    static func fetchPostReplies(forUser user: User) async throws -> [PostReply] {
        let snapshot = try await postsReplyCollection.whereField("postOwnerUid", isEqualTo: user.id).getDocuments()
        
        // returns all post replies associated with a particular user
        return snapshot.documents.compactMap({ try? $0.data(as: PostReply.self) })
    }
    
}
