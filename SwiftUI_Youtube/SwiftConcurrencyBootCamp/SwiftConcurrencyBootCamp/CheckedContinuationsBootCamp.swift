//
//  ContinuationsBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/28.
//

import SwiftUI

protocol CheckedContinuationBootCampProtocol {
    func fetchData(url: URL) async throws -> Data
    func fetchData2(url: URL) async throws -> Data
    func fetchDataFromDatabase() async throws -> UIImage
}

class CheckedContinuationBootCampDataService: CheckedContinuationBootCampProtocol {
    func fetchData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func fetchData2(url: URL) async throws -> Data {
        // Convert API's completion handler to async version
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
                // A closure that takes an UnsafeContinuation parameter. You must resume the continuation exactly once.
            }
            .resume()
        }
    }
    
    private func fetchDataFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        // Mocking Data Fetching from DB
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "flame.fill")!)
        }
    }
    
    func fetchDataFromDatabase() async throws -> UIImage {
        return await withCheckedContinuation { continuation in
            fetchDataFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
}

class CheckedContinuationBootCampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let dataService: CheckedContinuationBootCampProtocol
    let urlString: String
    let url: URL
    
    init(dataService: CheckedContinuationBootCampProtocol, urlString: String) {
        self.dataService = dataService
        self.urlString = urlString
        if let url = URL(string: urlString) {
            self.url = url
        } else {
            self.url = URL(string: "https://picsum.photos/1000")!
        }
    }
    
    func fetchImage() async {
        do {
            let data = try await dataService.fetchData(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            let data = try await dataService.fetchData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImageFromDatabase() async {
        do {
            let image = try await dataService.fetchDataFromDatabase()
            await MainActor.run(body: {
                self.image = image
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CheckedContinuationsBootCamp: View {
    @StateObject private var viewModel: CheckedContinuationBootCampViewModel
    
    init(dataService: CheckedContinuationBootCampProtocol, urlString: String) {
        _viewModel = StateObject(wrappedValue: CheckedContinuationBootCampViewModel(dataService: dataService, urlString: urlString))
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage2()
        }
    }
}

struct CheckedContinuationsBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuationsBootCamp(dataService: CheckedContinuationBootCampDataService(), urlString: "https://picsum.photos/1000")
    }
}
