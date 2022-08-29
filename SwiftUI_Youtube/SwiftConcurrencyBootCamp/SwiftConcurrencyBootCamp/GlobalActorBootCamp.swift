//
//  GlobalActorBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/29.
//

import SwiftUI

@globalActor struct GlobalActorBootCampGlobalActor {
    static var shared = GlobalActorBootCampActor()
}

@globalActor final class GlobalActorBootCampGlobalActorFinalClass {
    static var shared = GlobalActorBootCampActor()
}

actor GlobalActorBootCampActor {

    func getDataFromDatabase() -> [String] {
        return ["MockData1", "MockData2", "MockData3"]
    }
    nonisolated func getDataFromDatabaseNonisolated() -> [String] {
        return ["MockData1", "MockData2", "MockData3"]
    }
}

// @MainActor class GlobalActorBootCampViewModel: ObservableObject {
// -> Entire variables to be run inside MainActor using @MainActor
class GlobalActorBootCampViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    @MainActor @Published var dataArrayUsingMain: [String] = []
    let dataService = GlobalActorBootCampActor()
    let dataServiceGlobal = GlobalActorBootCampGlobalActor.shared
    func getData() async {
        // Heavy and Complex Methods ->
        // MainActor (using MainThread) <-> GlobalActor (using GlobalThread)
        // GlobalActor: shared(Singleton)
        let data = await dataService.getDataFromDatabase()
        let data2 = dataService.getDataFromDatabaseNonisolated()
        self.dataArray = data
    }
    @GlobalActorBootCampGlobalActor func getDataFromGlobal() {
        Task {
            let data = await dataServiceGlobal.getDataFromDatabase()
            await MainActor.run(body: {
                self.dataArray = data
            })
        }
    }
    @MainActor func getDataFromMain() {
        Task {
            let data = await dataServiceGlobal.getDataFromDatabase()
            self.dataArray = data
            // Get data using MainThread (via MainActor)
        }
    }
    @GlobalActorBootCampGlobalActor func getDataFromGlobal2() {
        Task {
            let data = await dataServiceGlobal.getDataFromDatabase()
            // self.dataArrayUsingMain = data -> dataArrayUsingMain <- MainAcor needed
            // Property 'dataArrayUsingMain' isolated to global actor 'MainActor' can not be mutated from different global actor 'GlobalActorBootCampGlobalActor'
            await MainActor.run(body: {
                self.dataArrayUsingMain = data
            })
        }
    }
}

struct GlobalActorBootCamp: View {
    @StateObject private var viewModel = GlobalActorBootCampViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id:\.self) { data in
                    Text(data)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
        }
        .task {
//            await viewModel.getDataFromGlobal()
            // @GlobalActor -> even though not "async" keyword, it has to wait for those funcs to come back using "await"
            viewModel.getDataFromMain()
        }
    }
}

struct GlobalActorBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorBootCamp()
    }
}
