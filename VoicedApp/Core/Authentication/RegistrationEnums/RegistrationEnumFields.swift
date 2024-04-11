//
//  RegistrationEnumFields.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/29/24.
//

import Foundation

enum AgeCategory: String, CaseIterable, Identifiable, Codable {
    case under18 = "Under 18"
    case from18to30 = "18 to 30"
    case from31to50 = "31 to 50"
    case above50 = "Above 50"
    
    var id: String { self.rawValue }
}

enum CommunityIssue: String, CaseIterable, Identifiable, Codable {
    case environment = "Environment"
    case education = "Education"
    case smallBusiness = "Small Businesses"
    case crimeSafety = "Crime & Safety"
    case other = "Other"
    
    var id: String { self.rawValue }
}

enum DiscoveryMethod: String, CaseIterable, Identifiable, Codable {
    case socialMedia = "Social Media"
    case friendFamily = "Friend or Family"
    case advertisement = "Flyer"
    case none = "None"
    
    var id: String { self.rawValue }
}

