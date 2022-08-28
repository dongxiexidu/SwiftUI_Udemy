//
//  TaskGroupBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/28.
//

import SwiftUI

protocol TaskGroupBootCampProtocol {
    func fetchImage(from urlString: String) async throws -> UIImage
    func fetchImagesWithAsyncLet(from urlString: String) async throws -> [UIImage]
    func fetchImagesWithTaskGroup(from urlString: String) async throws -> [UIImage]
    func fetchImagesWithTaskGroupWithNumber(from urlString: String, number: Int) async throws -> [UIImage]
    func fetchImagesWithTaskGroupWithNumberWithOptional(from urlString: String, number: Int) async throws -> [UIImage]

}

class TaskGroupBootCampDataService: TaskGroupBootCampProtocol {
    func fetchImage(from urlString: String) async throws -> UIImage {
        guard let url = getURL(from: urlString) else { throw URLError(.badURL)}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { throw URLError(.badURL) }
            return image
        } catch {
            throw error
        }
    }
    
    func fetchImagesWithAsyncLet(from urlString: String) async throws -> [UIImage] {
        guard let url = getURL(from: urlString) else { throw URLError(.badURL) }
        
        async let fetchImage1 = fetchImage(from: urlString)
        async let fetchImage2 = fetchImage(from: urlString)
        async let fetchImage3 = fetchImage(from: urlString)
        async let fetchImage4 = fetchImage(from: urlString)
        let (image1, image2, image3, image4) = try await (fetchImage1, fetchImage2, fetchImage3, fetchImage4)
        return [image1, image2, image3, image4]
    }
    
    func fetchImagesWithTaskGroup(from urlString: String) async throws -> [UIImage] {
        guard let url = getURL(from: urlString) else { throw URLError(.badURL) }
        
        return try await withThrowingTaskGroup(of: UIImage.self) { group in
            // group: ThrowingTaskGroup<UIImage, Error>
            var images: [UIImage] = []
            group.addTask {
                try await self.fetchImage(from: urlString)
            }
            group.addTask {
                try await self.fetchImage(from: urlString)
            }
            group.addTask {
                try await self.fetchImage(from: urlString)
            }
            group.addTask {
                try await self.fetchImage(from: urlString)
            }
            for try await image in group {
                // Wait for each of those tasks until their results come back
                images.append(image)
            }
            return images
        }
    }
    
    func fetchImagesWithTaskGroupWithNumber(from urlString: String, number: Int) async throws -> [UIImage] {
        guard let url = getURL(from: urlString) else { throw URLError(.badURL) }
        return try await withThrowingTaskGroup(of: UIImage.self) { group in
            // group: ThrowingTaskGroup<UIImage, Error>
            var images: [UIImage] = []
            for _ in 0..<number {
                group.addTask {
                    try await self.fetchImage(from: urlString)
                }
            }
            for try await image in group {
                // Wait for each of those tasks until their results come back
                images.append(image)
            }
            return images
        }
    }
    
    func fetchImagesWithTaskGroupWithNumberWithOptional(from urlString: String, number: Int) async throws -> [UIImage] {
        guard let url = getURL(from: urlString) else { throw URLError(.badURL) }
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            // group: ThrowingTaskGroup<UIImage, Error>
            var images: [UIImage] = []
            // bacURL Error
            group.addTask {
                try? await self.fetchImage(from: "")
            }
            for _ in 1..<number {
                group.addTask {
                    try? await self.fetchImage(from: urlString)
                }
            }
            for try await image in group {
                // Wait for each of those tasks until their results come back
                // if successfully fetched from network, then works.
                // otherwise, ignore it.
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
    }
    
    
    private func getURL(from urlString: String) -> URL? {
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
}

class TaskGroupBootCampViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let dataService: TaskGroupBootCampProtocol
    let urlString: String
    init(dataService: TaskGroupBootCampProtocol, urlString: String) {
        self.dataService = dataService
        self.urlString = urlString
    }
    func fetchImage() async {
        do {
            let image = try await dataService.fetchImage(from: urlString)
            DispatchQueue.main.async {
                self.images.append(image)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImagesWithAsync() async {
        do {
            let images = try await dataService.fetchImagesWithAsyncLet(from: urlString)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.images.append(contentsOf: images)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImagesWithTaskGroup() async {
        do {
            let images = try await dataService.fetchImagesWithTaskGroup(from: urlString)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.images.append(contentsOf: images)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImagesWithTaskGroupWithNumber(number: Int) async {
        do {
            let images = try await dataService.fetchImagesWithTaskGroupWithNumber(from: urlString, number: number)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.images.append(contentsOf: images)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImagesWithTaskGroupWithNumberWithOptional(number: Int) async {
        do {
            let images = try await dataService.fetchImagesWithTaskGroupWithNumberWithOptional(from: urlString, number: number)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.images.append(contentsOf: images)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskGroupBootCamp: View {
    @StateObject private var viewModel: TaskGroupBootCampViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    init(dataService: TaskGroupBootCampProtocol, urlString: String) {
        _viewModel = StateObject(wrappedValue: TaskGroupBootCampViewModel(dataService: dataService, urlString: urlString))
    }
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id:\.self) {
                        image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                    }
                }
            }
            .navigationTitle("TaskGroupBootCamp")
            .task {
                await viewModel.fetchImagesWithTaskGroupWithNumberWithOptional(number: 10)
            }
        }
    }
}

struct TaskGroupBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupBootCamp(dataService: TaskGroupBootCampDataService(), urlString: "https://picsum.photos/1000")
    }
}
