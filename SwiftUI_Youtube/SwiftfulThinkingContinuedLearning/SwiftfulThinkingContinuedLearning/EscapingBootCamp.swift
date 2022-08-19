//
//  EscapingBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/19.
//

import SwiftUI

class EscapingViewModel: ObservableObject {
    @Published var text = "Hello!"
    
    init() {
        print("INIT")
    }
    
    deinit {
        print("DEINIT")
    }
    
    func getData() {
        downloadData5 { [weak self] data in
            self?.text = data.data
        }
    }
    
    func downloadData() -> String {
        return "New Data"
    }
    
    func downloadData2(completionHandler: (_ data: String) -> Void) {
        completionHandler("New DATA!")
    }
    
    func downloadData3(completionHandler: @escaping (_ data: String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler("New Data!")
        }
    }
    
    func downloadData4(completionHandler: @escaping (_ data: DownloadResult) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let result = DownloadResult(data: "New Data!")
            completionHandler(result)
        }
    }
    
    func downloadData5(completionHandler: @escaping DownloadCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let result = DownloadResult(data: "New Data!")
            completionHandler(result)
        }
    }
    
    func doSomething(_ data: String) {
        print(data)
    }
}

struct DownloadResult {
    let data: String
}

typealias DownloadCompletion = (DownloadResult) -> ()

struct EscapingBootCamp: View {
    @StateObject private var viewModel = EscapingViewModel()
    var body: some View {
        Text(viewModel.text)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.red)
            .onTapGesture {
                viewModel.getData()
            }
    }
}

struct EscapingBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        EscapingBootCamp()
    }
}
