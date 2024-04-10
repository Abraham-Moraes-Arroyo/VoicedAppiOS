//
//  PollService.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import Firebase

struct PollService {
    static let db = Firestore.firestore()
    
    private static let pollsCollection = Firestore.firestore().collection("polls")
    
    // Fetch all polls
    static func fetchPolls() async throws -> [Poll] {
        let snapshot = try await Firestore.firestore().collection("polls").getDocuments()
        let polls = try snapshot.documents.map { document -> Poll in
            var poll = try document.data(as: Poll.self)
            poll.id = document.documentID // Ensuring the poll's ID is set
            return poll
        }
        return polls
    }
    
    
    static func vote(for pollId: String, optionId: String, userId: String) async throws {
        let pollRef = db.collection("polls").document(pollId)
        let userVoteRef = pollRef.collection("votes").document(userId)
        
        do {
            try await db.runTransaction({ (transaction, errorPointer) -> Any? in
                let pollDocument: DocumentSnapshot
                do {
                    pollDocument = try transaction.getDocument(pollRef)
                } catch let fetchError as NSError {
                    // Properly assign the caught error to errorPointer
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                var options = pollDocument.data()?["options"] as? [[String: Any]] ?? []
                let userVoteDocument = try? transaction.getDocument(userVoteRef)
                let previousOptionId = userVoteDocument?.data()?["optionId"] as? String
                
                if let prevOptionId = previousOptionId, prevOptionId != optionId {
                    // Decrement vote count for the previous option
                    if let index = options.firstIndex(where: { $0["id"] as? String == prevOptionId }) {
                        var option = options[index]
                        option["voteCount"] = ((option["voteCount"] as? Int) ?? 1) - 1
                        options[index] = option
                    }
                }
                
                // Increment vote count for the new option
                if let index = options.firstIndex(where: { $0["id"] as? String == optionId }) {
                    var option = options[index]
                    option["voteCount"] = ((option["voteCount"] as? Int) ?? 0) + 1
                    options[index] = option
                } else {
                    // If the optionId does not exist in the options array, handle the error
                    let error = NSError(domain: "AppError", code: 100, userInfo: [NSLocalizedDescriptionKey: "Option does not exist."])
                    errorPointer?.pointee = error
                    return nil
                }

                // Update the poll with the adjusted option counts
                transaction.updateData(["options": options], forDocument: pollRef)

                // Always update/set the user's vote
                transaction.setData(["optionId": optionId], forDocument: userVoteRef)

                return nil
            })
        } catch let transactionError as NSError {
            // Handle the transaction error
            throw transactionError
        }
    }


    
    static func createPoll(_ poll: Poll) async throws {
            let db = Firestore.firestore()
            let pollRef = db.collection("polls").document(poll.id)
            do {
                // Convert Poll object to dictionary or directly use Firestore Codable support
                try pollRef.setData(from: poll)
            } catch let error {
                throw error
            }
        }
}


