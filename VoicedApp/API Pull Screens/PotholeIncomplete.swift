//
//  PotholeIncomplete.swift
//  PotHoleReport
//
//  Created by Abraham Morales Arroyo on 4/3/24.
//


import SwiftUI

import Charts

// Define your model here
struct PotholeComplaintIncomplete: Decodable, Identifiable {
    let id = UUID()
    let srNumber: String
    let srType: String
    let status: String
    
    // Use CodingKeys to map JSON keys to struct properties
    private enum CodingKeys: String, CodingKey {
        case srNumber = "sr_number", srType = "sr_type", status
    }
}

// Define a ViewModel to fetch and store data from the API
class PotholeViewModelIncomplete: ObservableObject {
    @Published var complaints: [PotholeComplaint] = []
    
    // I just did a few fields in the Pothole url
    // You will need to modify this code to grab any other stuff you need
    func fetchData() {
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
                        self?.complaints = decodedResponse
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

// I built a simple ContentView to display the fetched data in the Preview and the console
struct PotholeComplaintIncompleted: View { // make sure that this is differnet
    @StateObject var viewModel = PotholeViewModelIncomplete()//this is to be the name of the class
    
    var body: some View {
        
        
        // here is where I am going to be droping a chart
        
        
        
        Chart{
            BarMark(x:.value("type", "Incompleted Pothole Complaints"),
                    y:.value("Completed Issues", viewModel.complaints.count))
            
            BarMark(x:.value("Type", "dogs"),
                    y:.value(" incompleted calls", 2))
            
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
        
        
        List(viewModel.complaints) { complaint in
            VStack(alignment: .leading) {
                Text("SR Number: \(complaint.srNumber)")
                    .font(.headline)
                Text("SR Type: \(complaint.srType)")
                    .font(.subheadline)
                Text("Status: \(complaint.status)")
                    .font(.footnote)
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}


#Preview {
    PotholeComplaintIncompleted()
}
