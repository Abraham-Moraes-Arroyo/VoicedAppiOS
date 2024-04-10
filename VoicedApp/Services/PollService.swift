//
//  PollService.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import Firebase

struct PollService {
    
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
    
    
    // Submit a vote for a poll option
    static func vote(for pollId: String, optionId: String) async throws {
        let db = Firestore.firestore()
        let pollRef = db.collection("polls").document(pollId)
        
        try await db.runTransaction { transaction, errorPointer in
            let pollDocument: DocumentSnapshot
            do {
                try pollDocument = transaction.getDocument(pollRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard var options = pollDocument.data()?["options"] as? [[String: Any]] else {
                return nil
            }
            
            // Find the option index
            if let optionIndex = options.firstIndex(where: { $0["id"] as? String == optionId }) {
                // Increment the voteCount
                var option = options[optionIndex]
                option["voteCount"] = ((option["voteCount"] as? Int) ?? 0) + 1
                options[optionIndex] = option
                
                // Update the document
                transaction.updateData(["options": options], forDocument: pollRef)
            } else {
                // Option not found, handle error
            }
            
            return nil
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


