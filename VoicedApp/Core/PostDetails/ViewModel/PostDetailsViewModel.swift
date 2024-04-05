//
//  PostDetailsViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/4/24.
//

import Foundation

@MainActor
class PostDetailsViewModel: ObservableObject {
    @Published var replies = [PostReply]()
    
    private let post: Post
    
    init(post: Post) {
        self.post = post
        Task { try await fetchPostReplies() }
    }
    
    private func fetchPostReplies() async throws {
        self.replies = try await PostReplyService.fetchPostReplies(forPost: post)
        try await fetchUserDataForReplies()

    }
    
    private func fetchUserDataForReplies() async throws {
        for i in 0 ..< replies.count {
            let reply = replies[i]
            
            async let user = try await UserService.fetchUser(withUid: reply.postReplyOwnerUid)
            
            self.replies[i].replyUser = try await user
        }
    }
}
