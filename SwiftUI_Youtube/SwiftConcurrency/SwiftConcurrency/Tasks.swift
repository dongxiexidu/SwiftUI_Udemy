//
//  Tasks.swift
//  SwiftConcurrency
//
//  Created by Junyeong Park on 2022/08/16.
//

import SwiftUI

class TasksViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    let array = Array(repeating: 1, count: 100)
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
        for item in array {
            print(item)
            try? Task.checkCancellation()
        }
        
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = UIImage(data: data)
            await MainActor.run(body: {
                self.image = image
                print("Image returned successfully")
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = UIImage(data: data)
            await MainActor.run(body: {
                self.image2 = image
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("Click me!") {
                    Tasks()
                }
            }
        }
    }
}

struct Tasks: View {
    @StateObject private var viewModel = TasksViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
        .onAppear {
//            self.fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
//            Task(priority: .high) {
//                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("HIGH: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                print("USERINITIATED: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("MEDIUM: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print("LOW: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("UTILITY: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .background) {
//                print("BACKGROUND: \(Thread.current) : \(Task.currentPriority)")
//            }
            
//            Task(priority: .userInitiated) {
//                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
//
//                Task.detached {
//                    print("detached: \(Thread.current) : \(Task.currentPriority)")
//                }
//            }
            
        }
    }
}

struct Tasks_Previews: PreviewProvider {
    static var previews: some View {
        Tasks()
    }
}
