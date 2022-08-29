//
//  ActorBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/29.
//

import SwiftUI

actor ActorBootCampDataServiceActor {
    static let instance = ActorBootCampDataServiceActor()
    private init() {}
    
    var data: [String] = []
    nonisolated let nonisolatedValue: String = "No have to worry about Thread-Safety"
    // Call this nonisolated value without await
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print("Current Thread : \(Thread.current)")
        return self.data.randomElement()
    }
    // Easier to Code than Custom Queue made in Class
    // Await before getting to the Actor
    
    nonisolated func getSavedData() -> String {
        // let data = getRandomData() -> Cannot Use
        // Actor-isolated instance method 'getRandomData()' can not be referenced from a non-isolated context
        return "No have to worry about Thread-Safety"
    }
}

class ActorBootCampDataServiceClass {
    static let instance = ActorBootCampDataServiceClass()
    private init() {} // Singleton pattern
    
    var data: [String] = []
    private let lock = DispatchQueue(label: "CustomQueue")
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print("Current Thread : \(Thread.current)")
        // HomeView, BrowseView -> Same <Main Thread> (If DispatchQueue.main)
        // HomeView, BrowseView -> Different <Threads> (If DispathQueue.global)
        return data.randomElement()
    }
    
    func getRandomDataSafe(completionHandler: @escaping (_ title: String?) -> Void) {
        lock.async {
            self.data.append(UUID().uuidString)
            print("Current Thread : \(Thread.current)")
            completionHandler(self.data.randomElement())
        }
        // all of requests from multiple functions -> lined up serially
        // Must be out of Queue(lock) async block
    }
}

struct HomeView: View {
    @State private var text: String = ""
    let dataService = ActorBootCampDataServiceClass.instance
    let dataServiceActor = ActorBootCampDataServiceActor.instance
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .onReceive(timer) { _ in
            getDataUsingActorSafe()
        }
        .onAppear {
            getDataFromActor()
        }
    }
    
    private func getDataFromActor() {
        Task {
            let data = await dataServiceActor.data
            // data -> isolated from outside of actor
            print(data)
        }
        let nonisolatedFuncReturned = dataServiceActor.getSavedData()
        let nonisolatedValueReturned = dataServiceActor.nonisolatedValue
        // whether inside Task block or not, its returned value as nonisolated can be used
    }
    
    private func getDataUsingMain() {
        if let data = dataService.getRandomData() {
            self.text = data
        }
    }
    
    private func getDataUsingBackgroundUnsafe() {
        // ThreadSanitizer said WARNING: ThreadSanitizer: Swift access race
        DispatchQueue.global(qos: .background).async {
            if let data = dataService.getRandomData() {
                self.text = data
            }
        }
    }
    
    private func getDataUsingBackgroundSafe() {
        DispatchQueue.global(qos: .background).async {
            dataService.getRandomDataSafe { title in
                if let data = title {
                    DispatchQueue.main.async {
                        self.text = data
                    }
                }
            }
        }
    }
    
    private func getDataUsingActorSafe() {
        Task {
            if let data = await dataServiceActor.getRandomData() {
                await MainActor.run(body: {
                    self.text = data
                })
            }
        }
    }
}

struct BrowseView: View {
    @State private var text: String = ""
    let dataService = ActorBootCampDataServiceClass.instance
    let dataServiceActor = ActorBootCampDataServiceActor.instance
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .onReceive(timer) { _ in
            getDataUsingActorSafe()
        }
    }
    
    private func getDataUsingMain() {
        if let data = dataService.getRandomData() {
            self.text = data
        }
    }
    
    private func getDataUsingBackgroundUnsafe() {
        // ThreadSanitizer said WARNING: ThreadSanitizer: Swift access race
        DispatchQueue.global(qos: .background).async {
            if let data = dataService.getRandomData() {
                self.text = data
            }
        }
    }
    
    private func getDataUsingBackgroundSafe() {
        DispatchQueue.global(qos: .background).async {
            dataService.getRandomDataSafe { title in
                if let data = title {
                    DispatchQueue.main.async {
                        self.text = data
                    }
                }
            }
        }
    }
    
    private func getDataUsingActorSafe() {
        Task {
            if let data = await dataServiceActor.getRandomData() {
                await MainActor.run(body: {
                    self.text = data
                })
            }
        }
    }
}

struct ActorBootCamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ActorBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        ActorBootCamp()
    }
}
