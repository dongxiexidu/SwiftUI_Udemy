//
//  CheckedContinuation.swift
//  SwiftConcurrency
//
//  Created by Junyeong Park on 2022/08/16.
//

import SwiftUI

class CheckedContinuationNetworkManager {
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch {
            throw URLError(.badURL)
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return await withCheckedContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error as! Never)
                } else {
                }
            }
            .resume()
        }
    }
    
    func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            completionHandler(UIImage(systemName: "heart.fill")!)
        })
    }
    
    func getHearImageFromDatabase() async -> UIImage {
        return await withCheckedContinuation { continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
}

class CheckedContinuationViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        do {
            let data = try await networkManager.getData2(url: url)
            
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch {
            print(error)
        }
    }
    
    func getHeartImage() {
        networkManager.getHeartImageFromDatabase { [weak self] image in
            self?.image = image
        }
    }
    
    func getHeartImage2() async {
        self.image = await networkManager.getHearImageFromDatabase()
    }
}

struct CheckedContinuation: View {
    @StateObject private var viewModel = CheckedContinuationViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .center)
            }
        }
        .task {
            await viewModel.getImage()
            await viewModel.getHeartImage2()
        }
    }
}

struct CheckedContinuation_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuation()
    }
}
