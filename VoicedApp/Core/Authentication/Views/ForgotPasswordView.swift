//
//  ForgotPasswordView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/5/24.
//

//
//  ForgotPasswordView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel = ForgotPasswordViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("Voicedsignin")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .padding()
            
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(VoicedTextFieldModifier())
                    
            }
            
            Button {
                Task { try await viewModel.sendPasswordResetEmail() }
            } label: {
                Text("Reset Password")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 352, height: 44)
                    .background(Color(red: 0.725, green: 0.878, blue: 0.792)) // #b9e0ca
                    .cornerRadius(8)
                    
                    
                    
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1 : 0.7)
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                Text("Return to login")

                    .font(.footnote)
            }
            .padding(.vertical, 16)
        }
        .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)

        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $viewModel.didSendEmail) {
            Alert(
                title: Text("Email sent"),
                message: Text("An email has been sent to \(viewModel.email) to reset your password"),
                dismissButton: .default(Text("Ok"), action: {
                    dismiss()
                })
            )
        }
    }
}




// MARK: - Form Validation

extension ForgotPasswordView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
