//
//  PostReplyViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/2/24.
//

import Foundation
import Firebase

class PostReplyViewModel: ObservableObject {
    func uploadPostReply(replyText: String, post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reply = PostReply(postId: post.id,
                              replyText: replyText,
                              postReplyOwnerUid: uid,
                              postOwnerUid: post.ownerUid!,
                              timestamp: Timestamp()
        )
        
        try await PostReplyService.uploadPostReply(reply, toPost: post)
    }
}
