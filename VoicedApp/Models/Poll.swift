//
//  Poll.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import Foundation
import Firebase

struct Poll: Identifiable, Codable {
    var id: String // A unique identifier for the poll.
    var question: String // The question posed by the poll.
    var options: [String] // An array of option texts.
    var createdAt: Timestamp // When the poll was created.
    var expiresAt: Timestamp? // Optional expiration time for the poll.

    // Mock data for community polls without vote counts in options.
    static let mockCommunityPolls: [Poll] = [
        Poll(id: UUID().uuidString,
             question: "How satisfied are you with the current number/range of recreational activities available in our community?",
             options: ["Very Satisfied", "Somewhat Satisfied", "Neutral", "Somewhat Dissatisfied", "Very Dissatisfied"],
             createdAt: Timestamp(date: Date()), // Use the current date
             expiresAt: Timestamp(date: Date().addingTimeInterval(86400 * 7))), // Expires in one week
        Poll(id: UUID().uuidString,
             question: "Do you feel well-informed about local government decisions and policies that directly impact the community?",
             options: ["Yes", "Somewhat", "No"],
             createdAt: Timestamp(date: Date()), // Use the current date
             expiresAt: Timestamp(date: Date().addingTimeInterval(86400 * 7))) // Expires in one week
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
