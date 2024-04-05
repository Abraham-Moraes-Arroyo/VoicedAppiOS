//
//  VoicedAppApp.swift
//  VoicedApp
//
//  Created by Abraham Morales Arroyo on 3/8/24.
//

import SwiftUI

@main
struct VoicedAppApp: App {
    
//    @StateObject private var vm = LocationsViewModel()
    

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            LocationsView()
//                .environmentObject(vm)
            
            
//              FBTemplate()
            
            // root view
            ContentView()
        }
    }
}
