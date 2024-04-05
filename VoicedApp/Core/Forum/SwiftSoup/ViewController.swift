//
//  ViewController.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 3/30/24.
//

import WebKit
import UIKit

final class ViewController: UIViewController {
    
    private let webView: WKWebView = {
        let prefs = WKPreferences()
        prefs.javaScriptEnabled = true
        let pageprefs = WKWebpagePreferences()
        pageprefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = pageprefs
        let webview = WKWebView(frame: .zero, configuration: config)
        
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        guard let url = URL(string: "https://blockclubchicago.org/category/back-of-the-yards/") else { return }
        webView.load(URLRequest(url: url))
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
