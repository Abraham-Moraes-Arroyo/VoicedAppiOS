//
//  CurrentUserProfileView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import SwiftUI
struct CurrentUserProfileView: View {
    
    let user: User
    
    @State private var selectedFilter: ProfilePostFilter = .posts
    @Namespace var animation
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ProfilePostFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 20
    }
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    HStack {
                        // header
                        ProfileHeaderView(user: user)
                        
//                         settings button for user to sign out and delete account
                        NavigationLink {
                    SettingsView()
                                        } label: {
                                            Image(systemName: "line.3.horizontal")
                                                .foregroundColor(.black)
                                        }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                            
                        .padding(.bottom, 50)
                    }
                                    
                    // user content list view
                    UserContentListView(user: user)
                        
                }
            }
            .padding(.horizontal)
        }

    }
}

#Preview {
    CurrentUserProfileView(user: User.MOCK_USERS[0])
}
