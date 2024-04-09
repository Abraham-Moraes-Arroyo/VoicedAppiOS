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
        let snapshot = try await pollsCollection.getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Poll.self) }
    }

    // Submit a vote for a poll option
    static func vote(for pollId: String, optionId: String) async throws {
        // Increment the voteCount for the specified option in the poll
        let optionPath = "options.\(optionId).voteCount"  // Adjust based on your data structure
        let increment = FieldValue.increment(Int64(1))
        try await pollsCollection.document(pollId).updateData([optionPath: increment])
    }
    
    static func createPoll(_ poll: Poll) async throws {
            do {
                
                try await pollsCollection.document(poll.id).setData(from: poll)
            } catch {
                // Handle or throw error
                throw error
            }
        }
    
    // Fetch polls filtered by month and year
//    static func fetchPollsFiltered(byMonth month: Int, year: Int) async throws -> [Poll] {
//        let startOfPeriod = DateComponents(year: year, month: month).date!
//        let endOfPeriod = Calendar.current.date(byAdding: .month, value: 1, to: startOfPeriod)!
//        
//        let snapshot = try await pollsCollection
//            .whereField("createdAt", isGreaterThanOrEqualTo: startOfPeriod)
//            .whereField("createdAt", isLessThan: endOfPeriod)
//            .getDocuments()
//        
//        return try snapshot.documents.compactMap { try $0.data(as: Poll.self) }
//    }
}

