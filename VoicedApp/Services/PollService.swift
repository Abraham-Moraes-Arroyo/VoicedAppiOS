//
//  PollService.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import Firebase
import FirebaseFirestoreSwift

struct PollService {
    private static let db = Firestore.firestore()
    private static let pollsCollection = db.collection("polls")
    
    // Fetch all polls
    static func fetchPolls() async throws -> [Poll] {
        let snapshot = try await pollsCollection.getDocuments()
        return try snapshot.documents.map { document -> Poll in
            var poll = try document.data(as: Poll.self)
            poll.id = document.documentID // Ensuring the poll's ID is set
            return poll
        }
    }
    
    // Vote or update vote for a poll option
    static func vote(for pollId: String, optionId: String, userId: String) async throws {
        let userVoteRef = pollsCollection.document(pollId).collection("votes").document(userId)
        try await userVoteRef.setData(["optionId": optionId])
    }
    
    // Count votes for a specific poll option
    static func countVotes(for pollId: String, optionId: String) async throws -> Int {
        let votesRef = db.collection("polls").document(pollId).collection("votes")
        // Use a completion handler with getDocuments
        let querySnapshot = try await votesRef.whereField("optionID", isEqualTo: optionId).getDocuments()
        return querySnapshot.documents.count
    }

    
    // Create a new poll
    static func createPoll(_ poll: Poll) async throws {
        let pollRef = pollsCollection.document(poll.id)
        try pollRef.setData(from: poll)
    }
}



