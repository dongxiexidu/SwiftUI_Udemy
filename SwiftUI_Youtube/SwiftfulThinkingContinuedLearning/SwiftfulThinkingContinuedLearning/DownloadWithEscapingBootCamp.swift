//
//  DownloadWithEscapingBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class DownloadWithEscapingViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        guard let url = getUrl() else { return }
        // BACKGROUND THREAD DOWNLOAD
        
        downloadData(from: url) { data in
            if let data = data {
                guard let posts = try? JSONDecoder().decode([PostModel].self, from: data) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.posts = posts
                }
            } else {
                print("NO DATA RETURNED")
            }
        }
    }
    
    // GENERIC DATA DOWNLOAD HANDLER
    private func downloadData(from url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                print("ERROR DOWNLOADING DATA")
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }.resume()
    }
    
    private func getUrl() -> URL? {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return nil }
        return url
    }
}

struct DownloadWithEscapingBootCamp: View {
    @StateObject private var viewModel = DownloadWithEscapingViewModel()
    var body: some View {
        List {
            ForEach(viewModel.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .foregroundColor(.gray)
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct DownloadWithEscapingBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithEscapingBootCamp()
    }
}
