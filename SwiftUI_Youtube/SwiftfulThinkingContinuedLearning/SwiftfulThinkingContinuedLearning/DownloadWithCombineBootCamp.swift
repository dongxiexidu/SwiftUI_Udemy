//
//  DownloadWithCombineBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

// 1. Create the publisher
// 2. Subsribe publisher on background thread (as default subcribe backgroun thread)
// 3. Receive on main thread
// 4. tryMap in order to check the data is good or not
// 5. Decode data into Models
// 6. Sink (put the item into our app)
// 7. Store (cancel subscription if needed)

import SwiftUI
import Combine

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class DownloadWithCombineViewModel: ObservableObject {
    @Published var posts = [PostModel]()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        guard let url = getUrl() else { return }

        let publisher = URLSession.shared.dataTaskPublisher(for: url)
        let subscriber = publisher.subscribe(on: DispatchQueue.global(qos: .background))
        let receiver = subscriber.receive(on: DispatchQueue.main)
        
        receiver
            .tryMap(handleOutput)
            .decode(type: [PostModel].self, decoder: JSONDecoder())
//            .replaceError(with: []): Replace Error with default value
            .sink { (completion) in
                switch completion {
                case .finished:
                    print("SUCCESS")
                case .failure(let error):
                    print("FAILURE")
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (returnedPosts) in
                self?.posts = returnedPosts
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
    
    
    
    private func getUrl() -> URL? {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return nil }
        return url
    }
}


struct DownloadWithCombineBootCamp: View {
    @StateObject private var viewModel = DownloadWithCombineViewModel()
    var body: some View {
        List {
            ForEach(viewModel.posts) { post in
                VStack(alignment: .leading, spacing: 20) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct DownloadWithCombineBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithCombineBootCamp()
    }
}
