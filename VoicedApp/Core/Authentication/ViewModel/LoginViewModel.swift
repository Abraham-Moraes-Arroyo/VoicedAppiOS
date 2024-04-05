//
//  LoginViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/20/24.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticating = false
    @Published var showAlert = false
    @Published var authError: AuthError?
    
    @MainActor
    func signIn()  async throws {
        isAuthenticating = true
                
                do {
                    try await AuthService.shared.login(withEmail: email, password: password)
                    isAuthenticating = false
                } catch {
                    
                    let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
                    self.showAlert = true
                    isAuthenticating = false
                    self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
                }
            }
        }
