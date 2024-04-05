//
//  HighlightsView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//
//
//import SwiftUI
//
//struct HighlightsView: View {
//    // This array will hold posts that aren't user-generated
//    var nonUserGeneratedPosts: [Post] {
//        Post.MOCK_POSTS.filter { !$0.isUserGenerated }
//    }
//
//    var body: some View {
//        NavigationStack {
//            ScrollView(showsIndicators: false) {
//                LazyVStack(spacing: 20) {
//                    ForEach(nonUserGeneratedPosts, id: \.id) { post in
//                        ForumCell(post: post)
//                            .padding(.horizontal)
//                    }
//                }
//            }
//            .navigationTitle("Dashboard")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//#Preview {
//    HighlightsView()
//}


import SwiftUI
import Charts


//// Sanitation Completed
//struct CompletedSanitation: Decodable, Identifiable {
//    let id = UUID()
//    let srNumber: String
//    let srType: String
//    let status: String
//
//    // Use CodingKeys to map JSON keys to struct properties
//    private enum CodingKeys: String, CodingKey {
//        case srNumber = "sr_number", srType = "sr_type", status
//    }
//}

// Sanitation Incomplete
struct IncompleteSanitation: Decodable, Identifiable {
    let id = UUID()
    let srNumber: String
    let srType: String
    let status: String
    
    // Use CodingKeys to map JSON keys to struct properties
    private enum CodingKeys: String, CodingKey {
        case srNumber = "sr_number", srType = "sr_type", status
    }
}


class SanitationStatusCompleteShown: ObservableObject {
    // two var to acces open and closed states of the pothole statius
    @Published var openComplaints: [PotholeComplaint] = []
    @Published var completedComplaints: [PotholeComplaint] = []
    //Repeaat the same but for the pothole.

    @Published var openComplaintPot: [PotholeComplaint] = []
    @Published var closedComplaintPot: [PotholeComplaint] = []
    
    
//    get complaints
    func getComplaints() {
        getOpenComplaintsCall()
        getCompletedPotholeState()
        
        getOpenComplaintsCallPot()
        getClosedComplaintsCallPot()
    }
    
