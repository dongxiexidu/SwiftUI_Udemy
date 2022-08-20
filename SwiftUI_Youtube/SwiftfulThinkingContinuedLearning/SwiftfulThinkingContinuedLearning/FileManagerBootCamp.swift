//
//  FileManagerBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    private let cachePathName: String = "MyApp_Images"
    private init() {
        createFolderIfNeeded()
    }
    
    func createFolderIfNeeded() {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(cachePathName)
                .path else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("SUCCESS CREATING FOLDER")
            } catch {
                print("ERROR CREATING DIRECTORY")
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteFolder() -> String {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(cachePathName)
                .path else {
            return "ERROR GETTING PATH"
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return "SUCCESS DELETING FOLDER"
        } catch {
            print(error.localizedDescription)
            return "ERROR DELETING FOLDER"
        }
    }
    
    func saveImage(image: UIImage, name: String) -> String {
        guard let data = image.pngData(), let path = getPathForImage(name: name) else {
            return "ERROR GETTING PATH"
        }
           
        do {
            try data.write(to: path)
            return "SUCCESS SAVING"
        } catch {
            print(error.localizedDescription)
            return "ERROR SAVING IMAGE"

        }
    }
    
    func loadImage(name: String) -> UIImage? {
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("ERROR GETTTING PATH")
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
    
    func deleteImage(name: String) -> String {
        guard
            let path = getPathForImage(name: name),
            FileManager.default.fileExists(atPath: path.path) else {
            return "ERROR GETTING PATH"
        }
        
        do {
            try FileManager.default.removeItem(at: path)
        } catch {
            print(error.localizedDescription)
            return "ERROR DELETING IMAGE"
        }
        return "SUCCESS DELETING IMAGE"
    }
    
    func getPathForImage(name: String) -> URL? {
        guard
            let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(cachePathName)
                .appendingPathComponent("\(name).png")
        else {
            return nil
        }
        return path
    }
}

class FileManagerViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var infoMessage = ""
    var infoMessageColor = Color.black
    var imageName = ""
    let manager = LocalFileManager.instance
    
    init() {
    }
    
    func getImageFromFileManager() {
        if let image = manager.loadImage(name: imageName) {
            infoMessage = "SUCCESS LOADING FM"
            infoMessageColor = .green
            self.image = image
        } else {
            infoMessage = "ERROR GETTING FM"
            infoMessageColor = .pink
        }
    }
    
    func getImageFromAssetFolder() {
        if let image = UIImage(named: imageName) {
            infoMessage = "SUCCESS LOADING ASSET"
            infoMessageColor = .green
            self.image = image
        } else {
            infoMessage = "ERROR GETTING ASSET"
            infoMessageColor = .pink
        }
    }
    
    func saveImage() {
        guard let image = image else { return }
        infoMessage = manager.saveImage(image: image, name: imageName)
    }
    
    func deleteImage() {
        infoMessage = manager.deleteImage(name: imageName)
    }
    
    func deleteFolder() {
        infoMessage = manager.deleteFolder()
    }
    
}

struct FileManagerBootCamp: View {
    @StateObject private var viewModel = FileManagerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                Button {
                    viewModel.imageName = "Polar_Bear1"
                    viewModel.getImageFromAssetFolder()
                } label: {
                    ButtonLabel(buttonText: "LOAD FROM ASSET1", backgroundColor: .blue)
                }
                Button {
                    viewModel.imageName = "Polar_Bear2"
                    viewModel.getImageFromAssetFolder()
                } label: {
                    ButtonLabel(buttonText: "LOAD FROM ASSET2", backgroundColor: .blue)
                }
                Button {
                    viewModel.saveImage()
                } label: {
                    ButtonLabel(buttonText: "SAVE TO FM", backgroundColor: .orange)
                }
                Button {
                    viewModel.imageName = "Polar_Bear1"
                    viewModel.getImageFromFileManager()
                } label: {
                    ButtonLabel(buttonText: "LOAD FROM FM1", backgroundColor: .purple)
                }
                Button {
                    viewModel.imageName = "Polar_Bear2"
                    viewModel.getImageFromFileManager()
                } label: {
                    ButtonLabel(buttonText: "LOAD FROM FM2", backgroundColor: .purple)
                }
                Button {
                    viewModel.deleteImage()
                } label: {
                    ButtonLabel(buttonText: "DELETE FROM FM", backgroundColor: .pink)
                }
                Button {
                    viewModel.deleteFolder()
                } label: {
                    ButtonLabel(buttonText: "DELETE FM FOLDER", backgroundColor: .red)
                }
                
                Text(viewModel.infoMessage)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(viewModel.infoMessageColor)

                Spacer()
            }
            .navigationTitle("FILE MANAGER")
        }
    }
}

struct FileManagerBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerBootCamp()
    }
}

struct ButtonLabel: View {
    let buttonText: String
    let backgroundColor: Color
    var body: some View {
        Text(buttonText)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding()
            .padding(.horizontal)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}
