//
//  CommentReplyView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/1/24.
//

import SwiftUI

struct CommentReplyView: View {
    @Environment(\.dismiss) var dismiss
    let post: Post
    @State private var replyText = ""
    
    @State var postReplyHeight: CGFloat = 24
    @State private var viewModel = PostReplyViewModel()
    
    @State private var suggestions: [User] = []
    
        @State private var showSuggestions = false
    
    @StateObject private var searchViewModel = SearchViewModel()
    
    private var currentUser: User? {
        return AuthService.shared.currentUser
    }
    
    func setCommentViewHeight() {
        let imageDimension: CGFloat = ProfileImageSize.small.dimension
        let padding: CGFloat = 16
        let width = UIScreen.main.bounds.width - imageDimension - padding
        let font = UIFont.systemFont(ofSize: 12)
        let captionSize = post.caption!.heightWithConstrainedWidth(width, font: font)
        
        print("debug: caption size is \(captionSize)")
        
        postReplyHeight = captionSize + imageDimension - 16
        
        
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        VStack {
                            if post.isUserGenerated {
                                CircularProfileImageView(user: post.user!, size: .small)
                            }
                            
                            Rectangle()
                                .frame(width: 2, height: postReplyHeight)
                                .foregroundColor(Color(.systemGray4))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(post.user?.username ?? "")
                                .fontWeight(.semibold)
                            
                            Text(post.caption ?? "")
                                .multilineTextAlignment(.leading)
                        }
                        .font(.footnote)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        CircularProfileImageView(user: currentUser ?? User.MOCK_USERS[0], size: .small)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentUser?.username ?? "")
                                .fontWeight(.semibold)
                            
                            TextField("Add your reply", text: $replyText, axis: .vertical)
                                .multilineTextAlignment(.leading)
                                .onChange(of: replyText) { newValue in
                                                        handleMentions(text: newValue)
                                                    }
                        }
                        .font(.footnote)
                        
                        if showSuggestions {
                                            List(suggestions, id: \.id) { user in
                                                Text(user.username)
                                                    .foregroundStyle(.blue)
                                                    .onTapGesture {
                                                        addMentionToReply(for: user)
                                                    }
                                            }
                                            .frame(maxHeight: 200)
                                        }
                    }
                }
                .padding()
                
                
                Spacer()
            }
            .onAppear { setCommentViewHeight() }
            .navigationTitle("Reply")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        Task {
                            try await viewModel.uploadPostReply(replyText: replyText, post: post)
                            dismiss()
                        }
                    }
                    .opacity(replyText.isEmpty ? 0.5 : 1.0)
                    .disabled(replyText.isEmpty)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
            }
        }
    }
    
    
    private func handleMentions(text: String) {
          guard let lastWord = text.split(separator: " ").last, lastWord.starts(with: "@") else {
              showSuggestions = false
              return
          }
          let query = lastWord.dropFirst().lowercased()
          searchUser(with: String(query))
      }
      private func searchUser(with query: String) {
          suggestions = searchViewModel.users.filter { $0.username.lowercased().contains(query) }
          showSuggestions = !suggestions.isEmpty
      }
      private func addMentionToReply(for user: User) {
          let newText = replyText.dropLast() + " @\(user.username) "
          replyText = String(newText)
          showSuggestions = false
      }
}
#Preview {
    CommentReplyView(post: Post.MOCK_POSTS[0])
}

