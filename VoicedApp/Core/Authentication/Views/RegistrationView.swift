//
//  RegistrationView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import SwiftUI

struct RegistrationView: View {
    
    @StateObject var viewModel = RegistrationViewModel()
    
    @State private var hasAgreedToPrivacyPolicy = false // Track privacy policy agreement
        
        @Environment(\.openURL) var openURL // Environment value to open URL
    
    var body: some View {
        ScrollView {
            Text("Create an account")
                .font(.title)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(spacing: 3) {
                    Text("Welcome to Voiced")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Image("voiced-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                      
                }
                
                Text("Create an account to access data on 311 reports, community posts, community polls, and more. Exclusively for the New City Community.")
                    .font(.caption)
                
                // Existing fields
                TextField("Enter your username...", text: $viewModel.username)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Enter your email...", text: $viewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Enter your password...", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // New optional fields
                TextField("Enter your zipcode...", text: Binding<String>(
                    get: { viewModel.zipCode ?? "" },
                    set: { viewModel.zipCode = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())


                // Age picker
                Picker("Age Category (Optional)", selection: $viewModel.selectedAge) {
                    // not sure why it appears red?
                    Text("Select your age group").tag(AgeCategory?.none)
                        .foregroundColor(.black)
                
                        
                    ForEach(AgeCategory.allCases, id: \.self) { age in
                        Text(age.rawValue).tag(age as AgeCategory?)
                    }
                }.pickerStyle(MenuPickerStyle())
                    .foregroundColor(.black)
                
                Text("What is your main reason for using Voiced?")
                    .fontWeight(.semibold)
                
                TextField("Enter your reason here...", text: Binding<String>(
                    get: { viewModel.reasonForUsing ?? "" },
                    set: { viewModel.reasonForUsing = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())

                
                // Community issues
                Text("What community issue(s) do you care about the most?")
                    .fontWeight(.semibold)
                ForEach(CommunityIssue.allCases, id: \.self) { issue in
                    Button(action: {
                        viewModel.toggleCommunityIssue(issue)
                    }) {
                        HStack {
                            Text(issue.rawValue)
                            if viewModel.isCommunityIssueSelected(issue) {
                                Image(systemName: "checkmark.square.fill") // Checked
                                                       } else {
                                                           Image(systemName: "square") // Unchecked
                                                       }
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                // Discovery method
                Text("How Did You Find Out About Voiced?")
                    .fontWeight(.semibold)
                ForEach(DiscoveryMethod.allCases, id: \.self) { method in
                    Button(action: {
                        viewModel.toggleDiscoveryMethod(method)
                    }) {
                        HStack {
                            Text(method.rawValue)
                            if viewModel.isDiscoveryMethodSelected(method) {
                                Image(systemName: "checkmark.square.fill") // Checked
                                                       } else {
                                                           Image(systemName: "square") // Unchecked
                                                       }
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }

                // Privacy Policy Agreement Section
                           HStack {
                               Button(action: {
                                   self.hasAgreedToPrivacyPolicy.toggle() // Toggle the agreement state
                               }) {
                                   HStack {
                                       Image(systemName: hasAgreedToPrivacyPolicy ? "checkmark.square.fill" : "square") // Checkbox
                                       Text("I agree to the ")
                                           .font(.body) + Text("Privacy Policy")
                                           .font(.body)
                                           .underline()
                                           .foregroundColor(.blue)
                                   }
                               }
                               .buttonStyle(PlainButtonStyle())
                               .foregroundColor(.primary)
                               
                               Spacer()
                               
                               // Privacy Policy Link
                               Button("Read here") {
                                   if let url = URL(string: "https://www.eccchicago.org/eula.html") {
                                       openURL(url) // Attempt to open the privacy policy URL
                                   }
                               }
                               .foregroundColor(.blue)
                               .font(.body)
                           }
                           .padding(.top)
                           
                           // Sign Up button
                           Button(action: {
                               Task {
                                   try await viewModel.createUser()
                               }
                           }) {
                               Text("Sign Up")
                                   .foregroundColor(.white)
                                   .fontWeight(.semibold)
                                   .frame(maxWidth: .infinity)
                                   .padding()
                                   .background(Color.blue)
                                   .cornerRadius(10)
                           }
                           .disabled(!formIsValid || !hasAgreedToPrivacyPolicy) // Disabled if form is invalid or privacy policy is not agreed to
                .opacity(formIsValid && hasAgreedToPrivacyPolicy ? 1 : 0.7)
                
                
                NavigationLink {
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                        // to do: change it to the hex color on figma
                    }
                    .foregroundColor(.black)
                    .font(.footnote)
                }
                .padding(.vertical, 16)
                
                .alert(isPresented: $viewModel.showAlert) {
                            Alert(title: Text("Error"),
                                  message: Text(viewModel.authError?.description ?? ""))
                        }
                
                
            }
            .padding()
        }
        .foregroundColor(.black)
        .navigationBarTitle("Sign Up", displayMode: .inline)
    }


var formIsValid: Bool {
       return !viewModel.email.isEmpty
           && viewModel.email.contains("@")
           && !viewModel.password.isEmpty
           && viewModel.password.count > 5
   }
}
//#Preview {
//    RegistrationView()
//}
