//
//  SettingsView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/19/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = AccountDeletionViewModel()
    @State private var showActionSheet = false
    @State private var showReauthentication = false
    @State private var showReportPopup = false  // Add this state for report popup

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Settings options
                ForEach(SettingsOptions.allCases) { option in
                    NavigationLink(destination: option.destinationView) {
                        HStack {
                            Image(systemName: option.imageName)
                            Text(option.title)
                                .font(.subheadline)
                        }
                    }
                }
                
                Button("Report Issue") {
                                    showReportPopup = true
                                }


                
                // Delete Account Button
                Button(action: {
                    self.showActionSheet = true
                }) {
                    HStack {
                        Image(systemName: "xmark.circle").foregroundColor(.red)
                        Text("Delete Account")
                            .font(.system(size: 15))
                            .foregroundColor(.red)
                    }
                }
                .cornerRadius(10)
                .padding(.trailing, 20)
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Delete"), message: Text("Are you sure you want to delete your account?"),
                        buttons: [
                            .destructive(Text("Yes, delete my account."), action: {
                                self.showReauthentication = true
                            }),
                            .cancel()
                        ])
                }

                // Log Out Button
                VStack(alignment: .leading) {
                    Divider()
                    Button("Log Out") {
                        AuthService.shared.signOut()
                    }
                    .font(.subheadline)
                    .listRowSeparator(.hidden)
                    .padding(.top)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.black)
            .sheet(isPresented: $showReportPopup) {
                            ReportPopupView(isPresented: $showReportPopup)
                        }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "An unknown error occurred"), dismissButton: .default(Text("OK")))
            }
        }
        .sheet(isPresented: $showReauthentication) {
            // ReauthenticationView with necessary logic
            ReauthenticationView(isPresented: $showReauthentication) {
                Task {
                    try await AuthService.shared.deleteUser()
                }
            }
        }
    }
}


#Preview {
    SettingsView()
}
