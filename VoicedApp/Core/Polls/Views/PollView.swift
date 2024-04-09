//
//  PollView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import SwiftUI

struct PollView: View {
    @ObservedObject var viewModel: PollViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.poll.question)
                .font(.headline)
                .padding(.bottom, 5)

            if !viewModel.pollHasExpired {
                ForEach(viewModel.poll.options) { option in
                    Button(action: {
                        // Call the vote function in the ViewModel
                        viewModel.vote(for: option.id)
                    }) {
                        OptionRow(option: option, isSelected: viewModel.selectedOptionId == option.id)
                    }
                    .disabled(viewModel.pollHasExpired)
                }
                
                Text("Expires: \(viewModel.expiresAtFormatted)")
                    .font(.footnote)
                    .padding(.top, 5)
                
                Text("Total votes: \(viewModel.totalVotes)")
                    .font(.footnote)
                    .padding(.top, 1)
            } else {
                ForEach(viewModel.poll.options) { option in
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

// Dummy ViewModel for Preview
class DummyPollViewModel: PollViewModel {
    init() {
        super.init(poll: Poll.mockCommunityPolls[0])
    }
}

struct PollView_Previews: PreviewProvider {
    static var previews: some View {
        PollView(viewModel: DummyPollViewModel())
    }
}
