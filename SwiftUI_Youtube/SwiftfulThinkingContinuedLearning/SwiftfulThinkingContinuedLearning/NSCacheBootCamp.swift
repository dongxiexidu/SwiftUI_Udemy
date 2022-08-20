//
//  NSCacheBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

class CacheManager {
    static let instance = CacheManager()
    private init() {}
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 3
        cache.totalCostLimit = 1024 * 1024 // 1MB
        return cache
    }()
    
    func add(image: UIImage, name: String) -> String {
        imageCache.setObject(image, forKey: name as NSString)
        return "ADDED TO CACHE"
    }
    
    func get(name: String) -> UIImage? {
        guard let image = imageCache.object(forKey: name as NSString) else {
            print("NO IMAGE AT ALL")
            return nil
        }
        return image
    }
    
    func remove(name: String) -> String {
        imageCache.removeObject(forKey: name as NSString)
        return "REMOVE FROM CACHE"
    }
    
}

class CacheViewModel: ObservableObject {
    @Published var startingImage: UIImage? = nil
    @Published var cachedImage: UIImage? = nil
    @Published var infoMessage = ""
    let manager = CacheManager.instance
    var imageName = "Polar_Bear1"
    
    
    init() {
        getImageFromAssetsFolder()
    }
    
    func getImageFromAssetsFolder() {
        startingImage = UIImage(named: imageName)
    }
    
    func changeImage() {
        if imageName == "Polar_Bear1" {
            imageName = "Polar_Bear2"
            getImageFromAssetsFolder()
        } else {
            imageName = "Polar_Bear1"
            getImageFromAssetsFolder()
        }
    }
    
    func saveToCache() {
        guard let image = startingImage else { return }
        infoMessage = manager.add(image: image, name: imageName)
    }
    
    func removeFromCache() {
        infoMessage = manager.remove(name: imageName)
    }
    
    func getFromCache() {
        if let cachedImaged = manager.get(name: imageName) {
            self.cachedImage = cachedImaged
            infoMessage = "CACHE IMAGE"
        } else {
            self.cachedImage = nil
            infoMessage = "NO CACHE IMAGE"
        }
    }
}

struct NSCacheBootCamp: View {
    @StateObject private var viewModel = CacheViewModel()
    var body: some View {
        NavigationView {
            VStack {
                Text("CURRENT IMAGENAME: \(viewModel.imageName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                Text(viewModel.infoMessage)
                    .font(.headline)
                    .fontWeight(.bold)
                
                if let image = viewModel.startingImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                
                HStack {
                    Button(action: {
                        viewModel.saveToCache()
                    }, label: {
                        Text("SAVE TO CACHE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(10)
                    })
                    Button(action: {
                        viewModel.removeFromCache()
                    }, label: {
                        Text("DELETE FROM CACHE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.red)
                            .cornerRadius(10)
                    })
                }
                
                if let image = viewModel.cachedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                
                HStack {
                    Button(action: {
                        viewModel.changeImage()
                    }, label: {
                        Text("CHANGE IMAGE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.orange)
                            .cornerRadius(10)
                    })
                    
                    Button(action: {
                        viewModel.getFromCache()
                    }, label: {
                        Text("GET FROM CACHE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.green)
                            .cornerRadius(10)
                    })
                }
                Spacer()
            }
            .navigationTitle("CACHE BOOTCAMP")
        }
    }
}

struct NSCacheBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        NSCacheBootCamp()
    }
}
