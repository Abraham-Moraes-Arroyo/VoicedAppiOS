//
//  CreatePollView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CreatePollView: View {
    @State private var question: String = ""
    @State private var optionTexts: [String] = ["", "", "", "", ""]
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            TextField("Poll Question", text: $question)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            ForEach(0..<optionTexts.count, id: \.self) { index in
                TextField("Option \(index + 1)", text: $optionTexts[index])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }

            Button("Create Poll") {
                createPoll()
            }
            .padding()
            .alert(isPresented: $showingSuccessAlert) {
                Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear(perform: checkIfUserIsAdmin)
    }

    private func checkIfUserIsAdmin() {
        // Assume a mechanism to verify if a user is an admin; update YOUR_ADMIN_USER_ID accordingly
        guard let uid = Auth.auth().currentUser?.uid, uid == "XwGhJfbVnROkKbh2acsZK0B728r2" else {
            // Handle non-admin user, e.g., by hiding UI or showing an error
            return
        }
        // Proceed as the user is admin
    }

    private func createPoll() {
        guard !question.isEmpty, !optionTexts.contains(where: {$0.isEmpty}) else {
            self.alertMessage = "Please fill out all fields."
            self.showingErrorAlert = true
            return
        }

        let options = optionTexts.filter { !$0.isEmpty }.map { Poll.PollOption(id: UUID().uuidString, text: $0, voteCount: 0) }
        let newPoll = Poll(id: UUID().uuidString, question: question, options: options, createdAt: Timestamp(), expiresAt: Timestamp(date: Date().addingTimeInterval(86400 * 7)))

        Task {
            do {
                try await PollService.createPoll(newPoll)
                self.alertMessage = "Poll created successfully."
                self.showingSuccessAlert = true
            } catch {
                self.alertMessage = "Failed to create poll: \(error.localizedDescription)"
                self.showingErrorAlert = true
            }
        }
    }
}

#Preview {
    CreatePollView()
}
