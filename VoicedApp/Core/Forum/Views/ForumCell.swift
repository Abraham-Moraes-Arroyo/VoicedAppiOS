//
//  ForumCell.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//



import SwiftUI
import Kingfisher
import UIKit

struct ForumCell: View {
    @ObservedObject var viewModel: ForumCellViewModel
    @State private var showReportReason = false
    @State private var showReportSheet = false
    @State private var reportReason = "" // To store user input
       @State private var showingReportSheet = false
    
    private var post: Post {
        return viewModel.post
    }
    
    private var didLike: Bool {
        return post.didLike ?? false
    }
    
    private var didDislike: Bool {
        return post.didDislike ?? false
    }
    
    private var didBookmark: Bool {
        return post.didBookmark ?? false
    }
    
    init(post: Post) {
        self.viewModel = ForumCellViewModel(post: post)
    }
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 3) - 1

        @State private var showReplySheet = false
    var body: some View {
        VStack {
            HStack {
                if let user = post.user {
                    CircularProfileImageView(user: user, size: .xSmall)
                    Text(user.username)
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Text(post.category.displayName)
                        .font(.footnote)
                        .frame(width: 150, height: 5)
                        .padding()
                        .foregroundColor(.white)
                        .background(post.category.color)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                    
                    Text(post.timestamp.timestampString())
                        .font(.caption)
                        .foregroundColor(Color(.systemGray3))
                    Button(action: {
                        
                    }, label: {
                        Image(systemName:  "ellipsis")
                            .foregroundStyle(Color(.darkGray))
                    })
                    
                }
                Spacer()
                // Post verification status
                if !post.isUserGenerated {
                    Label("Verified", systemImage: "checkmark.seal.fill")
                        .padding(5)
                        .background(Color.green.opacity(0.1)) // Semi-transparent background
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.green)
                        .padding(.trailing, 10)
                }
            }
            .padding(.leading)
            Divider()
            VStack {
                HStack(spacing: 26){
                    
                    VStack(spacing: 8) {
                        Text(post.title)
                            .fontWeight(.semibold)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                        // Check if the caption is a valid URL
                        if let url = URL(string: post.caption ?? ""), UIApplication.shared.canOpenURL(url) {
                            Link("Read more", destination: url)
                                .foregroundColor(.blue)
                                                                          } else {
                                                    Text(post.caption ?? "")
                                                        .font(.caption)
                                                }
                        
                    }
                    
                    // Check if the image URL string is not nil and not empty
                            if let imageUrlString = post.imageUrl, !imageUrlString.isEmpty, let imageUrl = URL(string: imageUrlString) {
                                KFImage(imageUrl)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Rectangle())
                            }
                    
                }
                .padding(.leading)
                .padding(.bottom, 4)
                actionButtons
            }
            .padding(.bottom, 8)
            
            Divider()
        }
    }
    @ViewBuilder
    var actionButtons: some View {
        HStack (spacing: 25) {
            Spacer()
            Button(action: { handleLikeTapped() }) {
                HStack {
                    Image(systemName: didLike ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(didLike ? .green : .black)
                    if post.likes > 0 {
                        Text("\(post.likes)")
                    }
                }
            }
            
            Button(action: { handleDislikeTapped() }) {
                HStack {
                    Image(systemName: didDislike ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .foregroundColor(didDislike ? .green : .black)
                    if post.dislikes > 0 {
                        Text("\(post.dislikes)")
                    }
                }
            }
            
            Button(action: { showReplySheet.toggle() }) {
                HStack {
                    Image(systemName: "bubble.right")
                    if post.comments > 0 {
                        Text("\(post.comments)")
                    }
                }
            }
            
            Button(action: { handleBookmarks() }) {
                HStack {
                    Image(systemName: didBookmark ? "bookmark.fill" : "bookmark")
                        .foregroundColor(didBookmark ? .green : .black)
                    if post.favorites > 0 {
                        Text("\(post.favorites)")
                    }
                }
            }
            
//            TextField("Reason for reporting", text: $reportReason)
//                       .textFieldStyle(RoundedBorderTextFieldStyle())
            
                   
                   Button(action: {  showingReportSheet = true }) {
                       HStack {
                           Image(systemName: "flag")
                           
                       }
                      
                   }
                   .actionSheet(isPresented: $showingReportSheet) {
                       ActionSheet(title: Text("Confirm Report"), message: Text("Submit your report?"), buttons: [
                        .destructive(Text("Report"), action: {
                            Task {
                                do {
                                    try await viewModel.reportPost(reason: reportReason)
                                    // Reset reason after reporting
                                    reportReason = ""
                                } catch {
                                    // Handle error
                                }
                            }
                        }),
                        .cancel()
                       ])
                   }
                       
            
            Spacer()
        }
        .sheet(isPresented: $showReplySheet) {
            CommentReplyView(post: post)
        }
        .padding(.top, 4)
        .foregroundColor(.black)
    }
    
    private func handleLikeTapped() {
        Task {
            if didLike {
                try await viewModel.unlike()
            } else {
                try await viewModel.like()
            }
        }
    }
    
    private func handleDislikeTapped() {
        Task {
            if didDislike {
                try await viewModel.undoDislike()
            } else {
                try await viewModel.dislike()
            }
        }
    }
    
    private func handleBookmarks() {
        Task {
            if didBookmark {
                try await viewModel.unbookmark()
            } else {
                try await viewModel.bookmark()
            }
        }
    }
}

#Preview {
    ForumCell(post: Post.MOCK_POSTS[0])
}
