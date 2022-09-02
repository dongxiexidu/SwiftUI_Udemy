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
    
    public func getNewReleases(completionHandler: @escaping ((Result<NewReleasesResponse, Error>)->())) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(error))
                }
            }
            .resume()
        }
    }
    
    public func getFeaturedPlaylists(completionHandler: @escaping((Result<FeaturedPlaylistsResponse, Error>)-> ())) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=2"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(error))
                }
            }
            .resume()
        }
    }
    
    public func getRecommendedGenres(completionHandler: @escaping ((Result<RecommendedGenresResponse, Error>) -> ())) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(error))
                }
            }
            .resume()
        }
    }
    
    public func getRecommendations(genres: Set<String>, completionHandler: @escaping((Result<String, Error>)-> ())) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?seed_genres=\(seeds)"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("FETCH RECOMMENDATIONS")
                    print(result)
                    completionHandler(.success("Success"))
                } catch {
                    print(error.localizedDescription)
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
