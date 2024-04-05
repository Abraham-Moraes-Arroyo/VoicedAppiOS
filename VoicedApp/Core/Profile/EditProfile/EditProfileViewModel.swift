//
//  EditProfileViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/22/24.
//

import SwiftUI
import PhotosUI
import Firebase

// same logic as upload post view model
@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    
    @Published var profileImage: Image?
    @Published var bio = ""
    
    private var uiImage: UIImage?
    
    init(user: User) {
        self.user = user
        
        if let bio = user.bio {
            self.bio = bio
        }
    }
    
//     this function is looking at the item from the photospicker item ->
//   creates data -> creates uiImage -> which generates the swiftUI image
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateUserData() async throws {
        // update profile image if changed
        
        // data dictionary with key and value
        var data = [String: Any]()
        
        // once image is uploaded to firebase store we can get it to store it in the database
        if let uiImage = uiImage {
            let imageUrl = try? await ImageUploader.uploadImage(image: uiImage)
            data["profileImageUrl"] = imageUrl
        }

        // update bio if changed
        if !bio.isEmpty && user.bio != bio {
            data["bio"] = bio
            
        }
        // making sure data is being changed before updating
        if !data.isEmpty {
            try await Firestore.firestore().collection("users").document(user.id).updateData(data)
        }
        
    }
}
