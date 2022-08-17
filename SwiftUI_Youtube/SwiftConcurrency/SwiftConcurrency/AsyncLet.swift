//
//  AsyncLet.swift
//  SwiftConcurrency
//
//  Created by Junyeong Park on 2022/08/16.
//

import SwiftUI

struct AsyncLet: View {
    @State private var images = [UIImage]()
    @State private var title = "Async Let!"
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200")!
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id:\.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
            }
            .navigationTitle(title)
            .onAppear {
//                Task {
//                    do {
//                        let image1 = try await fetchImage()
//                        self.images.append(image1)
//                        let image2 = try await fetchImage()
//                        self.images.append(image2)
//                        let image3 = try await fetchImage()
//                        self.images.append(image3)
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//                Task {
//                    do {
//                        let image1 = try await fetchImage()
//                        self.images.append(image1)
//                        let image2 = try await fetchImage()
//                        self.images.append(image2)
//                        let image3 = try await fetchImage()
//                        self.images.append(image3)
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//                Task {
//                    do {
//                        let image1 = try await fetchImage()
//                        self.images.append(image1)
//                        let image2 = try await fetchImage()
//                        self.images.append(image2)
//                        let image3 = try await fetchImage()
//                        self.images.append(image3)
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
                Task {
                    do {
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        async let fetchTitle = fetchTitle()
                        
                        let (image, title) = await (try fetchImage1, fetchTitle)
                        self.images.append(image)
                        self.title = title
//                        let (image1, image2, image3, image4) = try await (fetchImage1, fetchImage2, fetchImage3, fetchImage4)
//                        try await self.images.append(fetchImage1)
//                        try await self.images.append(fetchImage2)
//                        try await self.images.append(fetchImage3)
//                        try await self.images.append(fetchImage4)
//                        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
//                        self.images.append(contentsOf: [image1, image2, image3, image4])
                        
                        
                    }
                }
            }
        }
    }
    
    func fetchTitle() async -> String {
        return "New Title"
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

struct AsyncLet_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLet()
    }
}
