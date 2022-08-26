//
//  DoCatchTryThrowBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/26.
//

import SwiftUI

protocol DoCatchTryThrowBootCampProtocol {
    var isActive: Bool { get set}
    func getTitle() -> String?
    func getTitle2() -> (title: String?, error: Error?)
    func getTitle3() -> Result<String, Error>
    func getTitle4() throws -> String
    func getTitle5() throws -> String
}

enum DoCatchTryThrowError: LocalizedError {
    case getTitleError
}

class DoCatchTryThrowBootCampDataManager: DoCatchTryThrowBootCampProtocol {
    var isActive: Bool = true
    let returnedText: String = "Returned Text"
    func getTitle() -> String? {
        return isActive ? returnedText : nil
    }
    func getTitle2() -> (title: String?, error: Error?) {
        return isActive ? (returnedText, nil) : (nil, DoCatchTryThrowError.getTitleError)
    }
    func getTitle3() -> Result<String, Error> {
        return isActive ? .success(returnedText) : .failure(DoCatchTryThrowError.getTitleError)
    }
    func getTitle4() throws -> String {
        if isActive {
            return returnedText
        } else {
            throw DoCatchTryThrowError.getTitleError
        }
    }
    func getTitle5() throws -> String {
        throw DoCatchTryThrowError.getTitleError
    }
}

class DoCatchTryThrowBootCampViewModel: ObservableObject {
    @Published var text: String = "Default Text"
    var manager: DoCatchTryThrowBootCampProtocol
    
    init(manager: DoCatchTryThrowBootCampProtocol) {
        self.manager = manager
    }
    func fetchTitle() {
        guard let text = manager.getTitle() else { return }
        self.text = text
    }
    func fetchTitle2() {
        let returnedValue = manager.getTitle2()
        if let text = returnedValue.title {
            self.text = text
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
    }
    func fetchTitle3() {
        let completion = manager.getTitle3()
        switch completion {
        case .success(let returnedValue):
            self.text = returnedValue
        case .failure(let error):
            self.text = error.localizedDescription
        }
    }
    func fetchTitle4() {
        do {
            self.text = try manager.getTitle4()
        } catch {
            self.text = error.localizedDescription
        }
    }
    func fetchTitle5() {
        guard let text = try? manager.getTitle4() else {
            self.text = DoCatchTryThrowError.getTitleError.localizedDescription
            return }
        self.text = text
    }
    func fetchTitle6() {
        do {
            self.text = try manager.getTitle4()
            self.text = try manager.getTitle5()
            // getTitle4 -> try success, getTitle5 -> try fail
            // then catch block
        } catch {
            self.text = error.localizedDescription
        }
    }
    func fetchTitle7() {
        do {
            if let text = try? manager.getTitle5() {
                self.text = text
            }
            self.text = try manager.getTitle4()
            // getTitle4 -> try success, getTitle5 -> try fail but returned nil -> return getTitle4's value
        } catch {
            self.text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowBootCampViewModifier: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}

extension View {
    func withDoCatchTryThorwBootCampViewModifier(backgroundColor: Color = Color.blue.opacity(0.7)) -> some View {
        modifier(DoCatchTryThrowBootCampViewModifier(backgroundColor: backgroundColor))
    }
}

struct DoCatchTryThrowBootCamp: View {
    @StateObject private var viewModel: DoCatchTryThrowBootCampViewModel
    
    init(dataManager: DoCatchTryThrowBootCampProtocol) {
        _viewModel = StateObject(wrappedValue: DoCatchTryThrowBootCampViewModel(manager: dataManager))
        // Dependency Ingection
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                textBox
                activeToggleButton
            }
            .padding(.horizontal, 10)
            .padding(.vertical,100)
            .navigationTitle("DoCatchTryThrow")
        }
    }
}

extension DoCatchTryThrowBootCamp {
    private var textBox: some View {
        Text(viewModel.text)
            .font(.title)
            .fontWeight(.bold)
            .withDoCatchTryThorwBootCampViewModifier()
            .onTapGesture {
                viewModel.fetchTitle4()
            }
    }
    private var activeToggleButton: some View {
        Button {
            viewModel.manager.isActive.toggle()
            viewModel.text = "Default Text"
        } label: {
            Text("Active Toggle : \(viewModel.manager.isActive.description)")
                .foregroundColor(.black)
                .font(.title)
                .fontWeight(.bold)
                .withDoCatchTryThorwBootCampViewModifier(backgroundColor: .red.opacity(0.3))
                .frame(height: 70)
        }
    }
}

struct DoCatchTryThrowBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowBootCamp(dataManager: DoCatchTryThrowBootCampDataManager())
    }
}
