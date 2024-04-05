//
//  SnapshotScreen.swift
//  VoicedApp
//
//  Created by Abraham Morales Arroyo on 3/31/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct SnapshotScreen: View {
    @State var retrievedImages = [UIImage]()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Divider()
        VStack{
            ForEach(retrievedImages, id: \.self){ image in
                //loops through images and displays them
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear{
            retrievePhotos()
        }
        
    }
    
    func retrievePhotos() {
        // get photos from firebase
        let db = Firestore.firestore()
        // not sure if I need to switch "images" to snapshot
        db.collection("images").getDocuments { snapshot , error in
            if error == nil && snapshot  != nil {
                
                // make an array to keep track of all the file paths
                var paths = [String]()
                // loop through all the returned docs
                for doc in snapshot!.documents {
                    // extract the file path and add to array
                    
                    paths.append(doc["url"] as! String)
                    
                }
                // Loop through each file path and fetch the data from storage
                for path in paths {
                    // get a reference to the storage
                    let storageRef = Storage.storage().reference()
                    // sepciy the path

                    let fileRef = storageRef.child(path)
                    // retrieve data
                    
                    fileRef.getData(maxSize: 5 * 1024 * 1024 ) { data, error in
                        // check if there are errors
                        if error  == nil && data != nil {
                            // creatr a UIimage and put it into our array
                            if  let image = UIImage(data: data!){
                            
                                DispatchQueue.main.async {
                                    retrievedImages.append(image )
                                }
                            }
                        }
                        
                    }
                } //end loop through paths
            }
        
        }
    }
}

#Preview {
    SnapshotScreen()
}
