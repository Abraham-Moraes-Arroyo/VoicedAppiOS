//
//  ReportPopupView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/5/24.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase
struct ReportPopupView: View {
    @Binding var isPresented: Bool
    @State private var reason: String = ""
    var body: some View {
        VStack {
            Text("Please Describe the Issue in Detail")
                .font(.headline)
                .foregroundColor(.red)
                .padding()
            
            TextField("Description", text: $reason)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .fixedSize(horizontal: false, vertical: true)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            Button("Submit") {
                addReportToFirebase(reason: self.reason)
                
                
                self.isPresented = false
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 352, height: 44)
            .cornerRadius(8)
            .disabled(reason.isEmpty)
            .opacity(!reason.isEmpty ? 1 : 0.7)

            Spacer()
        }
        .padding()
        .cornerRadius(10)
    }
    
    
    func addReportToFirebase(reason:String){
        
        print("Description submitted: \(reason)")
        
        let db = Firestore.firestore()
        
        let reportData = [
            "reason": reason,
            "date": Timestamp(date: Date()),
            "userID": Auth.auth().currentUser?.uid.description ?? "",
        ] as [String : Any]
        
        print(reportData)
      
        db.collection("reports").addDocument(data: reportData)
        
    }
}

