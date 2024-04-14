//
//  EditProfileView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import SwiftUI
import PhotosUI
struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: EditProfileViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                
                
                VStack {
                    // profile image
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Edit Profile Picture")
                                .fontWeight(.semibold)

                            PhotosPicker(selection: $viewModel.selectedImage) {
                                if let image = viewModel.profileImage {
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .background(.gray)
                                        .clipShape(Circle())
                                } else {
                                    CircularProfileImageView(user: viewModel.user, size: .small)
                                }
                            }
                            
                        }
                        
                        Spacer()
                    
                       
                        
                    }
                    
                    Divider()
                    
                    // bio field
                    
                    VStack(alignment: .leading) {
                        Text("Bio")
                            .fontWeight(.semibold)
                        TextField("Enter your bio...", text: $viewModel.bio, axis: .vertical)
                    }
                    .font(.footnote)
                    
                    Divider()
                }
                .font(.footnote)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
                .padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // when user clicks on this button first its data is updated and then this view is dismissed
                        Task {
                            try await viewModel.updateUserData()
                            dismiss()
                        }
                    } label: {
                        Text("Done")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    }
                }
            }
            
            
            
            
            
        }
    }
}

struct EditProfileRowView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 8)
                .frame(width: 100, alignment: .leading)
            
            VStack {
                TextField(placeholder, text: $text)
                
                Divider()
            }
        }
        .font(.subheadline)
        .frame(height: 36)
    }
    
}

#Preview {
    EditProfileView(user: User.MOCK_USERS[0])
}
