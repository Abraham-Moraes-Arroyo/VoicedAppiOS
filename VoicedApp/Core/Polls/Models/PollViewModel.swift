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
            // Your logic to determine if the poll has expired.
            // For example:
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
        // Find the option and optimistically increment the vote count
        if let index = poll.options.firstIndex(where: { $0.id == optionID }) {
            poll.options[index].voteCount += 1
            objectWillChange.send() // Notify observers of the change
        }

        let voteRef = db.collection("polls").document(poll.id).collection("votes").document(userID)
        voteRef.setData(["optionID": optionID, "timestamp": FieldValue.serverTimestamp()]) { [weak self] error in
            if let error = error {
                print("Error voting: \(error.localizedDescription)")
                // Optionally, revert the optimistic UI update here
            } else {
                self?.refreshPoll() // Refresh the poll to get the latest data
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


