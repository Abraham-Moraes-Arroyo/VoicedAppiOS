//
//  ForumViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/24/24.
//

import Foundation
import Firebase

// class responsible for fetching posts and displaying them
class ForumViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var filteredPosts = [Post]()
        private var currentCategory: PostCategory = .miscellaneous
    // current category represents the default category
    private var blockedUsers = [String]()
    
    @Published var isLoading = false
    
    init() {
        Task {
            await fetchBlockedUsers()
            
            try await fetchPosts()
            // Directly using the specific URL when calling the method
                    let htmlContent = await fetchHTMLContent(from: "https://blockclubchicago.org/category/back-of-the-yards/")
                    await updatePostsFromHTML(htmlContent: htmlContent)
            
        }
    }
    
    @MainActor
//    Asynchronously fetches posts from Firestore using the PostService.fetchForumPosts()
    func fetchPosts() async throws {
        self.isLoading = true
        
        let fetchedPosts = try await PostService.fetchFilteredForumPosts(excludeUserIds: blockedUsers)
        
        self.isLoading = false
        print("Fetched posts: \(fetchedPosts.count)")

        self.isLoading = false
        if !fetchedPosts.isEmpty {
            DispatchQueue.main.async {
                self.posts = fetchedPosts.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
                self.applyCategoryFilter(category: self.currentCategory)
                
            }
        } else {
            print("No posts were fetched.")
        }
    }

     func fetchBlockedUsers() async {
            guard let currentUserId = Auth.auth().currentUser?.uid else { return }
            do {
                blockedUsers = try await UserService.fetchBlockedUsers(forUserId: currentUserId)
            } catch {
                print("Error fetching blocked users: \(error)")
            }
        }
    
    // Method to set the current category and filter posts accordingly by calling applyCategoryFilter(category:)
    
        func setCategory(_ category: PostCategory) {
            currentCategory = category
            applyCategoryFilter(category: category)
            print("Current category: \(category), Filtered posts count: \(filteredPosts.count)")

        }
    
    func showTrendingPosts() {
            filteredPosts = posts.filter { $0.likes > 15 }.sorted { $0.likes > $1.likes }
        }
        
        // Filter posts by the selected category
        private func applyCategoryFilter(category: PostCategory) {
            if category == .miscellaneous {
                // default category
                filteredPosts = posts
                print(filteredPosts.count)
            } else {
                filteredPosts = posts.filter { $0.category == category }
            }
        }
    }

extension ForumViewModel {
    @MainActor func updatePostsFromHTML(htmlContent: String) async {
        let parser = HTMLParser()
        let newPosts = parser.parse(html: htmlContent)
        
        var uniquePosts = [Post]()
        
        for post in newPosts {
            if !(await postExists(post: post)) {
                uniquePosts.append(post)
                await savePostToFirestore(post: post)
            }
        }
        
        // Now implicitly on the main thread, thanks to @MainActor
        self.posts.append(contentsOf: uniquePosts)
        self.applyCategoryFilter(category: self.currentCategory)
    }
    
    
    
    //  Asynchronously saves a new post to Firestore. It converts the post into a dictionary format suitable for Firestore and attempts to save it, printing the outcome.
    private func savePostToFirestore(post: Post) async {
        let db = Firestore.firestore()
        let postData = post.toDictionary()
        let docRef = db.collection("posts").document(post.id)
        
        do {
            try await docRef.setData(postData)
            print("Post saved: \(post.title)")
        } catch {
            print("Error saving post to Firestore: \(error)")
        }
    }
    
}





extension ForumViewModel {
    //        Fetches HTML content from a specified URL asynchronously. It's used to get the HTML that will be parsed into post objects.
    func fetchHTMLContent(from url: String) async -> String {
        guard let url = URL(string: "https://blockclubchicago.org/category/back-of-the-yards/") else {
            print("Invalid URL")
            return ""
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let htmlContent = String(data: data, encoding: .utf8) {
                return htmlContent
            } else {
                print("Failed to decode HTML content")
                return ""
            }
        } catch {
            print("Error fetching HTML content: \(error)")
            return ""
        }
    }
}

extension ForumViewModel {
    //    Checks asynchronously if a post already exists in Firestore to avoid duplicating posts when updating from HTML content.
    private func postExists(post: Post) async -> Bool {
        let db = Firestore.firestore()
        let collectionRef = db.collection("posts")
        let querySnapshot = try? await collectionRef.whereField("title", isEqualTo: post.title).getDocuments()

        return !(querySnapshot?.documents.isEmpty ?? true)
    }
}



extension Post {
    // : Converts a Post object into a dictionary format for easier manipulation and storage in Firestore. This is particularly useful for saving posts parsed from HTML content.
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": self.id,
            "title": self.title,
            "likes": self.likes,
            "dislikes": self.dislikes,
            "favorites": self.favorites,
            "comments": self.comments,
            "caption": self.caption ?? "",
            "imageUrl": self.imageUrl ?? "",
            "timestamp": self.timestamp,
            "category": self.category.rawValue,
        ]
        
    
        if let user = self.user {
            dict["ownerUid"] = user.id
        }
        
        return dict
    }
}


