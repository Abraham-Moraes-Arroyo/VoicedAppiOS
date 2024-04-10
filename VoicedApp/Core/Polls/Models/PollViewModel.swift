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
    private let db = Firestore.firestore()

    init(poll: Poll) {
        self.poll = poll
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
    
    var totalVotes: Int {
//        print("total votes: \(self.totalVotes)")
        return poll.options.reduce(0) { $0 + $1.voteCount }
    }

    
    func vote(for optionID: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        // Reference to the user's vote document to prevent double voting
        let voteRef = db.collection("polls").document(poll.id).collection("votes").document(userID)

        // Attempt to set the user's vote
        voteRef.setData(["optionID": optionID, "timestamp": FieldValue.serverTimestamp()]) { [weak self] error in
            if let error = error {
                print("Error voting: \(error.localizedDescription)")
            } else {
                // Successfully voted, now increment the vote count atomically
                let optionVoteCountRef: Void? = self?.db.collection("polls").document(self?.poll.id ?? "").updateData([
                    "options.\(optionID).voteCount": FieldValue.increment(Int64(1))
                ]) { error in
                    if let error = error {
                        print("Error incrementing vote count: \(error.localizedDescription)")
                        // Optionally handle reverting the optimistic local UI update
                    } else {
                        // Successfully incremented vote count
                        self?.refreshPoll() // Consider refreshing the poll to reflect the updated count
                    }
                }
            }
        }
    }



    private func refreshPoll() {
        let pollRef = db.collection("polls").document(poll.id)
        pollRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                do {
                    self?.poll = try document.data(as: Poll.self)
                } catch {
                    print("Error parsing poll: \(error.localizedDescription)")
                }
            }
        }
    }
}


