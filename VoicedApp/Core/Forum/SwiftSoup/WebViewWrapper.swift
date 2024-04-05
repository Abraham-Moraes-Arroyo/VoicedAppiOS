//
//  WebViewWrapper.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/30/24.
//

import SwiftUI
import WebKit

struct WebViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController

    func makeUIViewController(context: Context) -> ViewController {
        // Return an instance of ViewController
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
// controller can be updated here
    }
}


#Preview {
    WebViewWrapper()
}
