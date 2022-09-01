//
//  AuthViewController.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKUIDelegate {
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1), configuration: configuration)
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAuthViewUI()
        setWebView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func setAuthViewUI() {
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
    }
    
    private func setWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        guard let url = AuthManager.shared.signInURL else { return }
        webView.load(URLRequest(url: url))
    }
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return }
        // Exchange the code for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        webView.isHidden = true
        print("Code: \(code)")
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                self.completionHandler?(success)
            }
        }
    }
}
