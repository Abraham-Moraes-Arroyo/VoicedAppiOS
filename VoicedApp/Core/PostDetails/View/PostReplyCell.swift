//
//  PostReplyCell.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/4/24.
//

import SwiftUI

struct PostReplyCell: View {
    let reply: PostReply
    @State private var showReportPopup = false
    
    @State var postReplyHeight: CGFloat = 24
    
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
                    Text(user.username)
                        .fontWeight(.semibold)
                        .font(.footnote)
                    
                    Spacer() // This ensures everything is pushed to the left
                    
                    Text(reply.timestamp.timestampString())
                        .font(.caption)
                        .foregroundColor(Color(.systemGray3))
                    Button(action: {
                        showReportPopup = true // Present the report popup
                    }) {
                        Label("", systemImage: "flag")
                            .padding()
                            
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    .sheet(isPresented: $showReportPopup) {
                        ReportPopupView(isPresented: $showReportPopup)
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
//            .padding(.top, 1)
//            .padding(.bottom, 1)
            

            
            Divider()
        }
    }
}



#Preview {
    PostReplyCell(reply: PostReply.MOCK_REPLIES[0])
}
