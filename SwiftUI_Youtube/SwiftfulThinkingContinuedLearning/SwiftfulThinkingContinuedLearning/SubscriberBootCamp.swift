//
//  SubscriberBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI
import Combine

class SubscriberViewModel: ObservableObject {
    @Published var textFieldText = ""
    @Published var count: Int = 0
    @Published var textIsValid: Bool = false
    @Published var showButton: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setUpTimer()
        addTextFieldSubscriber()
        addButtonSubsriber()
    }
    
    func addTextFieldSubscriber() {
        $textFieldText
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .map { (text) -> Bool in
                if text.count > 3 {
                    return true
                }
                return false
            }
            .sink(receiveValue: { [weak self] isValid in
                guard let self = self else { return }
                self.textIsValid = isValid
            })
            .store(in: &cancellables)
    }
    
    func addButtonSubsriber() {
        $textIsValid
            .combineLatest($count)
            .sink { [weak self] (isValid, count) in
                guard let self = self else { return }
                if isValid && count >= 10 {
                    self.showButton = true
                } else {
                    self.showButton = false
                }
            }
            .store(in: &cancellables)
    }
    
    func setUpTimer() {
        Timer
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.count += 1
            }
            .store(in: &cancellables)
    }
}

struct SubscriberBootCamp: View {
    @StateObject private var viewModel = SubscriberViewModel()
    var body: some View {
        VStack {
            Text("\(viewModel.count)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            TextField("Type something here...", text: $viewModel.textFieldText)
                .padding(.leading)
                .frame(height: 55)
                .font(.headline)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .overlay(
                    ZStack {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .opacity(
                                viewModel.textFieldText.count < 1 ? 0.0 :
                                viewModel.textIsValid ? 0.0 : 1.0)
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .opacity(viewModel.textIsValid ? 1.0 : 0.0)
                    }
                    .font(.headline)
                    .padding(.trailing)
                    , alignment: .trailing
                )
            
            Button(action: {
                
            }, label: {
                Text("Submit".uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .opacity(viewModel.showButton ? 1.0 : 0.0)
            })
            .disabled(!viewModel.showButton)
        }
        .padding()
    }
}

struct SubscriberBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        SubscriberBootCamp()
    }
}
