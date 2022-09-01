//
//  AuthResponse.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
