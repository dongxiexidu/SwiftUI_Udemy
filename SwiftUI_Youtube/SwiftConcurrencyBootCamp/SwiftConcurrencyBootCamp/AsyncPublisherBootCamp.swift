//
//  AsyncPublisherBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/29.
//

import SwiftUI
import Combine

class AsyncPublisherBootCampDataService {
    @Published var dataArray: [String] = []
    
    func getData() async {
        dataArray.append("MockData1")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        dataArray.append("MockData2")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        dataArray.append("MockData3")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        dataArray.append("MockData4")
    }
}

class AsyncPublisherBootCampViewModel: ObservableObject {
    @MainActor @Published var dataArray: [String] = []
    let dataService = AsyncPublisherBootCampDataService()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber3()
    }
    
    private func addSubsriber() {
        dataService.$dataArray
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dataArray in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.dataArray = dataArray
                }
            }
            .store(in: &cancellables)
    }
    
    private func addSubscriber2() {
        Task {
            for await value in dataService.$dataArray.values {
                // Executed Async
                await MainActor.run(body: {
                    self.dataArray = value
                })
            }
        }
    }
    
    private func addSubscriber3() {
        Task {
            await MainActor.run(body: {
                self.dataArray = ["One"]
            })
            for await value in dataService.$dataArray.values {
                // Executed Async
                await MainActor.run(body: {
                    self.dataArray = value
                })
                break
                // using break -> escape those for-ever waiting loop
            }
            await MainActor.run(body: {
                self.dataArray = ["Two"]
            })
        }
    }
    
    func getData() async {
        await dataService.getData()
    }
}

struct AsyncPublisherBootCamp: View {
    @StateObject private var viewModel = AsyncPublisherBootCampViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id:\.self) { data in
                    // Executed immediately
                    Text(data)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

struct AsyncPublisherBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherBootCamp()
    }
}
