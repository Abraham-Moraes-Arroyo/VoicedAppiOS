//
//  datafromapi.swift
//  VoicedApp
//
//  Created by Abraham Morales Arroyo on 4/2/24.
//

// based on tutorial https://www.youtube.com/watch?v=sqo844saoC4
//import UIKit
//class datafromapi: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//            // Do any additional setup after video
//        let url = "https://data.cityofchicago.org/resource/v6vf-nfxy.json?sr_type=Sanitation%20Code%20Violation&&community_area=61&&status=Completed"
//        getData(from: url)
//    }
//    private func getData(from url: String){
//       let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
//            guard let data = data, error == nil else {
//                print("something went wrong ")
//                return
//            }
//            // have data
//            // convert the data here.
//            var result: Response?
//            do{
//                result = try JSONDecoder().decode(Response.self, from: data)
//            } catch {
//                print("failed to convert \(error.localizedDescription)")
//            }
//            guard let json = result else {
//                return
//            }
//            // we print out some of the values
//            print(json.results.SR_TYPE)
//            print(json.results.Community_Area)
//            print(json.results.status)
//        })
//        task.resume()
//    }
//}
//// based on what I did for File.swift
//
//
//struct Response: Codable {
//    let results: MyResult
//    let status: String
//}
//struct MyResult: Codable {
//    let SR_TYPE: String
//    let Community_Area: String
//    let status: String
//}
//
