//
//  ProfilePostFilter.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import Foundation
enum ProfilePostFilter: Int, CaseIterable, Identifiable{
    case posts
    case upvoted_posts
    case bookmarks
    
    var title: String {
        switch self {
            case .posts: return "Posts"
            case .upvoted_posts: return "Upvoted Posts"
            case .bookmarks: return "Bookmarks"
        
        }
    }
    
    var id: Int { return self.rawValue }
}

