//
//  PollsView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import SwiftUI

struct PollsView: View {
    let polls: [Poll] // Assuming this array is provided, e.g., from a ViewModel or directly as mock data

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(polls) { poll in
                    VStack(alignment: .leading) {
                        Text("Created at: \(poll.formattedCreatedAt)")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        PollView(poll: poll, onVote: { optionId in
                            print("Voted on option: \(optionId) in poll: \(poll.question)")
                            // Handle the vote here, e.g., update the model or inform a ViewModel
                        })
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }
            .padding()
        }
    }
}

#Preview {
    PollsView(polls: Poll.mockCommunityPolls)
}