    //first pothole complaint OPEN
    func getOpenComplaintsCallPot() {
        let urlString = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Pothole%20in%20Street%20Complaint&&community_area=61&&status=Open"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([PotholeComplaint].self, from: data)
                    DispatchQueue.main.async {
                        self?.openComplaintPot = decodedResponse
                    }
                    // Print each complaint's details to the console for debugging.
                    for complaint in decodedResponse {
                        print("SR Number: \(complaint.srNumber), SR Type: \(complaint.srType), Status: \(complaint.status)")
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Decoding failed: \(error.localizedDescription)")
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Fetch failed: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // Second Function Closed
    func getClosedComplaintsCallPot() {
        let urlString = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Pothole%20in%20Street%20Complaint&&community_area=61&&status=Closed"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([PotholeComplaint].self, from: data)
                    DispatchQueue.main.async {
                        self?.closedComplaintPot = decodedResponse
                    }
                    // Print each complaint's details to the console for debugging.
                    for complaint in decodedResponse {
                        print("SR Number: \(complaint.srNumber), SR Type: \(complaint.srType), Status: \(complaint.status)")
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Decoding failed: \(error.localizedDescription)")
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Fetch failed: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // first function
    func getOpenComplaintsCall() {
        let urlString = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Sanitation%20Code%20Violation&&community_area=61&&status=Open"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([PotholeComplaint].self, from: data)
                    DispatchQueue.main.async {
                        self?.openComplaints = decodedResponse
                    }
                    // Print each complaint's details to the console for debugging.
                    for complaint in decodedResponse {
                        print("SR Number: \(complaint.srNumber), SR Type: \(complaint.srType), Status: \(complaint.status)")
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Decoding failed: \(error.localizedDescription)")
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Fetch failed: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    //Clossed state function
    func getCompletedPotholeState() {
        let urlString = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Sanitation%20Code%20Violation&&community_area=61&&status=Completed"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([PotholeComplaint].self, from: data)
                    DispatchQueue.main.async {
                        self?.completedComplaints = decodedResponse
                    }
                    // Print each complaint's details to the console for debugging.
                    for complaint in decodedResponse {
                        print("SR Number: \(complaint.srNumber), SR Type: \(complaint.srType), Status: \(complaint.status)")
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Decoding failed: \(error.localizedDescription)")
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Fetch failed: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
}


// I am going to try to have both of the classes here for open and closed sanitation calles
// WE ARE GOING TO BEGIN WITH THE COMPLETED CALLS
// Define a ViewModel to fetch and store data from the API
//class FinishedSanitation: ObservableObject {
//    @Published var complaints2: [PotholeComplaint] = []
//
//    // I just did a few fields in the Pothole url
//    // You will need to modify this code to grab any other stuff you need
//    func fetchData() {
//        let urlString = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Sanitation%20Code%20Violation&&community_area=61&&status=Completed"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            if let data = data {
//                do {
//                    let decodedResponse = try JSONDecoder().decode([PotholeComplaint].self, from: data)
//                    DispatchQueue.main.async {
//                        self?.complaints2 = decodedResponse
//                    }
//                    // Print each complaint's details to the console for debugging.
//                    for complaint in decodedResponse {
//                        print("SR Number: \(complaint.srNumber), SR Type: \(complaint.srType), Status: \(complaint.status)")
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        print("Decoding failed: \(error.localizedDescription)")
//                    }
//                }
//            } else if let error = error {
//                DispatchQueue.main.async {
//                    print("Fetch failed: \(error.localizedDescription)")
//                }
//            }
//        }.resume()
//    }
//}// End of completed Calls
//

// OPEN SANITATION CALLS
// Define a ViewModel to fetch and store data from the API
//class OpenSantinationCalls: ObservableObject {
//    @Published var complaints: [PotholeComplaint] = []
//
//    // I just did a few fields in the Pothole url
//    // You will need to modify this code to grab any other stuff you need
//    func fetchData() {
//        let urlString = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Sanitation%20Code%20Violation&&community_area=61&&status=Open"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            if let data = data {
//                do {
//                    let decodedResponse = try JSONDecoder().decode([PotholeComplaint].self, from: data)
//                    DispatchQueue.main.async {
//                        self?.complaints = decodedResponse
//                    }
//                    // Print each complaint's details to the console for debugging.
//                    for complaint in decodedResponse {
//                        print("SR Number: \(complaint.srNumber), SR Type: \(complaint.srType), Status: \(complaint.status)")
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        print("Decoding failed: \(error.localizedDescription)")
//                    }
//                }
//            } else if let error = error {
//                DispatchQueue.main.async {
//                    print("Fetch failed: \(error.localizedDescription)")
//                }
//            }
//        }.resume()
//    }
//}
//
//
//



// I built a simple ContentView to display the fetched data in the Preview and the console
struct HighlightsView: View { // make sure that this is differnet
    @StateObject var viewModel = SanitationStatusCompleteShown()//this is to be the name of the class
    

    var body: some View {
            
        ScrollView {
            
            // here is where I am going to be droping a chart
            
            
            VStack {
                Chart{
                    BarMark(x:.value("type", "Open Sanitation calls"),
                            y:.value("Open Issues", viewModel.openComplaints.count))
                    
                    BarMark(x:.value("type", "Closed Sanitation calls"),
                            y:.value("Completed Issues", viewModel.completedComplaints.count))
                    
                    
                    BarMark(x:.value("type", "Closed Pothole calls"),
                            y:.value("Closed Issues", viewModel.closedComplaintPot.count))
                    
                    BarMark(x:.value("type", "Open Pothole calls"),
                            y:.value("Open Issues", viewModel.openComplaintPot.count))
                
                  
                    
//                    BarMark(x:.value("Type", "Completed Pothole Number"),
//                            y:.value(" incompleted calls", Beans.complaints.count))
                    
//                    BarMark(x:.value("Type", "Completed Pothole Number"),
//                            y:.value(" incompleted calls", Beans.complaints.count))
                }
                .aspectRatio(1, contentMode: .fit)
                .padding()
                
                
                
            }
            VStack {
//                List(viewModel.openComplaints) { complaint in
//                    VStack(alignment: .leading) {
//                        Text("SR Number: \(complaint.srNumber)")
//                            .font(.headline)
//                        Text("SR Type: \(complaint.srType)")
//                            .font(.subheadline)
//                        Text("Status: \(complaint.status)")
//                            .font(.footnote)
//                    }
//                }
//                .onAppear {
//                    viewModel.fetchData()
//                }
            }
        }
        .onAppear{
            viewModel.getComplaints()
        }
    }
}


#Preview {
    HighlightsView()
}
