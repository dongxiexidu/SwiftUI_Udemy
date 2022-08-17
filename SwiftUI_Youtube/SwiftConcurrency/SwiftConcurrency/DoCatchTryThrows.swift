//
//  DoCatchTryThrows.swift
//  SwiftConcurrency
//
//  Created by Junyeong Park on 2022/08/16.
//

import SwiftUI
// do-catch
// try
// throws

class DoCatchTryThrowDataManager {
    let isActive: Bool = true
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("New Text", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("new text")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "New Text"
        } else {
            throw URLError(.badURL)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "Final Text"
        } else {
            throw URLError(.badURL)
        }
    }
}

class DoCatchTryThrowsViewModel: ObservableObject {
    @Published var text: String = "Start Project"
    let manager = DoCatchTryThrowDataManager()
    
    func fetchTitle() {
//        let value = manager.getTitle()
//        if let newTitle = value.title {
//            self.text = newTitle
//        } else if let error = value.error {
//            self.text = error.localizedDescription
//        }
//
//        let result = manager.getTitle2()
//        switch result {
//        case .success(let newTitle):
//            self.text = newTitle
//        case .failure(let error):
//            self.text = error.localizedDescription
//        }
        do {
            if let newTitle = try? manager.getTitle3() {
                self.text = newTitle
            }
//            self.text = try? manager.getTitle4()
//            print("GETTILE4")
        } catch {
            self.text = error.localizedDescription
        }
//        guard let newTitle = try? manager.getTitle3() else {
//            return
//        }
//        self.text = newTitle
        // Optional Try!
    
    }
}


struct DoCatchTryThrows: View {
    @StateObject private var viewModel = DoCatchTryThrowsViewModel()
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.red)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoCatchTryThrows_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrows()
    }
}
