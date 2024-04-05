//
//  PostCategory.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import Foundation
import SwiftUI
enum PostCategory: String, Codable, CaseIterable {
    case miscellaneous = "Miscellaneous"
    case reports = "Reports"
    case happyHighlights = "Happy Highlights"
    case events = "Events"
    case localNews = "Local News"
//    case education = "Education"
    case businesses = "Business"
    
    var displayName: String {
        switch self {
        case .reports:
            return "🚨 \(self.rawValue)"
        case .happyHighlights:
            return "🙌  \(self.rawValue)"
        case .events:
            return "🎉 \(self.rawValue)"
        case .localNews:
            return "👀 \(self.rawValue)"
        case .businesses:
            return "🍽️ \(self.rawValue)"
            
        default:
            return self.rawValue
        }
    }
}
extension PostCategory {
    var color: Color {
        switch self {
        case .miscellaneous:
            return Color(red: 0.498, green: 0.792, blue: 0.651) // #7fcaa6
        case .reports:
            return Color(red: 0.984, green: 0.733, blue: 0.612) // #fbbb9c
        case .happyHighlights:
            return Color(red: 0.059, green: 0.098, blue: 0.165) // #0f192a
        case .events:
            return Color(red: 0.482, green: 0.094, blue: 0.357) // #7b185b
        
//        case .government:
//            return Color(red: 0.725, green: 0.878, blue: 0.792) // #b9e0ca
//        case .education:
//            return Color(red: 0.969, green: 0.843, blue: 0.804) // #f7d7cd
        case .businesses:
            return Color(red: 0.384, green: 0.4, blue: 0.408) // #626668
        case .localNews:
            return Color(red: 0.969, green: 0.843, blue: 0.804) // #f7d7cd
        }
    }
}

