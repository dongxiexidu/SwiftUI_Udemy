//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationData: Data? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
