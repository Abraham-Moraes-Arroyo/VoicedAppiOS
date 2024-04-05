//
//  SettingsOptions.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/5/24.
//

import Foundation
import SwiftUI

enum SettingsOptions: Int, CaseIterable, Identifiable {
//    case notifications
    case privacy
//    case account
//    case report
    case about
    
    var title: String {
        switch self {
//        case .notifications: return "Notifications"
        case .privacy: return "Privacy"
//        case .account: return "Account"
//        case .report: return "Report"
        case .about: return "About"
        }
    }
    
    var imageName: String {
        switch self {
//        case .notifications: return "bell"
        case .privacy: return "lock"
//        case .account: return "person.circle"
//        case .report: return "flag.circle"
        case .about: return "info.circle"
        }
    }
    
    var destinationView: some View {
           switch self {
//           case .notifications: return Text("Notifications View")
           case .privacy: return AnyView(PrivacyView())
//           case .account: return Text("Account View")
//           case .report: return AnyView(ReportPopupContentView())
           case .about: return AnyView(AboutView())
           }
       }
    
    var id: Int { return self.rawValue }
}
