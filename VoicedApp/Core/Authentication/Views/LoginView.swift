//
//  LoginView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import SwiftUI
struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Welcome to Voiced")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Your Comments. Your Solution. Your Voice.")
                    .font(.caption)
                
                Image("Voicedsignin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                
                VStack {
                    TextField("Enter your email...", text: $viewModel.email)
                        .modifier(VoicedTextFieldModifier())
                        .autocapitalization(.none)
                    SecureField("Enter your password...", text: $viewModel.password)
                        .modifier(VoicedTextFieldModifier())
                
                }
                
                NavigationLink {
                    ForgotPasswordView()
                } label: {
                    Text("Forgot Password?")
                        .fontWeight(.semibold)
                        .padding(.vertical, 5)
                        .padding(.trailing, 28)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.footnote)
                }
                
                Button {
                    Task { try await viewModel.signIn() }
                } label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 352, height: 44)
                        .background(Color(red: 0.725, green: 0.878, blue: 0.792)) // #b9e0ca
                        .cornerRadius(8)
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1 : 0.7)
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        
                        Text("Sign up")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .font(.footnote)
                }
                .padding(.vertical, 16)
                
            }
            .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)

            .alert(isPresented: $viewModel.showAlert) {
                            Alert(title: Text("Error"),
                                  message: Text(viewModel.authError?.description ?? ""))
        }
    }
        .background(Color(red: 0.973, green: 0.949, blue: 0.875)) // #f8f2df)

        
    }
}
// MARK: - Form Validation

extension LoginView: AuthenticationFormProtocol {
                var formIsValid: Bool {
                    return !viewModel.email.isEmpty
                    && viewModel.email.contains("@")
                    && !viewModel.password.isEmpty
                }
            }





//#Preview {
//    LoginView()
//}
