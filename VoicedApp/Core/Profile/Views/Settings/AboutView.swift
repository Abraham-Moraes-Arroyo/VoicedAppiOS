//
//  AboutView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/5/24.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image("Voicedsignin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()
                
                Text("Welcome to Voiced:")
                    .font(.headline)
                    .padding(.top, 10)
                    .padding(.leading, 15)
                
                Text("Voiced is dedicated to the New City community in Chicago, a platform where your voice matters. Discover what's happening in your neighborhood, see areas that need your attention, and learn how you can make a difference with monthly updates on top community concerns. Engage in meaningful conversations, share your passions, and voice your concerns with ease.")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 15)
                
                Text("Key Features:")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.leading, 15)
                
                FeatureItemView(feature: "Community Insights",
                                description: "Stay updated with monthly summaries of top 311 reports and community needs. Understand where your voice and efforts are needed the most.")
                
                FeatureItemView(feature: "Engage & Share",
                                description: "Create posts categorized by your interests or concerns and share them with community members who resonate with your thoughts.")
                
                FeatureItemView(feature: "Polls & Collaborations",
                                description: "Use polls to gauge community interest and drive collective action. Share ideas and collaborate on solutions that bring positive change.")
                
                FeatureItemView(feature: "Spread the Word",
                                description: "Amplify your voice within the New City community. Share what matters to you and encourage others to join the conversation.")
                

                Text("Visit our webpage:")
                    .font(.headline)
                    .padding(.leading, 15)
                
                Button("https://voicedapp.wixsite.com/voiced-1") {
                                    // Safely unwrap the URL and attempt to open it
                                    if let url = URL(string: "https://voicedapp.wixsite.com/voiced-1") {
                                        openURL(url)
                                    }
                                }
                                .foregroundColor(.blue)
                                .font(.body)
                                .padding(.leading, 15)
                
                
            }
            .padding()
        }
        .navigationTitle("About Voiced")
    }
}

struct FeatureItemView: View {
    let feature: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(feature)
                .font(.headline)
                .padding(.leading, 15)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.leading, 15)
        }
        .padding(.bottom)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}

