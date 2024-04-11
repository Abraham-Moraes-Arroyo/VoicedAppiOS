//
//  CreatePollView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/9/24.
//

import SwiftUI
import FirebaseFirestore

struct CreatePollView: View {
    @State private var question: String = ""
    @State private var optionTexts: [String] = ["", "", "", "", ""] // Initialize with five empty strings for options
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
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
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .alert(isPresented: $showingSuccessAlert) {
                    Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .alert(isPresented: $showingErrorAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Create Poll")
            .padding()
        }
    }

    private func createPoll() {
        guard !question.isEmpty, !optionTexts.contains(where: {$0.isEmpty}) else {
            self.alertMessage = "Please fill out all fields."
            self.showingErrorAlert = true
            return
        }

        // Filter out any empty option texts
        let options = optionTexts.filter { !$0.isEmpty }
        let newPoll = Poll(id: UUID().uuidString, question: question, options: options, createdAt: Timestamp(date: Date()), expiresAt: Timestamp(date: Date().addingTimeInterval(86400 * 7)))

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
