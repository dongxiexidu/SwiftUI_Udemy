//
//  AdvancedCombineBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/23.
//

import SwiftUI
import Combine

class AdvancedCombineDataService {
    // @Published var basicPublisher: String = "First Publish"
//    let currentValuePublisher = CurrentValueSubject<String, Error>("First Publish")
    let passThroughPublisher = PassthroughSubject<Int, Error>()
    // more memory efficient than CurrentValueSubject (all of values hold)
    let boolPublisher = PassthroughSubject<Bool, Error>()
    let intPublisher = PassthroughSubject<Int, Error>()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        // Mock Fake API Request
        let items = [1, 1, 1, 1, 1, 2, 3, 5, 6, 7, 8, 9, 11, 10, 1, 1, 1]
        for index in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
////                self.basicPublisher = items[index]
////                self.currentValuePublisher.send(items[index])
                self.passThroughPublisher.send(items[index])
                if index >= 4 && index < 8 {
                    self.boolPublisher.send(true)
                    self.intPublisher.send(999)
                } else {
                    self.boolPublisher.send(false)
                }
                if index == items.indices.last {
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
//            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                self.passThroughPublisher.send(1)
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
//                self.passThroughPublisher.send(2)
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.passThroughPublisher.send(3)
//            }
        }
    }
}

class AdvancedCombineBootCampViewModel: ObservableObject {
    @Published var data: [String] = []
    @Published var dataBools: [Bool] = []
    @Published var error: String = ""
    let dataService: AdvancedCombineDataService
    let multicastSubject = PassthroughSubject<Int, Error>()
    var cancellables = Set<AnyCancellable>()
    init(dataService: AdvancedCombineDataService) {
        self.dataService = dataService
        addSubscriber()
    }
    
