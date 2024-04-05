////
////  Alltogether.swift
////  VoicedApp
////
////  Created by Abraham Morales Arroyo on 4/4/24.
////
//
//import SwiftUI
//import Charts
//
//struct CallsReceived: Decodable, Identifiable {
//    let id = UUID()
//    let srNumber: String
//    let srType: String
//    let status: String
//    
//    // use Coding keys to map json keys to struct properties
//    private enum CodingKeys: String, CodingKey {
//        case srNumber = "sr_number", srType = "sr_type", status
//    }
//}
//
//
//// We are going to do one class only in order to display the data
//
//class AllCalls: ObservableObject {
//    @Published var complaint1: [FirstComplaint] = []
//    @Published var complaint2: [SecondComplaint] = []
//    @Published var complaint3: [ThirdComplaint] = []
//    @Published var complaint4: [FourthComplaint] = []
//    
//    
//    // we did a few fields in the pothole url
//    // Modify it so it takes all the other urls that I had in Mind
//    
//    func fetchDataAll(){
//        let urlString1 = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Pothole%20in%20Street%20Complaint&&community_area=61&&status=Open" // incompleted pothole
//        
//        let urlString2 = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Pothole%20in%20Street%20Complaint&&community_area=61&&status=Completed" // completed pothole
//        
//        let urlStirng3 = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Sanitation%20Code%20Violation&&community_area=61&&status=Open" // incompleted sanitation
//        
//        let urlString4 = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Sanitation%20Code%20Violation&&community_area=61&&status=Completed" // completed sanitation
//        
//        
//        
//        // now we are going to do the function that takes all these links and then stores the respecftully information into their own seperated array
//        
//        // for urlString1
//       
//        guard let url1 = URL(string: urlString1) else {
//            print("Invalid URL")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url1) { [weak self] data1, response1, error1 in
//            
//            if let data1 = data1 {
//                do{
//                    let decodedResponse1 = try
//                    JSONDecoder().decode([FirstComplaint].self, from: data1)
//                    DispatchQueue.main.async {
//                        self?.$complaint1 = decodedResponse1
//                    }
//                    // print each complaint details to the console for debugging
//                    for complaint in decodedResponse1 {
//                        print("SR Number: \(complaint.srNumber), SR Type: \(complaint.srType), Status: \(complaint.status)")
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        print("Decoding failed: \(error.localizedDescription)")
//                    }
//                }
//                
//            } else if let error1 = error1 {
//                DispatchQueue.main.async {
//                    print("Fetch failed: \(error.localizedDescription)")
//                }
//            }
//            
//        }
//        
//    }
//    
//    
//} // end of Completed Call
//
//struct Alltogether: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    Alltogether()
//}
