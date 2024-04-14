//
//  ProfileHeaderView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import SwiftUI
struct ProfileHeaderView: View {
    let user: User
    @State private var showEditProfile = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            VStack(alignment: .leading) {
                HStack {
                    CircularProfileImageView(user: user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(user.username .prefix(8))
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(user.bio ?? "")
                            .font(.footnote)
                    }
                    .frame(width: 130, alignment: .leading)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                if user.isCurrentUser {
                    Button {
                        if user.isCurrentUser {
                            showEditProfile.toggle()
                        }
                    } label : {
                     Text("Edit")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: 48, minHeight: 33)
                        .background(Color(red: 0.498, green: 0.792, blue: 0.651))
                        .foregroundStyle(.black)
//                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    
                    .padding(.horizontal)
                    
                } else {
                    Button(action: { print("Report Post") }) {
                        HStack {
                            Image(systemName: "flag")
                            
                        }
                    }
                }
                
                
                Divider()
            }
        }
        .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)

        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showEditProfile) {
            EditProfileView(user: user)
        }
    }
}

#Preview {
    ProfileHeaderView(user: User.MOCK_USERS[0])
}
