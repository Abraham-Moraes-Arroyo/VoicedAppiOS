//
//  ReauthenticationView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/5/24.
//

import SwiftUI

struct ReauthenticationView: View {
    @Binding var isPresented: Bool
    var onReauthenticationSuccess: () -> Void

    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if showError {
                    Text("Reauthentication failed. Please try again.")
                        .foregroundColor(.red)
                        .padding()
                }

                Button("Reauthenticate") {
                    isLoading = true
                    showError = false
                    reauthenticateUser()
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 352, height: 44)
                .background(Color(red: 0.725, green: 0.878, blue: 0.792)) // #b9e0ca
                .cornerRadius(8)
                .disabled(password.isEmpty)
                .opacity(!password.isEmpty ? 1 : 0.7)
                .padding(.vertical)
            }
        }
        .padding()
    }

    private func reauthenticateUser() {
        Task {
            do {
                try await AuthService.shared.reauthenticate(password: password)
                onReauthenticationSuccess()
            } catch {
                showError = true
            }
            isLoading = false
            isPresented = false
        }
    }
}

#Preview {
    ReauthenticationView(isPresented: .constant(true), onReauthenticationSuccess: {})
}
