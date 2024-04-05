//
//  ContentView.swift
//  VoicedApp
//
//  Created by Abraham Morales Arroyo on 3/8/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
                    .environmentObject(registrationViewModel)
            }
            else if let currentUser = viewModel.currentUser {
                VoicedTabView(user: currentUser)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
