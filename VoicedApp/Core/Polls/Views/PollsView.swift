//
//  PollsView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import SwiftUI

struct PollsView: View {
    @StateObject private var viewModel = PollsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.polls) { poll in
                        PollView(viewModel: PollViewModel(poll: poll))
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding()
            }
            .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)

            .navigationTitle("Community Polls")
        }
    }
}


#Preview {
    PollsView()
}
