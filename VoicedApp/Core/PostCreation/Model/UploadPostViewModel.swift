//
//  UploadPostViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/19/24.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase

@MainActor
class UploadPostViewModel: ObservableObject {
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    
    @Published var postImage: Image?
    private var uiImage: UIImage?
    
    // Add an isUploading state to manage upload status
    @Published var isUploading = false

    // This function looks at the item from the PhotosPickerItem, creates data, and generates the SwiftUI Image
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func uploadPost(title: String, caption: String, category: PostCategory) async throws {
        guard let uid = Auth.auth().currentUser?.uid, let uiImage = uiImage else { return }
        
        isUploading = true
        
        let postRef = Firestore.firestore().collection("posts").document()
        
        guard let imageUrl = try await ImageUploader.uploadImage(image: uiImage) else {
            isUploading = false
            throw NSError(domain: "UploadPostViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image upload failed"])
        }

        let post = Post(id: postRef.documentID, ownerUid: uid, title: title, caption: caption, likes: 0, dislikes: 0, favorites: 0, comments: 0, imageUrl: imageUrl, timestamp: Timestamp(), category: category)
        
        do {
            try await postRef.setData(from: post)
        } catch {
            isUploading = false
            throw error
        }
        
        isUploading = false
    }
    
    // Reset function to clear the state
    func reset() {
        selectedImage = nil
        postImage = nil
        isUploading = false
    }
}