    private func addSubscriber() {
        // Sequence Operations
        //    .first()
        //    .first(where: {$0 > 4})
        //    .filter{$0 > 4}
//            .tryFirst(where: { int in
//                if int == 3 {
//                    throw URLError(.badServerResponse)
//                }
//                return int > 4
//            })
        //    .last()
        //  Need to know When to Finish this publisher -> sink "finished"
       //     .last(where: {$0 < 4})
//            .tryLast(where: { int in
//                if int == 13 {
//                    throw URLError(.badServerResponse)
//                    // if no error at all, can sink
//                }
//                return int > 1
//                // int = 1, 2 -> Success but not checked
//            })
        //    .dropFirst()
        // drop first published item
        // if currentValuePublisher - default value and does not want to show that value, use dropFirst()
        //    .dropFirst(3)
        // dropFirst three items from the first place
//            .drop(while: { $0 > 5})
//            .tryDrop(while: { int in
//                if int == 15 {
//                    throw URLError(.badServerResponse)
//                }
//                return int < 6
//            })
         //   .prefix(4)
        // first four items of the stream
//            .prefix(while: { $0 < 5})
        // publish finishes when fails ($0 > 5 -> fails at the first moment)
//            .tryPrefix(while: { int in
//                if int > 15 {
//                    throw URLError(.badServerResponse)
//                }
//                return int < 5
//            })
        //    .output(at: 1)
        // output of item indices
        //    .output(in: 2..<4)
        // output items between those range
            
        // Mathematic Operations
            // .max()
        // need to waif for publisher to finish
//            .max(by: { int1, int2 in
//                return int1 < int2
//            })
        // maximum -> 10
//            .tryMax(by: { int1, int2 in
//                return int1 > int2
//            })
//            .max()
        
        // Filter // Reducing Operations
//            .tryMap({ int -> String in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return String(int)
//            })
        //            .compactMap({ int -> String? in
        //                if int == 5 {
        //                    return nil
        //                }
        //                return "\(int)"
        //            })
        //            .tryCompactMap({ int -> String in
        //                if int == 5 {
        //                    throw URLError(.badServerResponse)
        //                }
        //                return "\(int)"
        //            })
//            .filter{$0 > 3 && $0 < 9}
//            .removeDuplicates(by: { int1, int2 in
//                return int1 == int2
//            })
//            .replaceNil(with: 100)
        // nil replaced by with value
//            .replaceEmpty(with: [])
//            .replaceError(with: "100")
//            .scan(0, { existingValue, newValue in
//                return existingValue + newValue
//            })
//            .scan(0, {$0 + $1} )
//            .scan(0, +)
//            .reduce(0, +)
        // One Element returned by reduce
//            .allSatisfy({$0 < 200})
        // Bool return: true / false
//            .tryAllSatisfy({ int in
//                if int < 4 {
//                    return true
//                } else {
//                    throw URLError(.badServerResponse)
//                }
//            })
            
        // Timing Operations
        /*
//            .debounce(for: 0.75, scheduler: DispatchQueue.main)
            // at least 1 second between each publishers
//            .delay(for: 2, scheduler: DispatchQueue.main)
        // arrived late for 2 seconds in the pipeline
//            .measureInterval(using: DispatchQueue.main)
//            .map({ stride in
//                return "\(stride.timeInterval)"
//            })
//            .throttle(for: 5, scheduler: DispatchQueue.main, latest: true)
        // bottle neck effect
//            .retry(3)
        // try but redonwload # times after error occurs.
//            .timeout(0.2, scheduler: DispatchQueue.main)
        */
        
        // Multiple Publishers / Subscribers
/*
//            .combineLatest(dataService.boolPublisher, dataService.intPublisher)
//            .map{String($0)}
//            .compactMap({ (int, bool) -> String? in
//                if bool {
//                    return String(int)
//                } else {
//                    return nil
//                }
//            })
//            .compactMap{ $1 ? String($0) : "n/a"}
//            .compactMap({ (int1, bool, int2) -> String in
//                // at least all of three publisher items must be arrived
//                if bool {
//                    return String(int1)
//                } else {
//                    return "n/a"
//                }
//            })
//            .merge(with: dataService.intPublisher)
//            .zip(dataService.boolPublisher, dataService.intPublisher)
//            .map { tuple in
//                // at least three publishers must arrive before using tuple
//                return String(tuple.0) + tuple.1.description + String(tuple.2)
//            }
//            .tryMap({ int in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return int
//            })
//            .catch({ error in
//                return self.dataService.intPublisher
//            })
//            .removeDuplicates()
        // Multiple Publishers make multiple items */
        
        let sharedPublisher = dataService.passThroughPublisher
            .share()
//            .multicast {
//                PassthroughSubject<Int, Error>()
//                // Make this publisher as "Auto Connected" Publisher
//            }
            .multicast(subject: multicastSubject)
        
        sharedPublisher
//        dataService.passThroughPublisher
            .map{String($0)}
            .sink { completion in
                switch completion {
                case .finished:
                    print("SUCCESS")
                    break
                case .failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    self.error = error.localizedDescription
                    break
                }
            } receiveValue: { [weak self] returnedData in
                guard let self = self else { return }
                self.data.append(returnedData)
//                self.data = returnedData
            }
            .store(in: &cancellables)
  
        sharedPublisher
//        dataService.passThroughPublisher
            .map{$0 > 5 ? true : false}
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error): break
                }
            } receiveValue: { [weak self] returnedData in
                guard let self = self else { return }
                self.dataBools.append(returnedData)
            }
            .store(in: &cancellables)
        // Subscribe multiple times at One Publisher
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            sharedPublisher
                .connect()
                .store(in: &self.cancellables)
            // delay and connect publisher's collection
        }
    }
}

struct AdvancedCombineBootCamp: View {
    @StateObject private var viewModel: AdvancedCombineBootCampViewModel
    
    init(dataService: AdvancedCombineDataService) {
        _viewModel = StateObject(wrappedValue: AdvancedCombineBootCampViewModel(dataService: dataService))
    }
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.data, id:\.self) { data in
                    Text(data)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.pink)
                }
                
                if !viewModel.error.isEmpty {
                    Text(viewModel.error)
                }
            }
            .padding()
        }
    }
}

struct AdvancedCombineBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineBootCamp(dataService: AdvancedCombineDataService())
    }
}
