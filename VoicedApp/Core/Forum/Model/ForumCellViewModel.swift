//
//  ForumCellViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/25/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class ForumCellViewModel: ObservableObject {
    @Published var post: Post
    
    init(post: Post) {
        self.post = post
        Task {
            try await checkIfUserLikedPost()
            try await checkIfUserBookmarkedPost()
            try await checkIfUserDislikedPost()
        }
    }
    
    func like() async throws {
        // If the post is already liked, do nothing
        guard post.didLike == false else { return }
        
        // If the post was previously disliked, undo the dislike
        if post.didDislike == true {
            post.dislikes -= 1
            post.didDislike = false
        }
        
        // Like the post
        post.didLike = true
        post.likes += 1
        
        do {
            try await PostService.likePost(post)
        } catch {
            // Revert the changes if the network call fails
            post.didLike = false
            post.likes -= 1
            throw error
        }
    }
    
    func dislike() async throws {
        // If the post is already disliked, do nothing
        guard post.didDislike == false else { return }
        
        // If the post was previously liked, undo the like
        if post.didLike == true {
            post.likes -= 1
            post.didLike = false
        }
        
        // Dislike the post
        post.didDislike = true
        post.dislikes += 1
        
        do {
            try await PostService.dislikePost(post)
        } catch {
            // Revert the changes if the network call fails
            post.didDislike = false
            post.dislikes -= 1
            throw error
        }
    }
    
    func unlike() async throws {
        guard post.didLike == true else { return }
        
        post.didLike = false
        post.likes -= 1
        
        do {
            try await PostService.unlikePost(post)
        } catch {
            post.didLike = true
            post.likes += 1
            throw error
        }
    }
    
    func undoDislike() async throws {
        guard post.didDislike == true else { return }
        
        post.didDislike = false
        post.dislikes -= 1
        
        do {
            try await PostService.undoDislikePost(post)
        } catch {
            post.didDislike = true
            post.dislikes += 1
            throw error
        }
    }
    
    
    func bookmark() async throws {
        do {
            // post copy contains the original amount of likes
            let postCopy = post
            post.didBookmark = true
            post.favorites += 1
            
            try await PostService.bookmarkPost(postCopy)
            
        } catch {
            post.didBookmark = false
            post.favorites -= 1
        }
    }
      
    
    func unbookmark() async throws {
        
        do {
            // post copy contains the original amount of likes
            let postCopy = post
            post.didBookmark = false
            post.favorites -= 1
            
            try await PostService.unbookmarkPost(postCopy)
            
        } catch {
            post.didBookmark = true
            post.favorites += 1
        }
    }
        
        
    
    func checkIfUserLikedPost() async throws {
        self.post.didLike = try await PostService.checkIfUserLikedPost(post)
    }
    
    func checkIfUserBookmarkedPost() async throws {
        self.post.didBookmark = try await PostService.checkIfUserBookmarkedPost(post)
    }
    
    func checkIfUserDislikedPost() async throws {
        self.post.didDislike = try await PostService.checkIfUserDislikedPost(post)
    }

}

extension ForumCellViewModel {
    @MainActor
    func reportPost(reason: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        // Reference to the Firestore database
        let db = Firestore.firestore()
        
        // Creating a new document in the `reports` collection
        var ref: DocumentReference? = nil
        ref = db.collection("reports").addDocument(data: [
            "postId": self.post.id,
            "postOwnerUid": self.post.ownerUid ?? "",
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
