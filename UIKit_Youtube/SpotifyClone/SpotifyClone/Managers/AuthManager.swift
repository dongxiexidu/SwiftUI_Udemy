//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private var refreshingToken = false
    struct Constants {
        static let clientID = "b3fb76e48578462bb703e0c31a82c615"
        static let clientSecret = "2af1d72913794796b0591a5828120063"
        static let tokenAPIURLString = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://velog.io/@j_aion"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    // Singleton Pattern
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let added = "?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        let urlString = base + added
        return URL(string:urlString)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expriationDate = tokenExpirationDate else { return false }
        let currentDate = Date()
        let fiveMin: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMin) >= expriationDate
    }
    
    public func exchangeCodeForToken(code: String, completionHandler: @escaping (Bool) -> ()) {
        // GET TOKEN
        guard let url = URL(string: Constants.tokenAPIURLString) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completionHandler(false)
            return
        }
        urlRequest.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = components.query?.data(using: .utf8)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                completionHandler(false)
                return
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    print("SUCCESSFULLY REFRESH")
                    self.cacheToken(result: result)
                    completionHandler(true)
                } catch {
                    print(error.localizedDescription)
                    completionHandler(false)
                }
            }
        }
        .resume()
    }
    
    private var onRefreshBlocks = [(String)->()]()
    
    /// Supplies valid token to be used with APICalls
    public func withValidToken(completionHandler: @escaping (String) -> ()) {
        guard !refreshingToken else {
            // Append the completion
            onRefreshBlocks.append(completionHandler)
            return
        }
        if shouldRefreshToken {
            // Refresh
            refreshIfNeeded { [weak self] success in
                guard let self = self else { return }
                if let token = self.accessToken, success {
                    completionHandler(token)
                }
            }
        } else if let token = accessToken {
            completionHandler(token)
        }
    }
    
    public func refreshIfNeeded(completionHandler: @escaping (Bool) -> ()) {
        guard !refreshingToken else { return }
        guard shouldRefreshToken else {
            completionHandler(true)
            return
        }
        guard let refreshToken = refreshToken else { return }
        // Refresh the token
        guard let url = URL(string: Constants.tokenAPIURLString) else { return }
        refreshingToken = true
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completionHandler(false)
            return
        }
        urlRequest.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = components.query?.data(using: .utf8)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            self.refreshingToken = false
            if let error = error {
                print(error.localizedDescription)
                completionHandler(false)
                return
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    self.onRefreshBlocks.forEach {$0(result.access_token)}
                    self.onRefreshBlocks.removeAll()
                    self.cacheToken(result: result)
                    completionHandler(true)
                } catch {
                    print(error.localizedDescription)
                    completionHandler(false)
                }
            }
        }
        .resume()

    }
    
    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
