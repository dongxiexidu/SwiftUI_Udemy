//
//  WeakSelfBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/19.
//

import SwiftUI

struct WeakSelfBootCamp: View {
    @AppStorage("count") var count: Int?
    init() {
        count = 0
    }
    
    var body: some View {
        NavigationView {
            NavigationLink("Navigate", destination: WeakSelfSecondScreen())
                .navigationTitle("Screen 1")
        }
        .overlay(
            Text("\(count ?? 0)")
                .font(.largeTitle)
                .padding()
                .background(Color.green.cornerRadius(10))
            , alignment: .topTrailing
        )
    }
}

struct WeakSelfSecondScreen: View {
    @StateObject private var viewModel = WeakSelfSecondScreenViewModel()
    var body: some View {
        Text("Second View")
            .font(.largeTitle)
            .foregroundColor(.red)
        if let data = viewModel.data {
            Text(data)
        }
    }
}

class WeakSelfSecondScreenViewModel: ObservableObject {
    @Published var data: String? = nil
    
    init() {
        print("INIT")
        let curCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(curCount + 1, forKey: "count")
        getData()
    }
    
    func getData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            // LOGN DATA DOWNLOADING
            self.data = "NEW DATA"
        })
    }
    
    deinit {
        print("DEINIT")
        let curCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(curCount - 1, forKey: "count")
    }
}

struct WeakSelfBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        WeakSelfBootCamp()
    }
}
