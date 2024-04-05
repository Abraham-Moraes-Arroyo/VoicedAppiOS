//
//  RegistrationViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/19/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class RegistrationViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    @Published var isAuthenticating = false
    @Published var showAlert = false
    @Published var authError: AuthError?
    
    @Published var zipCode: String? // optional
    @Published var selectedAge: AgeCategory?
        
    @Published var reasonForUsing: String? // optional
    
    // its not "optional" because if they select nothing it will be an empty array
    @Published var selectedCommunityIssues: [CommunityIssue] = []
        @Published var communityIssueOther: String? // optional custom input

        func isCommunityIssueSelected(_ issue: CommunityIssue) -> Bool {
            selectedCommunityIssues.contains(issue)
        }

        func toggleCommunityIssue(_ issue: CommunityIssue) {
            if let index = selectedCommunityIssues.firstIndex(of: issue) {
                selectedCommunityIssues.remove(at: index)
                // If "Other" is deselected, clear any text input
                if issue == .other {
                    communityIssueOther = nil
                }
            } else {
                selectedCommunityIssues.append(issue)
            }
        }
    
    // its not "optional" because if they select nothing it will be an empty array
    @Published var selectedDiscoveryMethod: [DiscoveryMethod] = []
        @Published var discoveryMethodOther: String? // optional custom input

        func isDiscoveryMethodSelected(_ method: DiscoveryMethod) -> Bool {
            selectedDiscoveryMethod.contains(method)
        }


        func toggleDiscoveryMethod(_ method: DiscoveryMethod) {
            if let index = selectedDiscoveryMethod.firstIndex(of: method) {
                selectedDiscoveryMethod.remove(at: index)
            
            } else {
                selectedDiscoveryMethod.append(method)
            }
        }
    

    @MainActor
    func createUser() async throws {
        isAuthenticating = true
        do {
            var additionalData: [String: Any] = [:]
                    
            // Add optional fields to additionalData if they are not nil
            if let zipCode = zipCode {
                additionalData["zipCode"] = zipCode
            }
            if let selectedAge = selectedAge?.rawValue {
                additionalData["selectedAge"] = selectedAge
            }
            if let reasonForUsing = reasonForUsing {
                additionalData["reasonForUsing"] = reasonForUsing
            }
            additionalData["selectedCommunityIssues"] = selectedCommunityIssues.map { $0.rawValue }
            if let communityIssueOther = communityIssueOther {
                        additionalData["communityIssueOther"] = communityIssueOther
            }
            additionalData["selectedDiscoveryMethod"] = selectedDiscoveryMethod.map { $0.rawValue }
            if let discoveryMethodOther = discoveryMethodOther {
                        additionalData["discoveryMethodOther"] = discoveryMethodOther
            }
                    
            // Now pass the additionalData dictionary to the createUser method
            try await AuthService.shared.createUser(email: email, password: password, username: username, additionalData: additionalData)
                    
            username = ""
            email = ""
            password = ""
            // resets values when creating another user
            // Reset optional fields as well
                    zipCode = nil
                    selectedAge = nil
                    reasonForUsing = nil
                    selectedCommunityIssues = []
                    communityIssueOther = nil
                    selectedDiscoveryMethod = []
                    discoveryMethodOther = nil
            
            isAuthenticating = false
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            isAuthenticating = false
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
        }
        
    }
    
    func selectAge(_ age: AgeCategory) {
        if selectedAge == age {
            selectedAge = nil // Deselect if the same age category is tapped again
        } else {
            selectedAge = age }
    }
}
