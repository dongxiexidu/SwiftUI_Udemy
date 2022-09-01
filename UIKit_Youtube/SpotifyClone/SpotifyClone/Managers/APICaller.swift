//
//  APICaller.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    public func getCurrentUserProfile(completionHandler: @escaping (Result<UserProfile, Error>)->()) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"),
                      type: .GET) { baseRequest in
            URLSession.shared.dataTask(with: baseRequest) { [weak self] data, response, error in
                guard let self = self, let data = data, error == nil else {
                    completionHandler(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completionHandler(.success(result))
                    print(result)
                } catch {
                    completionHandler(.failure(error))
                }
            }
            .resume()
        }
    }
    
    // MARK: Private
    
    enum APIError: Error {
        case failedToGetData
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    
    private func createRequest(with url: URL?, type: HTTPMethod, completionHandler: @escaping (URLRequest) -> ()) {
        guard let apiURL = url else { return }
        AuthManager.shared.withValidToken { token in
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completionHandler(request)
        }
    }
    
}
