//
//  CloudKitUserBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/24.
//

import SwiftUI
import Combine

class CloudKitUserBootCampViewModel: ObservableObject {
    @Published var permissionStatus: Bool = false
    @Published var isSignedIntoiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getiCloudStatus()
        requestPermission()
        getCurrentUserName()
    }
    
    private func getiCloudStatus() {
        CloudKitUtility.getiCloudStatus()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    guard let self = self else { return }
                    self.error = error.localizedDescription
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] bool in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.isSignedIntoiCloud = true
                }
            }
            .store(in: &cancellables)
    }
    
    func requestPermission() {
        CloudKitUtility.getApplicationPermission()
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] bool in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.permissionStatus = true
                }
            }
            .store(in: &cancellables)
    }
    
    func getCurrentUserName() {
        CloudKitUtility.discoverUserIdentity()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] returnedName in
                guard let self = self else { return }
                self.userName = returnedName
            }
            .store(in: &cancellables)
    }
}

struct CloudKitUserBootCamp: View {
    @StateObject private var viewModel = CloudKitUserBootCampViewModel()
    var body: some View {
        VStack {
            Text("IS SIGNED IN: \(viewModel.isSignedIntoiCloud.description.uppercased())")
            Text(viewModel.error)
            Text("Permission Status: \(viewModel.permissionStatus.description)")
            Text("User Name: \(viewModel.userName)")
        }
    }
}

struct CloudKitUserBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitUserBootCamp()
    }
}
