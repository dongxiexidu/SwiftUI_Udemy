//
//  AsyncLetBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/28.
//

import SwiftUI

struct AsyncLetBootCamp: View {
    @State private var images: [UIImage] = []
    @State private var navTitle = "AsyncLetBootCamp"
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                    }
                }
            }
            .navigationTitle(navTitle)
            .onAppear {
                fetchImageAsyncLet2()
            }
        }
    }
    
    private func getURL() -> URL? {
        guard let url = URL(string: "https://picsum.photos/1000") else { return nil}
        return url
    }
    
    private func fetchImage() async throws -> UIImage {
        guard let url = getURL() else { throw URLError(.badURL) }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw URLError(.badURL)
            }
            return image
        } catch {
            throw error
        }
    }
    
    private func fetchImageSingleTask() {
        Task {
            let image = try await fetchImage()
            self.images.append(image)
            let image2 = try await fetchImage()
            self.images.append(image2)
            let image3 = try await fetchImage()
            self.images.append(image3)
            let image4 = try await fetchImage()
            self.images.append(image4)
        }
    }
    
    private func fetchImageMultipleTasks() {
        Task {
            let image = try await fetchImage()
            self.images.append(image)
        }
        Task {
            let image = try await fetchImage()
            self.images.append(image)
        }
        Task {
            let image = try await fetchImage()
            self.images.append(image)
        }
        Task {
            let image = try await fetchImage()
            self.images.append(image)
        }
    }
    
    private func fetchImageAsyncLet() {
        // Load fetched Data at the same time
        Task {
            do {
                async let fetchImage1 = fetchImage()
                async let fetchImage2 = fetchImage()
                async let fetchImage3 = fetchImage()
                async let fetchImage4 = fetchImage()
                
                let (image1, image2, image3, image4) = try await (fetchImage1, fetchImage2, fetchImage3, fetchImage4)
                let images = [image1, image2, image3, image4]
                self.images.append(contentsOf: images)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchTitle() async -> String {
        return "Fetched Title"
    }
    
    private func fetchImageAsyncLet2() {
        Task {
            do {
                async let fetchImage1 = fetchImage()
                async let fetchTitle = fetchTitle()
                let (image, title) = await (try fetchImage1, fetchTitle)
                self.images.append(image)
                self.navTitle = title
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct AsyncLetBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetBootCamp()
    }
}
