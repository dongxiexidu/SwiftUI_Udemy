//
//  DependencyInjectionBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/22.
//

import SwiftUI
import Combine

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class ProductionDataServiceSingleton {
    static let instance = ProductionDataServiceSingleton()
    
    private init() {}
    
    let urlString = "https://jsonplaceholder.typicode.com/posts"

    func getData() -> AnyPublisher<[PostModel], Error>? {
        guard let url = getUrl() else { return nil }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func getUrl() -> URL? {
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
}

protocol DataServiceProtocol {
    func getData() -> AnyPublisher<[PostModel], Error>?
}

class ProductionDataService: DataServiceProtocol {
    let urlString: String
    
    init(urlString: String = "https://jsonplaceholder.typicode.com/posts") {
        self.urlString = urlString
    }

    func getData() -> AnyPublisher<[PostModel], Error>? {
        guard let url = getUrl() else { return nil }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func getUrl() -> URL? {
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
}

class MockDataService: DataServiceProtocol {
    let testData: [PostModel]
    
    init(data: [PostModel]?) {
        self.testData = data ??
        [PostModel(userId: 1, id: 1, title: "title1", body: "body1"), PostModel(userId: 2, id: 2, title: "title2", body: "body2")]
    }

    func getData() -> AnyPublisher<[PostModel], Error>? {
        Just(testData)
            .tryMap{$0}
            .eraseToAnyPublisher()
    }
}

class Dependencies {
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
}

class DependencyInjectionViewModel: ObservableObject {
    @Published var dataArray = [PostModel]()
    var cancellables = Set<AnyCancellable>()
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadPost()
    }
    
    private func loadPost() {
        guard let data = dataService.getData() else { return }
        data
            .sink { completion in
                switch completion {
                case .finished: print("SUCCESS")
                case .failure(let error): print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnedPosts in
                guard let self = self else { return }
                self.dataArray = returnedPosts
            }
            .store(in: &cancellables)
    }
}

struct DependencyInjectionBootCamp: View {
    @StateObject private var viewModel: DependencyInjectionViewModel
    
    init(dataService: DataServiceProtocol) {
        _viewModel = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray) { data in
                    Text(data.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .padding()
        }
    }
}

struct DependencyInjectionBootCamp_Previews: PreviewProvider {
    static let dataService = MockDataService(data: nil)
    static var previews: some View {
        DependencyInjectionBootCamp(dataService: dataService)
    }
}
