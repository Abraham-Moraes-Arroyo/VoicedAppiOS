//
//  PostService.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/24/24.
//


import Firebase

struct PostService {
    
    private static let postsCollection = Firestore.firestore().collection("posts")
    
    // Fetch all forum posts
    static func fetchFilteredForumPosts(excludeUserIds blockedUserIds: [String]) async throws -> [Post] {
            let snapshot = try await postsCollection.getDocuments()
            var posts: [Post] = []

            for document in snapshot.documents {
                do {
                    var post = try document.data(as: Post.self)
                    // Skip posts from blocked users
                    if let ownerUid = post.ownerUid, blockedUserIds.contains(ownerUid) {
                        continue
                    }
                    if let ownerUid = post.ownerUid {
                        // Attempt to fetch user and assign if successful
                        let postUser = try await UserService.fetchUser(withUid: ownerUid)
                        post.user = postUser
                    }
                    posts.append(post)
                } catch {
                    print("Error parsing post: \(error)")
                }
            }
            return posts
        }

    
    // Fetch posts by a specific user
    static func fetchUserPosts(uid: String) async throws -> [Post] {
        let snapshot = try await postsCollection.whereField("ownerUid", isEqualTo: uid).getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: Post.self) })
    }

    // Like a post, automatically removing a dislike if it exists
    static func likePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let dislikeDocRef = Firestore.firestore().collection("users").document(uid).collection("user-dislikes").document(post.id)
        let dislikeSnapshot = try await dislikeDocRef.getDocument()
        if dislikeSnapshot.exists {
            async let _ = dislikeDocRef.delete()
            async let _ = postsCollection.document(post.id).updateData(["dislikes": post.dislikes - 1])
        }

        async let _ = postsCollection.document(post.id).collection("post-likes").document(uid).setData([:])
        async let _ = postsCollection.document(post.id).updateData(["likes": post.likes + 1])
        async let _ = Firestore.firestore().collection("users").document(uid).collection("user-likes").document(post.id).setData([:])
    }
    
    // Unlike a post
    static func unlikePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = postsCollection.document(post.id).collection("post-likes").document(uid).delete()
        async let _ = postsCollection.document(post.id).updateData(["likes": post.likes - 1])
        async let _ = Firestore.firestore().collection("users").document(uid).collection("user-likes").document(post.id).delete()
    }
    
    // Check if a user has liked a post
    static func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).collection("user-likes").document(post.id).getDocument()
        return snapshot.exists
    }
    
    // Fetch IDs of posts liked by the user
    static func fetchLikedPostIDs() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).collection("user-likes").getDocuments()
        return snapshot.documents.map { $0.documentID }
    }

    // Dislike a post, automatically removing a like if it exists
    static func dislikePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likeDocRef = Firestore.firestore().collection("users").document(uid).collection("user-likes").document(post.id)
        let likeSnapshot = try await likeDocRef.getDocument()
        if likeSnapshot.exists {
            async let _ = likeDocRef.delete()
            async let _ = postsCollection.document(post.id).updateData(["likes": post.likes - 1])
        }

        async let _ = postsCollection.document(post.id).collection("post-dislikes").document(uid).setData([:])
        async let _ = postsCollection.document(post.id).updateData(["dislikes": post.dislikes + 1])
        async let _ = Firestore.firestore().collection("users").document(uid).collection("user-dislikes").document(post.id).setData([:])
    }
    
    // Undo dislike of a post
    static func undoDislikePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = postsCollection.document(post.id).collection("post-dislikes").document(uid).delete()
        async let _ = try await postsCollection.document(post.id).updateData(["dislikes": post.dislikes - 1])
        async let _ = Firestore.firestore().collection("users").document(uid).collection("user-dislikes").document(post.id).delete()
    }

    // Check if a user has disliked a post
    static func checkIfUserDislikedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).collection("user-dislikes").document(post.id).getDocument()
        return snapshot.exists
    }

    // Bookmark a post
    static func bookmarkPost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await postsCollection.document(post.id).collection("post-favorites").document(uid).setData([:])
        async let _ = try await postsCollection.document(post.id).updateData(["favorites": post.favorites + 1])
        async let _ = Firestore.firestore().collection("users").document(uid).collection("user-favorites").document(post.id).setData([:])
    }

    // Unbookmark a post
    static func unbookmarkPost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await postsCollection.document(post.id).collection("post-favorites").document(uid).delete()
        async let _ = try await postsCollection.document(post.id).updateData(["favorites": post.favorites - 1])
        async let _ = Firestore.firestore().collection("users").document(uid).collection("user-favorites").document(post.id).delete()
    }

    // Check if a user has bookmarked a post
    static func checkIfUserBookmarkedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).collection("user-favorites").document(post.id).getDocument()
        return snapshot.exists
    }

    // Fetch IDs of posts bookmarked by the user
    static func fetchBookmarkedPostIDs() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).collection("user-favorites").getDocuments()
        return snapshot.documents.map { $0.documentID }
    }
}

