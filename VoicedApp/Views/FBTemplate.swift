//
//  FBTemplate.swift
//  VoicedApp
//
//  Created by Abraham Morales Arroyo on 3/18/24.
//


// we did create and read data from FIREBASE
import SwiftUI
import FirebaseFirestore

struct FBTemplate: View {
    @State var textToReceive: String = ""
    @State var textToAdd: String = ""

// state variable is an ever adapting variable
    var body: some View {
        VStack{ // grabs text and dumps it to database
            TextField("", text: $textToAdd)
                .background(.red)
            Button(){
                addTextToFirebase(text: textToAdd)
            }label: {
                Text("Add text to firebase")
                
                    
            }
            
            Text(textToReceive)
            
            Button(){
                Task{
                    await getTextFromFirebase()
                    // dpmt do anythign till data is back
                    print("data retrieved")
                }
            }label: {
                Text("Get text from firebase")
            }
        
        }
    }
    func addTextToFirebase(text:String) {
        let fs = Firestore.firestore()
        // the structure fo teh firebase structure. to add more make it a dictionary to the dictionary. 
        var funText: [String: Any] = ["userEnteredText": text]
        
        
        fs.collection("DemoFirebase").addDocument(data: funText)//ads to text and then takes item adn pastes it with an random id.
        
        
    }
    
    func getTextFromFirebase() async{
        let fs = Firestore.firestore()
        var receivedText: [String: Any] = [:]
        do {
            var dataPoint = fs.collection("DemoFirebase")
            var dataSnapShot = try await dataPoint.getDocuments()
            
            let randomText = dataSnapShot.documents.randomElement()
            // gets the data from the query snapshot, because quary snapshot already takes the data
            let randomTextData: [String: Any] = randomText!.data() ?? [:]
                //if ther eis nothing thee it will replace it with an empty dictionary, we can populate the preload if we want to.
            
            textToReceive = randomTextData["userEnteredText"] as! String
            // we are getting whatever we got form the collected text and transformting it to string.
            
            
        } catch {
            print("Error in retrieving firebase text", error.localizedDescription)
        }
    }
}

#Preview {
    FBTemplate()
}
