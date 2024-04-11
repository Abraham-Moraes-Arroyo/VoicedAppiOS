//
//  PrivacyView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/5/24.
//

import SwiftUI

struct PrivacyView: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("At Voiced, we are committed to protecting your privacy and ensuring the security of your personal information.")
                    .font(.body)
                
                Text("Data Collection")
                    .font(.headline)
                
                Text("We collect certain information to provide you with our services, improve user experience, and for analytics purposes. This may include personal data like name, email, and location data.")
                    .font(.body)
                
                Text("Data Usage")
                    .font(.headline)
                
                Text("Your data is used to enhance your experience within the app, personalize content, and may be used for marketing purposes.")
                    .font(.body)
                
                Text("Permissions")
                    .font(.headline)
                
                Text("Voiced may require access to your device's location, camera, and contacts to provide certain features. You can manage these permissions in your device settings.")
                    .font(.body)
                
                Text("To read full Privacy Policy")
                    .font(.headline)
                
                Button("Privacy Policy") {
                                    // Safely unwrap the URL and attempt to open it
                                    if let url = URL(string: "https://voicedapp.wixsite.com/voiced-1") {
                                        openURL(url)
                                    }
                                }
                                .foregroundColor(.blue)
                                .font(.body)
                                .padding(.leading, 15)
                
                
                Text("Contact Us")
                    .font(.headline)
                

                Text("For any privacy-related concerns or inquiries, please contact our support team at ")
                    .font(.body)
                    .foregroundColor(.black)
                Button(action: {
                        if let url = URL(string: "mailto:joannarodriguez134@gmail.com") {
                            UIApplication.shared.open(url)
                        }
                }) {
                    Text("eccinchicago@gmail.com")
                        .font(.body)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10) // Add padding inside the rounded rectangle
                        .padding(.vertical, 5)    // Add padding inside the rounded rectangle
                        .background(
                            RoundedRectangle(cornerRadius: 10) // Rounded rectangle shape
                                .foregroundColor(Color.black.opacity(0.3)) // Background color
                        )
                    
                    
                }
                
            }
            .padding()
            .navigationBarTitle("Privacy Policy", displayMode: .inline)
        }
    }
}

#Preview {
    NavigationView {
        PrivacyView()
    }
}
