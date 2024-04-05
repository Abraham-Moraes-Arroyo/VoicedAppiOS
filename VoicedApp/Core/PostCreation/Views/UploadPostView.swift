//
//  UploadPostView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import SwiftUI
import PhotosUI

struct UploadPostView: View {
    @State private var title = ""
    @State private var caption = ""
    @State private var selectedCategory: PostCategory = .miscellaneous
    @State private var imagePickerPresented = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String = ""
    
    @StateObject var viewModel = UploadPostViewModel()
    
    @Binding var tabIndex: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    clearPostDataAndReturnToForum()
                }
                Spacer()
                Text("What's going on?")
                    .fontWeight(.semibold)
                Spacer()
                
                if viewModel.isUploading {
                    ProgressView()
                } else {
                    Button("Upload") {
                        uploadPost()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty || viewModel.postImage == nil)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 8) {
                    Button(action: {
                        imagePickerPresented = true
                    }) {
                        if let image = viewModel.postImage {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .foregroundColor(.gray)
                        }
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $imagePickerPresented) {
                        PhotosPicker(selection: $viewModel.selectedImage, matching: .images, photoLibrary: .shared()) {
                            Text("Click here to add a photo")
                        }
                    }

                    TextField("Enter your title...", text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Enter your caption...", text: $caption)
                        .textFieldStyle(.roundedBorder)
                    HStack(spacing: 5) {
                        Text("Choose a category")
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(PostCategory.allCases, id: \.self) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                }
                .padding()
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Upload Failed"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func uploadPost() {
        guard !title.isEmpty, let _ = viewModel.postImage else { return }
        viewModel.isUploading = true
        
        Task {
            do {
                try await viewModel.uploadPost(title: title, caption: caption, category: selectedCategory)
                clearPostDataAndReturnToForum()
            } catch {
                viewModel.isUploading = false
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
    
    func clearPostDataAndReturnToForum() {
        title = ""
        caption = ""
        viewModel.reset()
        tabIndex = 0
        dismiss()
    }
}



#Preview {
    UploadPostView(tabIndex: .constant(0))
}
