//
//  PhotoModelDataService.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import Foundation
import Combine

class PhotoModelDataService {
    static let instance = PhotoModelDataService()
    private let urlString = "https://jsonplaceholder.typicode.com/photos"
    @Published var photoModels: [PhotoModel] = []
    var cancellables = Set<AnyCancellable>()
    private init() {
        downloadData()
    }
    
    private func downloadData() {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type:[PhotoModel].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    print("SUCCESS")
                case .failure(let error):
                    print("FAIL")
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] photoModels in
                guard let self = self else { return }
                self.photoModels = photoModels
            }
            .store(in: &cancellables)
    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}
