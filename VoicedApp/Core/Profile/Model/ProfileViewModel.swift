//
//  ProfileViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/24/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    private let user: User
    
    // these will be used for filtering in the user contest list view
    @Published var posts = [Post]()
    @Published var likedPosts = [Post]()
    @Published var bookmarkedPosts = [Post]()
    
    init(user: User) {
        self.user = user
        
        Task { try await fetchUserPosts() }
    }
    
    @MainActor
    func fetchUserPosts() async throws{
        self.posts = try await PostService.fetchUserPosts(uid: user.id)
        
        for i in 0 ..< posts.count {
            posts[i].user = self.user
        }
    }
    
    @MainActor
        func fetchLikedPosts() async throws {
            do {
                let likedPostIDs = try await PostService.fetchLikedPostIDs()
                let allPosts = try await PostService.fetchForumPosts()
                self.likedPosts = allPosts.filter { likedPostIDs.contains($0.id) }
            } catch {
                print("Failed to fetch liked posts: \(error)")
                self.likedPosts = []
            }
        }
    
    @MainActor
        func fetchBookmarkedPosts() async throws {
            do {
                let bookmarkedPostIDs = try await PostService.fetchBookmarkedPostIDs()
                let allPosts = try await PostService.fetchForumPosts()
                self.bookmarkedPosts = allPosts.filter { bookmarkedPostIDs.contains($0.id) }
            } catch {
                print("Failed to fetch bookmarked posts: \(error)")
                self.bookmarkedPosts = []
            }
        }
}
