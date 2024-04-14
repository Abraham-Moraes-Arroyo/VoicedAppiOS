//
//  PostReplyCell.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/4/24.
//

import SwiftUI
import FirebaseAuth

struct PostReplyCell: View {
    let reply: PostReply
    @State private var showReportPopup = false
    
    
    @State var postReplyHeight: CGFloat = 24
    @State private var showingBlockSheet = false
    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    private var user: User? {
        return reply.replyUser
    }
    
    func setCommentViewHeight() {
        let imageDimension: CGFloat = ProfileImageSize.small.dimension
        let padding: CGFloat = 16
        let width = UIScreen.main.bounds.width - imageDimension - padding
        let font = UIFont.systemFont(ofSize: 12)
        let replyText = reply.replyText.heightWithConstrainedWidth(width, font: font)
        
        print("debug: caption size is \(replyText)")
        
        postReplyHeight = replyText + imageDimension - 16
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                
                Rectangle()
                    .frame(width: 2, height: postReplyHeight)
                    .foregroundColor(Color(.systemGray4))
                
                if let user = user {
                    CircularProfileImageView(user: user, size: .xSmall)
                    Text(user.username .prefix(8))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    
                    Spacer() // This ensures everything is pushed to the left
                    
                    Text(reply.timestamp.timestampString())
                        .font(.caption)
                        .foregroundColor(Color(.systemGray3))
                    
                    HStack(spacing: 1) {
                        if Auth.auth().currentUser?.uid != reply.replyUser?.id  {
                            Button(action: {
                                showReportPopup = true // Present the report popup
                            }) {
                                Image(systemName: "flag")
                                    .padding()
                            }
                            .sheet(isPresented: $showReportPopup) {
                                ReportPopupView(isPresented: $showReportPopup)
                            }
                            
                            Button(action: {
                                showingBlockSheet = true // Show action sheet for blocking
                            }) {
                                Image(systemName: "nosign")
                                    .padding()
                            }
                            .actionSheet(isPresented: $showingBlockSheet) {
                                ActionSheet(title: Text("Block user"), message: Text("Would you like to block this user? Note: You won't see their content next time you log in"), buttons: [
                                    .destructive(Text("Block"), action: {
                                        // Implement block functionality
                                        Task {
                                            do {
                                                try await blockUser(userToBlockId: user.id)
                                                toastMessage = "User successfully blocked."
                                                showToast = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                    showToast = false // Hide the toast after 3 seconds
                                                }
                                            } catch {
                                                toastMessage = "Failed to block user: \(error.localizedDescription)"
                                                showToast = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                    showToast = false
                                                }
                                            }
                                        }
                                    }),
                                    .cancel()
                                ])
                            }
                        }
                       
                    }
                }
            }
            .onAppear { setCommentViewHeight() }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text(reply.replyText)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
            }
            
            Divider()
        }
    }
}



func blockUser(userToBlockId: String) async throws {
    guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    
    // Call UserService to block the user
    do {
        await fetchBlockedUsers()
        try await UserService.blockUser(currentUserId: currentUserId, userToBlockId: userToBlockId)
                
            } catch {
                print("Error blocking user: \(error)")
                
            }
}

func fetchBlockedUsers() async {
       guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    var blockedUsers = [String]()
       do {
           blockedUsers = try await UserService.fetchBlockedUsers(forUserId: currentUserId)
       } catch {
           print("Error fetching blocked users: \(error)")
       }
   }

#Preview {
    PostReplyCell(reply: PostReply.MOCK_REPLIES[0])
}
