//
//  PollView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import SwiftUI

struct PollView: View {
    @State private var selectedOptionId: String? = nil
    let poll: Poll
    var onVote: ((String) -> Void)?

    private var totalVotes: Int {
        poll.options.reduce(0) { $0 + $1.voteCount }
    }

    private var pollHasExpired: Bool {
        if let expiresAt = poll.expiresAt?.dateValue(), Date() > expiresAt {
            return true
        }
        return false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(poll.question)
                .font(.headline)
                .padding(.bottom, 5)

            if !pollHasExpired {
                ForEach(poll.options) { option in
                    Button(action: {
                        guard !pollHasExpired else { return }
                        self.selectedOptionId = option.id
                        onVote?(option.id)
                    }) {
                        OptionRow(option: option, isSelected: selectedOptionId == option.id)
                    }
                    .disabled(pollHasExpired)
                }
                
                Text("Expires: \(poll.expiresAt?.dateValue().formatted() ?? "N/A")")
                    .font(.footnote)
                    .padding(.top, 5)
                
                Text("Total votes: \(totalVotes)")
                    .font(.footnote)
                    .padding(.top, 1)
            } else {
                ForEach(poll.options) { option in
                    OptionRow(option: option, showVotes: true)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
    }
}

struct OptionRow: View {
    let option: Poll.PollOption
    var isSelected: Bool = false
    var showVotes: Bool = false

    var body: some View {
        HStack {
            Text(option.text)
                .foregroundColor(isSelected ? .white : .primary)
            Spacer()
            if isSelected || showVotes {
                Text("\(option.voteCount) votes")
                    .font(.footnote)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    PollView(poll: Poll.mockCommunityPolls[0])
}
