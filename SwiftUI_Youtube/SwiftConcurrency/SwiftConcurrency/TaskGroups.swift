//
//  TaskGroups.swift
//  SwiftConcurrency
//
//  Created by Junyeong Park on 2022/08/16.
//

import SwiftUI

class TaskGroupsDataManager {
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        let urlString = "https://picsum.photos/200"
        async let fetchImage1 = fetchImage(urlString: urlString)
        async let fetchImage2 = fetchImage(urlString: urlString)
        async let fetchImage3 = fetchImage(urlString: urlString)
        async let fetchImage4 = fetchImage(urlString: urlString)
        async let fetchImage5 = fetchImage(urlString: urlString)
        
        let (image1, image2, image3, image4, image5) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4, try fetchImage5)
        return [image1, image2, image3, image4, image5]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        var urlStrings = Array(repeating: "https://picsum.photos/200", count: 10)
//        urlStrings[5] = "sss"
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images = [UIImage]()
            images.reserveCapacity(urlStrings.count)
            for urlString in urlStrings {
                group.addTask {
                    try? await self.fetchImage(urlString: urlString)
                }
            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        do {
            guard let url = URL(string: urlString) else { throw URLError(.badURL) }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            guard let image = UIImage(data: data) else { throw URLError(.badURL) }
            return image
            
        } catch {
            throw error
        }
    }
}

class TaskGroupsViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupsDataManager()
    
    func getImages() async {
//        if let images = try? await manager.fetchImagesWithAsyncLet() {
//            self.images.append(contentsOf: images)
//        }
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
        
    }
    
}

struct TaskGroups: View {
    @StateObject private var viewModel = TaskGroupsViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200")!
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id:\.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
            }
            .navigationTitle("Task Group!")
            .task {
                await viewModel.getImages()
            }
        }
    }
}

struct TaskGroups_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroups()
    }
}
