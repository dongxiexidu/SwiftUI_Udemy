//
//  AsyncPublisher.swift
//  SwiftConcurrency
//
//  Created by Junyeong Park on 2022/08/17.
//

import SwiftUI
import Combine

class AsyncPublisherDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        for _ in 0..<4 {
            myData.append("APPLE")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }
}


class AsyncPublisherViewModel: ObservableObject {
    @Published var dataArray = [String]()
    let manager = AsyncPublisherDataManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        Task {
            for await value in manager.$myData.values {
//                self.dataArray = value
                await MainActor.run(body: {
                    self.dataArray = value
                })
            }
        }
//        manager.$myData
//            .receive(on: DispatchQueue.main, options: nil)
//            .sink { dataArray in
//                self.dataArray = dataArray
//            }
//            .store(in: &cancellables)
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisher: View {
    @StateObject private var viewModel = AsyncPublisherViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id:\.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.start()
            }
        }
    }
}

struct AsyncPublisher_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisher()
    }
}
