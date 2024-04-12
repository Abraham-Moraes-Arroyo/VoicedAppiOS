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
    
    // Below is for the ALLEY potholes
    @Published var alleyOpenComplaintPot: [PotholeComplaint] = []
    @Published var alleyClosedComplaintPot: [PotholeComplaint] = []
    
//    closedComplaintPot
    
//    get complaints
    func getComplaints() {
        getOpenComplaintsCall()
        getCompletedPotholeState()
        
        getOpenComplaintsCallPot()
        getClosedComplaintsCallPot()
        
//      getClosedComplaintsCallPotAlley
        getOpenComplaintsCallPotAlley()
        getClosedComplaintsCallPotAlley()
    }
    
    // This is for CLOSSED ALLEY and STREET POTHOLES
    func getClosedComplaintsCallPotAlley() {
        let urlString = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?$query=SELECT%0A%20%20%60sr_number%60%2C%0A%20%20%60sr_type%60%2C%0A%20%20%60sr_short_code%60%2C%0A%20%20%60created_department%60%2C%0A%20%20%60owner_department%60%2C%0A%20%20%60status%60%2C%0A%20%20%60origin%60%2C%0A%20%20%60created_date%60%2C%0A%20%20%60last_modified_date%60%2C%0A%20%20%60closed_date%60%2C%0A%20%20%60street_address%60%2C%0A%20%20%60city%60%2C%0A%20%20%60state%60%2C%0A%20%20%60zip_code%60%2C%0A%20%20%60street_number%60%2C%0A%20%20%60street_direction%60%2C%0A%20%20%60street_name%60%2C%0A%20%20%60street_type%60%2C%0A%20%20%60duplicate%60%2C%0A%20%20%60legacy_record%60%2C%0A%20%20%60legacy_sr_number%60%2C%0A%20%20%60parent_sr_number%60%2C%0A%20%20%60community_area%60%2C%0A%20%20%60ward%60%2C%0A%20%20%60electrical_district%60%2C%0A%20%20%60electricity_grid%60%2C%0A%20%20%60police_sector%60%2C%0A%20%20%60police_district%60%2C%0A%20%20%60police_beat%60%2C%0A%20%20%60precinct%60%2C%0A%20%20%60sanitation_division_days%60%2C%0A%20%20%60created_hour%60%2C%0A%20%20%60created_day_of_week%60%2C%0A%20%20%60created_month%60%2C%0A%20%20%60x_coordinate%60%2C%0A%20%20%60y_coordinate%60%2C%0A%20%20%60latitude%60%2C%0A%20%20%60longitude%60%2C%0A%20%20%60location%60%2C%0A%20%20%60%3A%40computed_region_rpca_8um6%60%2C%0A%20%20%60%3A%40computed_region_vrxf_vc4k%60%2C%0A%20%20%60%3A%40computed_region_6mkv_f3dw%60%2C%0A%20%20%60%3A%40computed_region_bdys_3d7i%60%2C%0A%20%20%60%3A%40computed_region_43wa_7qmu%60%2C%0A%20%20%60%3A%40computed_region_du4m_ji7t%60%0AWHERE%0A%20%20(%60created_date%60%0A%20%20%20%20%20BETWEEN%20%222024-03-01T11%3A27%3A29%22%20%3A%3A%20floating_timestamp%0A%20%20%20%20%20AND%20%222024-04-12T11%3A27%3A21%22%20%3A%3A%20floating_timestamp)%0A%20%20AND%20((%60community_area%60%20IN%20(%2261%22))%0A%20%20%20%20%20%20%20%20%20AND%20(caseless_one_of(%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%60sr_type%60%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22Alley%20Pothole%20Complaint%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22Pothole%20in%20Street%20Complaint%22%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20)%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20AND%20caseless_one_of(%60status%60%2C%20%22Completed%22)))%0AORDER%20BY%20%60sr_number%60%20DESC%20NULL%20FIRST "
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([PotholeComplaint].self, from: data)
                    DispatchQueue.main.async {
                        self?.alleyClosedComplaintPot = decodedResponse
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
    
    
    
    //This is for both Street and ALLEY
    func getOpenComplaintsCallPotAlley() {
        let urlString = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?$query=SELECT%0A%20%20%60sr_number%60%2C%0A%20%20%60sr_type%60%2C%0A%20%20%60sr_short_code%60%2C%0A%20%20%60created_department%60%2C%0A%20%20%60owner_department%60%2C%0A%20%20%60status%60%2C%0A%20%20%60origin%60%2C%0A%20%20%60created_date%60%2C%0A%20%20%60last_modified_date%60%2C%0A%20%20%60closed_date%60%2C%0A%20%20%60street_address%60%2C%0A%20%20%60city%60%2C%0A%20%20%60state%60%2C%0A%20%20%60zip_code%60%2C%0A%20%20%60street_number%60%2C%0A%20%20%60street_direction%60%2C%0A%20%20%60street_name%60%2C%0A%20%20%60street_type%60%2C%0A%20%20%60duplicate%60%2C%0A%20%20%60legacy_record%60%2C%0A%20%20%60legacy_sr_number%60%2C%0A%20%20%60parent_sr_number%60%2C%0A%20%20%60community_area%60%2C%0A%20%20%60ward%60%2C%0A%20%20%60electrical_district%60%2C%0A%20%20%60electricity_grid%60%2C%0A%20%20%60police_sector%60%2C%0A%20%20%60police_district%60%2C%0A%20%20%60police_beat%60%2C%0A%20%20%60precinct%60%2C%0A%20%20%60sanitation_division_days%60%2C%0A%20%20%60created_hour%60%2C%0A%20%20%60created_day_of_week%60%2C%0A%20%20%60created_month%60%2C%0A%20%20%60x_coordinate%60%2C%0A%20%20%60y_coordinate%60%2C%0A%20%20%60latitude%60%2C%0A%20%20%60longitude%60%2C%0A%20%20%60location%60%2C%0A%20%20%60%3A%40computed_region_rpca_8um6%60%2C%0A%20%20%60%3A%40computed_region_vrxf_vc4k%60%2C%0A%20%20%60%3A%40computed_region_6mkv_f3dw%60%2C%0A%20%20%60%3A%40computed_region_bdys_3d7i%60%2C%0A%20%20%60%3A%40computed_region_43wa_7qmu%60%2C%0A%20%20%60%3A%40computed_region_du4m_ji7t%60%0AWHERE%0A%20%20(%60created_date%60%0A%20%20%20%20%20BETWEEN%20%222024-03-01T11%3A27%3A29%22%20%3A%3A%20floating_timestamp%0A%20%20%20%20%20AND%20%222024-04-12T11%3A27%3A21%22%20%3A%3A%20floating_timestamp)%0A%20%20AND%20((%60community_area%60%20IN%20(%2261%22))%0A%20%20%20%20%20%20%20%20%20AND%20(caseless_one_of(%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%60sr_type%60%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22Alley%20Pothole%20Complaint%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22Pothole%20in%20Street%20Complaint%22%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20)%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20AND%20caseless_one_of(%60status%60%2C%20%22Open%22)))%0AORDER%20BY%20%60sr_number%60%20DESC%20NULL%20FIRST"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([PotholeComplaint].self, from: data)
                    DispatchQueue.main.async {
                        self?.alleyOpenComplaintPot = decodedResponse
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

// Below is for street LIGHTS ONLY
    // first function OPEN STREEET LIGHT
    func getOpenComplaintsCall() {
        let urlString = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?$query=SELECT%0A%20%20%60sr_number%60%2C%0A%20%20%60sr_type%60%2C%0A%20%20%60sr_short_code%60%2C%0A%20%20%60created_department%60%2C%0A%20%20%60owner_department%60%2C%0A%20%20%60status%60%2C%0A%20%20%60origin%60%2C%0A%20%20%60created_date%60%2C%0A%20%20%60last_modified_date%60%2C%0A%20%20%60closed_date%60%2C%0A%20%20%60street_address%60%2C%0A%20%20%60city%60%2C%0A%20%20%60state%60%2C%0A%20%20%60zip_code%60%2C%0A%20%20%60street_number%60%2C%0A%20%20%60street_direction%60%2C%0A%20%20%60street_name%60%2C%0A%20%20%60street_type%60%2C%0A%20%20%60duplicate%60%2C%0A%20%20%60legacy_record%60%2C%0A%20%20%60legacy_sr_number%60%2C%0A%20%20%60parent_sr_number%60%2C%0A%20%20%60community_area%60%2C%0A%20%20%60ward%60%2C%0A%20%20%60electrical_district%60%2C%0A%20%20%60electricity_grid%60%2C%0A%20%20%60police_sector%60%2C%0A%20%20%60police_district%60%2C%0A%20%20%60police_beat%60%2C%0A%20%20%60precinct%60%2C%0A%20%20%60sanitation_division_days%60%2C%0A%20%20%60created_hour%60%2C%0A%20%20%60created_day_of_week%60%2C%0A%20%20%60created_month%60%2C%0A%20%20%60x_coordinate%60%2C%0A%20%20%60y_coordinate%60%2C%0A%20%20%60latitude%60%2C%0A%20%20%60longitude%60%2C%0A%20%20%60location%60%2C%0A%20%20%60%3A%40computed_region_rpca_8um6%60%2C%0A%20%20%60%3A%40computed_region_vrxf_vc4k%60%2C%0A%20%20%60%3A%40computed_region_6mkv_f3dw%60%2C%0A%20%20%60%3A%40computed_region_bdys_3d7i%60%2C%0A%20%20%60%3A%40computed_region_43wa_7qmu%60%2C%0A%20%20%60%3A%40computed_region_du4m_ji7t%60%0AWHERE%0A%20%20(%60created_date%60%0A%20%20%20%20%20BETWEEN%20%222024-03-01T11%3A27%3A29%22%20%3A%3A%20floating_timestamp%0A%20%20%20%20%20AND%20%222024-04-12T11%3A27%3A21%22%20%3A%3A%20floating_timestamp)%0A%20%20AND%20((%60community_area%60%20IN%20(%2261%22))%0A%20%20%20%20%20%20%20%20%20AND%20(caseless_one_of(%60sr_type%60%2C%20%22Street%20Light%20Out%20Complaint%22)%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20AND%20caseless_one_of(%60status%60%2C%20%22Open%22)))%0AORDER%20BY%20%60sr_number%60%20DESC%20NULL%20FIRST"
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
    
    
    //Clossed state function for Street
    func getCompletedPotholeState() {
        let urlString = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?$query=SELECT%0A%20%20%60sr_number%60%2C%0A%20%20%60sr_type%60%2C%0A%20%20%60sr_short_code%60%2C%0A%20%20%60created_department%60%2C%0A%20%20%60owner_department%60%2C%0A%20%20%60status%60%2C%0A%20%20%60origin%60%2C%0A%20%20%60created_date%60%2C%0A%20%20%60last_modified_date%60%2C%0A%20%20%60closed_date%60%2C%0A%20%20%60street_address%60%2C%0A%20%20%60city%60%2C%0A%20%20%60state%60%2C%0A%20%20%60zip_code%60%2C%0A%20%20%60street_number%60%2C%0A%20%20%60street_direction%60%2C%0A%20%20%60street_name%60%2C%0A%20%20%60street_type%60%2C%0A%20%20%60duplicate%60%2C%0A%20%20%60legacy_record%60%2C%0A%20%20%60legacy_sr_number%60%2C%0A%20%20%60parent_sr_number%60%2C%0A%20%20%60community_area%60%2C%0A%20%20%60ward%60%2C%0A%20%20%60electrical_district%60%2C%0A%20%20%60electricity_grid%60%2C%0A%20%20%60police_sector%60%2C%0A%20%20%60police_district%60%2C%0A%20%20%60police_beat%60%2C%0A%20%20%60precinct%60%2C%0A%20%20%60sanitation_division_days%60%2C%0A%20%20%60created_hour%60%2C%0A%20%20%60created_day_of_week%60%2C%0A%20%20%60created_month%60%2C%0A%20%20%60x_coordinate%60%2C%0A%20%20%60y_coordinate%60%2C%0A%20%20%60latitude%60%2C%0A%20%20%60longitude%60%2C%0A%20%20%60location%60%2C%0A%20%20%60%3A%40computed_region_rpca_8um6%60%2C%0A%20%20%60%3A%40computed_region_vrxf_vc4k%60%2C%0A%20%20%60%3A%40computed_region_6mkv_f3dw%60%2C%0A%20%20%60%3A%40computed_region_bdys_3d7i%60%2C%0A%20%20%60%3A%40computed_region_43wa_7qmu%60%2C%0A%20%20%60%3A%40computed_region_du4m_ji7t%60%0AWHERE%0A%20%20(%60created_date%60%0A%20%20%20%20%20BETWEEN%20%222024-03-01T11%3A27%3A29%22%20%3A%3A%20floating_timestamp%0A%20%20%20%20%20AND%20%222024-04-12T11%3A27%3A21%22%20%3A%3A%20floating_timestamp)%0A%20%20AND%20((%60community_area%60%20IN%20(%2261%22))%0A%20%20%20%20%20%20%20%20%20AND%20(caseless_one_of(%60sr_type%60%2C%20%22Street%20Light%20Out%20Complaint%22)%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20AND%20caseless_one_of(%60status%60%2C%20%22Completed%22)))%0AORDER%20BY%20%60sr_number%60%20DESC%20NULL%20FIRST"
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





// I built a simple ContentView to display the fetched data in the Preview and the console
struct HighlightsView: View { // make sure that this is differnet
    @StateObject var viewModel = SanitationStatusCompleteShown()//this is to be the name of the class
    

    var body: some View {
            
        ScrollView {
            // here is where I am going to be droping a chart
            VStack {
                VStack{
                    Text("Monthly Dashboard")
                        .font(.title )
                        
                    Spacer()
                    Spacer()
                    Text("Top 311 Reports")
                }
                .offset(y: 70.0)
                Chart{
//                    These are for Street lights
                    BarMark(x:.value("type", "Open Light Reports calls"),
                            y:.value("Open Issues", viewModel.openComplaints.count))
                    
                    BarMark(x:.value("type", "Closed Light Reports calls"),
                            y:.value("Completed Issues", viewModel.completedComplaints.count))
                     
                 
                    
                    BarMark(x:.value("type", "Closed Pothole calls"),
                            y:.value("Closed Issues",  viewModel.alleyClosedComplaintPot.count))
                    
//                    This is for ALL street and alley potholes
                    BarMark(x:.value("type", "Open Pothole calls"),
                            y:.value("Open Issues", viewModel.alleyOpenComplaintPot.count))
                
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(60)
                VStack{

                VStack{
                    RoundedRectangle(cornerRadius: 4.0)
                        .fill(Color(red: 185/255, green: 224/255, blue: 202/255))
                        .frame(width: 300, height: 100)
                }
                VStack{
                    RoundedRectangle(cornerRadius: 4.0)
                        .fill(Color(red: 98/255, green: 204/255, blue: 162/255))
                        .frame(width: 300, height: 100)
                }
//                     @Published var alleyOpenComplaintPot: [PotholeComplaint] = []
//                    @Published var alleyClosedComplaintPot: [PotholeComplaint] = []

                    VStack{
                        Text("Pothole Reports completed")
             
                        var averagePot = (viewModel.alleyOpenComplaintPot.count + viewModel.alleyClosedComplaintPot.count) % 100
                        
//                        var comb = averageSan / denom
                        Text("\(averagePot) %")
                        Text("Includes: Potholes in New City ")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        // what if for the math percentage I get the to do it inside of the text on line 360
                    }
                    .offset(y:-200)
                    
                    VStack{
                        Text("Street Light Reports completed")
                        var averageSanO = (viewModel.openComplaints.count + viewModel.completedComplaints.count) % 100
                        Text("\(averageSanO) %")
                        Text("Includes: Street light Outages ")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        
                        
                    }
                    .offset(y:-155)
                }
                .offset(y:-50)
                
            }// end of Vstack
           
            
            
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
