//
//  PostDetailsViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/4/24.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

@MainActor
class PostDetailsViewModel: ObservableObject {
    @Published var replies = [PostReply]()
    private var blockedUsers = Set<String>() // Store IDs of blocked users for efficient lookup
    
    private let post: Post
    
    init(post: Post) {
        self.post = post
        Task {
            await fetchBlockedUsers() // Fetch blocked users first
            try await fetchPostReplies() // Then fetch replies, excluding those from blocked users
        }
    }
    
    private func fetchBlockedUsers() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        do {
            // Assume `UserService.fetchBlockedUserIds` returns an array of user IDs
            let fetchedBlockedUsers = try await UserService.fetchBlockedUsers(forUserId: currentUserId)
            self.blockedUsers = Set(fetchedBlockedUsers)
        } catch {
            print("Error fetching blocked users: \(error)")
        }
    }

    private func fetchPostReplies() async throws {
        var fetchedReplies = try await PostReplyService.fetchPostReplies(forPost: post)
        // Filter out replies from blocked users
        fetchedReplies = fetchedReplies.filter { !self.blockedUsers.contains($0.postReplyOwnerUid) }
        self.replies = fetchedReplies
        try await fetchUserDataForReplies()
    }
    
    private func fetchUserDataForReplies() async throws {
        for i in 0 ..< replies.count {
            let reply = replies[i]
            async let user = try await UserService.fetchUser(withUid: reply.postReplyOwnerUid)
            self.replies[i].replyUser = try await user
        }
    }
    
    func reportPostReply(replyId: String, reason: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let db = Firestore.firestore()
        guard let replyToReport = replies.first(where: { $0.id == replyId }) else {
            print("Reply not found")
            return
        }

        var ref: DocumentReference? = nil
        ref = db.collection("reports-comments").addDocument(data: [
            "postReplyId": replyToReport.id,
            "postId": post.id, // Assuming `Post` has an `id` attribute
            "postOwnerUid": post.ownerUid, // Assuming `Post` has an `ownerUid` attribute
            "replyOwnerUid": replyToReport.postReplyOwnerUid,
            "reporterId": userId,
            "reason": reason,
            "timestamp": Timestamp(date: Date())
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}
