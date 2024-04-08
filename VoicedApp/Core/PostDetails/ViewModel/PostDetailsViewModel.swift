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


extension PostDetailsViewModel {
    @MainActor
    func reportPostReply(replyId: String, reason: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        // Reference to the Firestore database
        let db = Firestore.firestore()

        guard let replyToReport = replies.first(where: { $0.id == replyId }) else {
            print("Reply not found")
            return
        }

        // Creating a new document in the `reports-comments` collection
        var ref: DocumentReference? = nil
        ref = db.collection("reports-comments").addDocument(data: [
            "postReplyId": replyToReport.id,
            "postId": replyToReport.postId,
            "postOwnerUid": replyToReport.postOwnerUid,
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
