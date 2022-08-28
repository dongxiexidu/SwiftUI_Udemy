//
//  TaskBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/28.
//

import SwiftUI

class TaskBootCampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    
    func getURL() -> URL? {
        guard let url = URL(string: "https://picsum.photos/1000") else { return nil }
        return url
    }
    
    func fetchImage() async {
        guard let url = getURL() else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImage2() async {
        guard let url = getURL() else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func printTaskPriority() {
        Task(priority: .low) {
            print("LOW: \(Thread.current) : \(Task.currentPriority)")
        }
        Task(priority: .medium) {
            print("MEDIUM: \(Thread.current) : \(Task.currentPriority)")
        }
        Task(priority: .high) {
            print("HIGH: \(Thread.current) : \(Task.currentPriority)")
        }
        Task(priority: .background) {
            print("BACKGROUND: \(Thread.current) : \(Task.currentPriority)")
        }
        Task(priority: .userInitiated) {
            print("USERINITIATED: \(Thread.current) : \(Task.currentPriority)")
        }
        Task(priority: .utility) {
            print("UTILITY: \(Thread.current) : \(Task.currentPriority)")
        }
        
        /*
         HIGH: <NSThread: 0x600002266980>{number = 4, name = (null)} : TaskPriority(rawValue: 25)
         USERINITIATED: <NSThread: 0x600002266980>{number = 4, name = (null)} : TaskPriority(rawValue: 25)
         MEDIUM: <NSThread: 0x60000224bc80>{number = 6, name = (null)} : TaskPriority(rawValue: 21)
         LOW: <NSThread: 0x60000223d9c0>{number = 5, name = (null)} : TaskPriority(rawValue: 17)
         UTILITY: <NSThread: 0x60000223d9c0>{number = 5, name = (null)} : TaskPriority(rawValue: 17)
         BACKGROUND: <NSThread: 0x60000224bc80>{number = 6, name = (null)} : TaskPriority(rawValue: 9)
         */
    }
    
    func printTaskPrioirty2() async {
        Task(priority: .low) {
            print("LOW: \(Thread.current) : \(Task.currentPriority)")
        }
        Task(priority: .medium) {
            print("MEDIUM: \(Thread.current) : \(Task.currentPriority)")
        }
        Task(priority: .high) {
//            try? await Task.sleep(nanoseconds:2_000_000_00)
            await Task.yield()
            print("HIGH: \(Thread.current) : \(Task.currentPriority)")
        }
        Task(priority: .background) {
            print("BACKGROUND: \(Thread.current) : \(Task.currentPriority)")
        }
        Task(priority: .userInitiated) {
            print("USERINITIATED: \(Thread.current) : \(Task.currentPriority)")
        }
        Task(priority: .utility) {
            print("UTILITY: \(Thread.current) : \(Task.currentPriority)")
        }
        /*
         USERINITIATED: <NSThread: 0x600003c5a400>{number = 7, name = (null)} : TaskPriority(rawValue: 25)
         MEDIUM: <NSThread: 0x600003c5f7c0>{number = 5, name = (null)} : TaskPriority(rawValue: 21)
         LOW: <NSThread: 0x600003c469c0>{number = 6, name = (null)} : TaskPriority(rawValue: 17)
         UTILITY: <NSThread: 0x600003c469c0>{number = 6, name = (null)} : TaskPriority(rawValue: 17)
         BACKGROUND: <NSThread: 0x600003c469c0>{number = 6, name = (null)} : TaskPriority(rawValue: 9)
         HIGH: <NSThread: 0x600003c469c0>{number = 6, name = (null)} : TaskPriority(rawValue: 25)
         -> YEILD THREAD
         */
    }
    
    func printParentChildTask() {
        Task(priority: .low) {
            print("Parent: \(Thread.current) : \(Task.currentPriority)")
            
            Task {
                print("Child: \(Thread.current) : \(Task.currentPriority)")
            }
            
            Task.detached(priority: .high) {
                print("Child Detached: \(Thread.current) : \(Task.currentPriority)")
            }
        }
        /*
         Parent: <NSThread: 0x600002b7cc80>{number = 6, name = (null)} : TaskPriority(rawValue: 17)
         Child Detached: <NSThread: 0x600002b11a00>{number = 4, name = (null)} : TaskPriority(rawValue: 25)
         Child: <NSThread: 0x600002b7cc80>{number = 6, name = (null)} : TaskPriority(rawValue: 17)
         -> Don't use detached method if possible as official Doc says
         */
    }
    
    func resetImages() {
        image = nil
        image2 = nil
    }
}

struct TaskBootCamp: View {
    @StateObject private var viewModel = TaskBootCampViewModel()
    @State private var count: Int = 0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var fetchImageTask: Task<(), Never>? = nil
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink {
                    imageView
                } label: {
                    Text("Image Download")
                }
            }
        }
    }
}

extension TaskBootCamp {
    private var imageView: some View {
        VStack {
            Text("TIMER COUNT: \(count)")
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            if let image2 = viewModel.image2 {
                Image(uiImage: image2)
                    .resizable()
                    .scaledToFit()
            }
        }
        .onReceive(timer, perform: { _ in
            count = count + 1 <= 5 ? count + 1 : count
        })
        .onAppear {
            viewModel.resetImages()
            count = 0
//            taskFetchImages2()
        }
//        .onDisappear {
//            count = 0
//            fetchImageTask?.cancel()
//        }
        .task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            await viewModel.fetchImage()
            await viewModel.fetchImage2()
        }
    }
    func taskFetchImages() {
        Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            await viewModel.fetchImage()
            await viewModel.fetchImage2()
        }
    }
    func taskFetchImages2() {
        fetchImageTask = Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            await viewModel.fetchImage()
        }
    }
}
struct TaskBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootCamp()
    }
}
