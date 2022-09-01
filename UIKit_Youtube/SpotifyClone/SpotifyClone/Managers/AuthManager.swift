//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "b3fb76e48578462bb703e0c31a82c615"
        static let clientSecret = "2af1d72913794796b0591a5828120063"
    }
    
    private init() {}
    // Singleton Pattern
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://velog.io/@j_aion"
        let base = "https://accounts.spotify.com/authorize"
        let added = "?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        let urlString = base + added
        return URL(string:urlString)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshedToken: String? {
        return nil
    }
    
    private var tokenExpirationData: Data? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    public func exchangeCodeForToken(code: String, completionHandler: @escaping (Bool) -> ()) {
        // GET TOKEN
        
    }
    
    public func refreshToken() {
        
    }
    
    public func cacheToken() {
        
    }
}
