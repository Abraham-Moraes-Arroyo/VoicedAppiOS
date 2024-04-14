//
//  ForumView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import SwiftUI

struct ForumView: View {
    @StateObject var viewModel = ForumViewModel()
    @State private var isProfileViewActive = false
    @State private var selectedCategory: PostCategory = .miscellaneous // Updated to use PostCategory enum
    @State private var showingTrendingPosts = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 35) {
                    // Dynamically create ForumCell views for each post in filteredPosts
                    ForEach(viewModel.filteredPosts, id: \.id) { post in
                        
                        NavigationLink(value: post) {
                            ForumCell(post: post)
                        }
                            .onTapGesture {
                                // Placeholder for future implementation
                                isProfileViewActive = true
                            }
                    }
                }
                .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)

                .edgesIgnoringSafeArea(.all)
            }
            
            .navigationDestination(for: Post.self, destination: { post in
                PostDetailsView(post: post)
            })
            .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)


         
            .navigationTitle("Forum")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingTrendingPosts.toggle()
                        if showingTrendingPosts {
                            viewModel.showTrendingPosts()
                        } else {
                            // Reapply the currently selected category filter when toggling off trending
                            viewModel.setCategory(selectedCategory)
                        }
                    }) {
                        Image(systemName: "flame")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(PostCategory.allCases, id: \.self) { category in
                            Button(category.displayName, action: {
                                selectedCategory = category
                                viewModel.setCategory(category)
                            })
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }

            .foregroundColor(.black)
        }
        .background(Color(red: 0.812, green: 0.863, blue: 0.906)) // #cfdce7
      
        .edgesIgnoringSafeArea(.all)
        .navigationDestination(for: User.self, destination: { user in
                                if user.isCurrentUser {
                                    CurrentUserProfileView(user: user)
                                } else {
                                    ProfileView(user: user)
                                }
                            })
            .onChange(of: selectedCategory) { newValue in
                if showingTrendingPosts {
                    showingTrendingPosts = false // Turn off trending when a category is selected
                }
                viewModel.setCategory(newValue)
            }
        .refreshable {
            Task { try await viewModel.fetchPosts() }
                            }
                            .overlay {
                                if viewModel.isLoading { ProgressView() }
                            }
                            .navigationBarBackButtonHidden(true)
    }
    
    
}

#Preview {
    ForumView()
}
