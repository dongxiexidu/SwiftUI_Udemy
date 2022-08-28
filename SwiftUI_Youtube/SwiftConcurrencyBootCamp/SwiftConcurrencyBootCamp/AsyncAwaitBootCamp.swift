//
//  AsyncAwaitBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/28.
//

import SwiftUI

class AsyncAwaitBootCampViewModel: ObservableObject {
    @Published var dataArray = [String]()
    
    func addTitle1() {
        dataArray.append("TITLE1 : \(Thread.current)\nIs Main? : \(Thread.isMainThread)")
    }
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title2 = "TITLE2 : \(Thread.current)\nIs Main? : \(Thread.isMainThread)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dataArray.append(title2)
                self.dataArray.append("Title3: \(Thread.current)\nIs Main? : \(Thread.isMainThread)")
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "Author1 : \(Thread.current)"
        self.dataArray.append(author1)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        // after sleep -> thread : not main thread
//        try? await doSometing()
        // await -> suspension point
        let author2 = "Author2: \(Thread.current)"
        // after sleep -> thread : main thread
        await MainActor.run(body: {
            self.dataArray.append(author2)
            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        })
        await addSomething()
    }
    
    func doSometing() async throws {
        print("do Something")
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something1 = "Something1 : \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(something1)
            
            let something2 = "Something2 : \(Thread.current)"
            self.dataArray.append(something2)
        })
    }
}

struct AsyncAwaitBootCamp: View {
    @StateObject private var viewModel = AsyncAwaitBootCampViewModel()
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id:\.self) { data in
                Text(data)
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .onAppear {
            Task {
                await viewModel.addAuthor1()
                await viewModel.addSomething()
                let finalText = "FinalText : \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
        }
    }
}

struct AsyncAwaitBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootCamp()
    }
}
