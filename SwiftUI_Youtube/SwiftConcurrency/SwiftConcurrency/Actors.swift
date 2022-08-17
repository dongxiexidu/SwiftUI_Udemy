//
//  Actors.swift
//  SwiftConcurrency
//
//  Created by Junyeong Park on 2022/08/17.
//

import SwiftUI

// 1. What is the problem that actor are solving?
// - Thread Unsafe access to same calss from multiple thread environment
// 2. How was this problem solved prior to actors?
// - Inside Singleton data fetch function, you can use your custom dispatchqueue and make your fetch inside that queue serially so you can ensure your thread safety more easily. it should be implemented via completion handler either.
// 3. Actors can solve the problem?
// - Yes! you can use actor, task, await and MainActor run.

class MyDataManager {
    static let instance = MyDataManager()
    
    private init() {
        
    }
    
    var data: [String] = []
    private let queue = DispatchQueue(label: "com.JunyeongPark.MyDataManager")
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> Void) {
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    static let instance = MyActorDataManager()
    nonisolated let str = "AAAA"
    
    private init() {
        
    }
    
    var data: [String] = []
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        return "Some New Data"
    }
}

struct HomeView: View {
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onAppear {
            let newA = manager.str
            Task {
                let newString = await manager.getSavedData
            }
        }
        .onReceive(timer) { _ in
//            DispatchQueue.global(qos: .background).async {
//                manager.getRandomData(completionHandler: {
//                    title in
//                    if let data = title {
//                        self.text = data
//                    }
//                })
//            }
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
            }
        }
    }
}

struct BrowseView: View {
    @State private var text: String = ""
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()

    var body: some View {
        ZStack {
            Color.white.opacity(0.3).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
//            DispatchQueue.global(qos: .background).async {
//                manager.getRandomData(completionHandler: {
//                    title in
//                    if let data = title {
//                        self.text = data
//                    }
//                })
//            }
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
            }
        }
    }
}

struct Actors: View {
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

struct Actors_Previews: PreviewProvider {
    static var previews: some View {
        Actors()
    }
}
