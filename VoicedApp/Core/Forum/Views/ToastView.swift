//
//  ToastView.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import SwiftUI

struct ToastView: View {
    let message: String

        var body: some View {
            Text(message)
                .padding()
                .background(Color.black)
                .foregroundColor(Color.white)
                .cornerRadius(8)
        }
}

#Preview {
    ToastView(message: "")
}
