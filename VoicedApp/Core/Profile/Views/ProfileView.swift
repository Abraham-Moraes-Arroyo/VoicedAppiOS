//
//  ProfileView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import SwiftUI
struct ProfileView: View {
    let user: User
    @State private var selectedFilter: ProfilePostFilter = .posts
    @Namespace var animation
        
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ProfilePostFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 20
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                // Header
                ProfileHeaderView(user: user)
                
                // user content list view
                UserContentListView(user: user)
            }
            .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)

        }
        .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)

        .padding(.horizontal)
        .navigationBarTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(user: User.MOCK_USERS[0])
}
