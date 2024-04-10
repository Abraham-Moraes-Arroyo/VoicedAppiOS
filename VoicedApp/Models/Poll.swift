//
//  Poll.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import Foundation
import Firebase

struct Poll: Identifiable, Codable {
    var id: String // Make sure there's a unique identifier
    var question: String
    var options: [PollOption]
    var createdAt: Timestamp
    var expiresAt: Timestamp?

    struct PollOption: Identifiable, Codable {
        var id: String
        var text: String
        var voteCount: Int
    }
}


extension Poll {
    static let mockCommunityPolls: [Poll] = [
        Poll(id: UUID().uuidString,
             question: "How satisfied are you with the current number/range of recreational activities available in our community?",
             options: [
                PollOption(id: UUID().uuidString, text: "Very Satisfied", voteCount: 5),
                PollOption(id: UUID().uuidString, text: "Somewhat Satisfied", voteCount: 15),
                PollOption(id: UUID().uuidString, text: "Neutral", voteCount: 8),
                PollOption(id: UUID().uuidString, text: "Somewhat Dissatisfied", voteCount: 3),
                PollOption(id: UUID().uuidString, text: "Very Dissatisfied", voteCount: 1)
             ],
             createdAt: Timestamp(date: Date()), // Adjusted to use the current date
             expiresAt: Timestamp(date: Date().addingTimeInterval(86400 * 7))), // Expires in one week, adjusted to use Date()
        Poll(id: UUID().uuidString,
             question: "Do you feel well-informed about local government decisions and policies that directly impact the community?",
             options: [
                PollOption(id: UUID().uuidString, text: "Yes", voteCount: 18),
                PollOption(id: UUID().uuidString, text: "Somewhat", voteCount: 10),
                PollOption(id: UUID().uuidString, text: "No", voteCount: 4)
             ],
             createdAt: Timestamp(date: Date()), // Using current date
             expiresAt: Timestamp(date: Date().addingTimeInterval(86400 * 7))) // Expires in one week, using Date()
    ]
}

extension Poll {
    var formattedCreatedAt: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: createdAt.dateValue())
    }
    
    
}
