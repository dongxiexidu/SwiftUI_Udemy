//
//  DownloadImageAsync.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/26.
//

import SwiftUI
import Combine

class DownloadImageAsyncBootCampDataService {
    let urlString: String
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func getURL() -> URL? {
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        guard let url = getURL() else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                completionHandler(nil, error)
                return
            }
            completionHandler(image, nil)
        }
        .resume()
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func downloadWithEscaping2(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        guard let url = getURL() else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            let image = self.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        guard let url = getURL() else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError{$0}
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        // 1. weak self -> no need
        // 2. safer code (completionHandler usage X)
        guard let url = getURL() else { throw URLError(.badURL) }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}

class DownloadImageAsyncBootCampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let dataService = DownloadImageAsyncBootCampDataService(urlString: "https://picsum.photos/200")
    var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchImageWithAsyncTask()
    }
    
    func fetchImageWithEscapingClosure() {
        dataService.downloadWithEscaping2 { image, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.image = image
                }
            }
        }
    }
    
    func fetchImageWithCombine() {
        dataService.downloadWithCombine()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchImageWithCombine2() {
        dataService.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] image in
                guard let self = self else { return }
                self.image = image
            }
            .store(in: &cancellables)
    }
    
    func fetchImageWithAsyncTask() {
        Task {
            await fetchImageWithAsync()
        }
    }
    
    func fetchImageWithAsync() async {
        do {
            guard let image = try await dataService.downloadWithAsync() else {
                return
            }
            await MainActor.run {
                self.image = image
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct DownloadImageAsyncBootCamp: View {
    @StateObject private var viewModel = DownloadImageAsyncBootCampViewModel()
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250, alignment: .center)
                    .onTapGesture {
                        viewModel.fetchImageWithAsyncTask()
                    }
            }
        }
    }
}

struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsyncBootCamp()
    }
}
