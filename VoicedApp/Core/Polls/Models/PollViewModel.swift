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
    @Published var selectedOption: String? = nil // Updated for clarity
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
                do {
                    let count = try await PollService.countVotes(for: poll.id, optionText: option)
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                        self.voteCounts[option] = count
                        print(self.voteCounts)
                    }
                } catch let error {
                    print("Error counting votes for option \(option): \(error.localizedDescription)")
                }
            }
        }
    }

    
    func vote(for optionText: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let voteRef = db.collection("polls").document(poll.id).collection("votes").document(userID)

        Task {
            do {
                try await voteRef.setData(["optionText": optionText, "timestamp": FieldValue.serverTimestamp()])
                // After a successful vote, refresh the votes for the poll
                DispatchQueue.main.async {
                               self.selectedOption = optionText // Update the selected option
                               self.countVotesForPoll() // Refresh the votes count
                           }
               
            } catch let error {
                print("Error voting: \(error.localizedDescription)")
            }
        }
    }
}

