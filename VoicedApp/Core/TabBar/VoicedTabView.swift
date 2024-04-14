//
//  VoicedTabView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/12/24.
//

import SwiftUI
struct VoicedTabView: View {
    let user: User
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {

            
            ForumView()
                        .tabItem {
                            Image(systemName: selectedTab == 0 ? "quote.bubble.fill" : "quote.bubble")
                                .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        }
                        .onAppear { selectedTab = 0 }
                        .tag(0)
                        .background(Color(red: 0.957, green: 0.925, blue: 0.839))
                        // #9fb1bc
                        .edgesIgnoringSafeArea(.all)
                    
            
            UploadPostView(tabIndex: $selectedTab)
                        .tabItem {
                            Image(systemName: "plus")
                        }
                        .onAppear { selectedTab = 1 }
                        .tag(1)
                        .background(Color(red: 0.957, green: 0.925, blue: 0.839))
                        // #9fb1bc
                        .edgesIgnoringSafeArea(.all)
            
//            PollsView()
//            CreatePollView()
            HighlightsView()
                        .tabItem {
                            Image(systemName: selectedTab == 2 ? "chart.bar" : "chart.bar.fill")
                                .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                        }
                        .onAppear { selectedTab = 2 }
                        .tag(2)
            
            PollsView()
                        .tabItem {
                            Image(systemName: selectedTab == 3 ? "list.bullet.clipboard" : "list.bullet.clipboard.fill")
                                .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                        }
                        .onAppear { selectedTab = 3 }
                        .tag(3)
            

            
            CurrentUserProfileView(user: user)
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person" : "person.fill")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                }
                .onAppear { selectedTab = 4 }
                .tag(4)
            
                    
                
        }
        .tint(Color(red: 127/255, green: 202/255, blue: 166/255))
        .background(Color(red: 0.957, green: 0.925, blue: 0.839))
        // #9fb1bc
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    VoicedTabView(user: User.MOCK_USERS[0])
}
