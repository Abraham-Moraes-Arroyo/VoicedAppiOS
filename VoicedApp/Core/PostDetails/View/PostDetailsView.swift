//
//  PostDetailsView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/4/24.
//

import SwiftUI

struct PostDetailsView: View {
    let post: Post
    
    @StateObject var viewModel: PostDetailsViewModel
    
    init(post: Post) {
        self.post = post
        self._viewModel = StateObject(wrappedValue: PostDetailsViewModel(post: post))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    
                    ForumCell(post: post)
                    
                
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            LazyVStack {
                ForEach(viewModel.replies) {
                    reply in
                    PostReplyCell(reply: reply)
                }
            }
        }
        .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)

        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PostDetailsView(post: Post.MOCK_POSTS[0])
}
