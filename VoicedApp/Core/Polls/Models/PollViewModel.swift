//
//  PollViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class PollViewModel: ObservableObject {
    @Published var poll: Poll
    @Published var selectedOptionId: String? = nil
    @Published var voteCounts: [String: Int] = [:] // To hold vote counts for each option
    private let db = Firestore.firestore()

    init(poll: Poll) {
        self.poll = poll
        countVotesForPoll()
    }
    
    var expiresAtFormatted: String {
        guard let expiresAt = poll.expiresAt?.dateValue() else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: expiresAt)
    }
       
    var pollHasExpired: Bool {
        if let expiresAt = poll.expiresAt?.dateValue(), Date() > expiresAt {
            return true
        }
        return false
    }
    
    // Asynchronously fetch and count votes for each option
    func countVotesForPoll() {
        Task {
            for option in poll.options {
                let count = try await PollService.countVotes(for: poll.id, optionId: option)
                DispatchQueue.main.async {
                    self.voteCounts[option] = count
                }
            }
        }
    }
    
    func vote(for optionID: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let voteRef = db.collection("polls").document(poll.id).collection("votes").document(userID)

        Task {
            do {
                try await voteRef.setData(["optionID": optionID, "timestamp": FieldValue.serverTimestamp()])
                // After a successful vote, refresh the votes for the poll
                self.countVotesForPoll()
            } catch let error {
                print("Error voting: \(error.localizedDescription)")
            }
        }
    }
}

