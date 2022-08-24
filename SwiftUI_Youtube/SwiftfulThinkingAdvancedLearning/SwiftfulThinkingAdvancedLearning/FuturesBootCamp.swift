//
//  FuturesBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/24.
//

import SwiftUI
import Combine

// download with Combine
// download with @escaping closures
// convert @escaping closure to Combine

class FuturesBootCampViewModel: ObservableObject {
    @Published var title: String = "Starting Title"
    var cancellables = Set<AnyCancellable>()
    let url = URL(string: "https://www.google.com")!
    
    init() {
//        download()
//        downloadWithEscapingClosure()
//        downloadWithFuturePublisher()
        downloadWithFuturePublisher2()
    }
    
    func download() {
        getCombinePublisher()
            .sink { _ in
            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
            .store(in: &cancellables)
    }
    
    func downloadWithEscapingClosure() {
        getEscapingClosure { [weak self] value, error in
            self?.title = value
        }
    }
    
    func downloadWithFuturePublisher() {
        getFuturePublisher()
            .sink { _ in
            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
            .store(in: &cancellables)
    }
    
    func downloadWithFuturePublisher2() {
        doSomethingInTheFuture()
            .sink { _ in
            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
            .store(in: &cancellables)
    }
    
    
    func getCombinePublisher() -> AnyPublisher<String, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({ _ in
                return "NEW VALUE"
            })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHandler: @escaping (_ value: String, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completionHandler("New Value2", nil)
        }
        .resume()
    }
    
    func getFuturePublisher() -> Future<String, Error> {
        return Future { promise in
            self.getEscapingClosure { returnedValue, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(returnedValue))
                }
            }
        }
    }
    
    func doSomething(completionHandler: @escaping (_ value: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completionHandler("NEW STRING")
        }
    }
    
    func doSomethingInTheFuture() -> Future<String, Never> {
        Future { promise in
            self.doSomething { value in
                promise(.success(value))
            }
        }
    }
}

struct FuturesBootCamp: View {
    @StateObject private var viewModel = FuturesBootCampViewModel()
    var body: some View {
        Text(viewModel.title)
            .font(.largeTitle)
            .fontWeight(.semibold)
    }
}

struct FuturesBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        FuturesBootCamp()
    }
}
