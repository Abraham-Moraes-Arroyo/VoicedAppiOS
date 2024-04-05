//
//  HTMLParser.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/31/24.
//

import Foundation
import Firebase
import SwiftSoup

final class HTMLParser {
    
    func parse(html: String) -> [Post] {
        var posts: [Post] = []
        
        do {
            let document: Document = try SwiftSoup.parse(html)
            let articleElements = try document.select("article")
            
            // Print the number of articles found
            print("Number of articles found: \(articleElements.size())")
            
            for element in articleElements.array() {
                let title = try element.select("h2.entry-title").text()
                let link = try element.select("h2.entry-title > a").attr("href")
                let summary = try element.select("div.entry-content").text()
                
                // Print details of each article
                print("Article title: \(title)")
                print("Article link: \(link)")
                print("Article summary: \(summary)")
                
                let post = Post(id: UUID().uuidString,
                                ownerUid: nil,
                                title: title,
                                caption: link,
                                likes: 0,
                                dislikes: 0,
                                favorites: 0,
                                comments: 0,
                                imageUrl: "default-post-image",
                                timestamp: Timestamp(),
                                user: nil,
                                category: .localNews
                                )
                posts.append(post)
            }
        } catch {
            print("Error parsing HTML: \(error)")
        }
        
        // Print the total number of posts created
        print("Total posts created: \(posts.count)")
        
        return posts
    }
}



