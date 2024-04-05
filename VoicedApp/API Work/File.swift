////
////  File.swift
////  VoicedApp
////
////  Created by Abraham Morales Arroyo on 4/2/24.
////
//
//import Foundation
//import SwiftUI
//
//
//    // Code based on https://matteomanferdini.com/swift-rest-api/
//    struct Wrapper: Codable {
//        let items: [SRType]
//    }
//    
//    struct SRType: Codable {
//        let SR_TYPE: String
//        let Community_Area: String
//        let status: String
//    }
//    
//    
//    func performAPICall() async throws -> SRType {
//        // this is for the Sanitation Code Violation completed and in community area 61
//        let url = URL(string: "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Sanitation%20Code%20Violation&&community_area=61&&status=Completed")!
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
//        return wrapper.items[0]
//    }
//    
//    Task {
//        try await performAPICall()
//    }
//    
//
