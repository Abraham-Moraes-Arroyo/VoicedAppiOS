//
//  HighlightsView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import SwiftUI

struct HighlightsView: View {
    // This array will hold posts that aren't user-generated
    var nonUserGeneratedPosts: [Post] {
        Post.MOCK_POSTS.filter { !$0.isUserGenerated }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 20) {
                    ForEach(nonUserGeneratedPosts, id: \.id) { post in
                        ForumCell(post: post)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HighlightsView()
}
