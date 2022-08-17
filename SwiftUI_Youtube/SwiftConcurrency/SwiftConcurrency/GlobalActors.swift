//
//  GlobalActors.swift
//  SwiftConcurrency
//
//  Created by Junyeong Park on 2022/08/17.
//

import SwiftUI

// Global actor -> Not use isolated
// isolated to this global actor,

@globalActor final class MyFirstGlobalActor {
    static var shared = MyNewDataManager()
    private init() {
        
    }
    
}

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["1", "2", "3", "4"]
    }
}

@MainActor class GlobalActorViewModel: ObservableObject {
    @Published var dataArray = [String]()
    @Published var dataArray1 = [String]()
    @Published var dataArray2 = [String]()
    @Published var dataArray3 = [String]()
    @Published var dataArray4 = [String]()
    @Published var dataArray5 = [String]()
    @Published var dataArray6 = [String]()

    let manager = MyFirstGlobalActor.shared
    
    nonisolated func getData() {
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run(body: {
                self.dataArray = data
            })
        }
    }
}

struct GlobalActors: View {
    @StateObject private var viewModel = GlobalActorViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id:\.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

struct GlobalActors_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActors()
    }
}
