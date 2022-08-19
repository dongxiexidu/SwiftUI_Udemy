//
//  MultiThreadBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/19.
//

import SwiftUI

class BackgroundThreadViewModel: ObservableObject {
    @Published var dataArray = [String]()
    
    func fetchData() {
        DispatchQueue.global(qos: .background).async {
            // DOWNLOAD BACKGROUND DATA
            let newData = self.downloadData()
            print("Check 1: \(Thread.current)")
            DispatchQueue.main.async {
                // UI UPDATE
                self.dataArray = newData
                print("Check 2: \(Thread.current)")

            }
        }
    }
    
    private func downloadData() -> [String] {
        var data: [String] = []
        for str in 0..<100 {
            data.append("\(str)")
        }
        return data
    }
}

struct MultiThreadBootCamp: View {
    @StateObject private var viewModel = BackgroundThreadViewModel()
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                Text("LOAD DATA")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        viewModel.fetchData()
                    }
                ForEach(viewModel.dataArray, id:\.self) { data in
                    Text(data)
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct MultiThreadBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        MultiThreadBootCamp()
    }
}
