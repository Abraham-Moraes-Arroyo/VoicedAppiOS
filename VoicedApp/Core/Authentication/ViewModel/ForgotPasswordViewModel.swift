//
//  ForgotPasswordViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/5/24.
//

import Foundation

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var didSendEmail = false
    
    func sendPasswordResetEmail() async throws {
        try await AuthService.shared.sendPasswordResetEmail(toEmail: email)
        didSendEmail = true
    }
}
