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
                ForEach(viewModel.poll.options, id: \.self) { option in
                    Button(action: {
                        viewModel.vote(for: option)
                    }) {
                        OptionRow(optionText: option, isSelected: viewModel.selectedOption == option, voteCount: viewModel.voteCounts[option, default: 0])
                    }
                }
                
                Text("Expires: \(viewModel.expiresAtFormatted)")
                    .font(.footnote)
                    .padding(.top, 5)
            } else {
                ForEach(viewModel.poll.options, id: \.self) { option in
                    OptionRow(optionText: option, isSelected: false, voteCount: viewModel.voteCounts[option, default: 0])
                }
            }
        }
        .padding()
        .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
    }
}


// Updated OptionRow to optionally show vote counts
struct OptionRow: View {
    let optionText: String
    var isSelected: Bool
    var voteCount: Int

    var body: some View {
        HStack {
            Text(optionText)
                .foregroundColor(isSelected ? .white : .primary)
            Spacer()
            
            Text("\(voteCount) votes")
                .font(.footnote)
                .foregroundColor(isSelected ? .white : .gray)
        }
        .padding()
        .background(isSelected ? Color.green : Color.gray.opacity(0.2))
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
