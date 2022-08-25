//
//  CloudKitPushNotificationBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/24.
//

import SwiftUI
import Combine

class CloudKitPushNotificationBootCampViewModel: ObservableObject {
    let subscriptionID = "fruit_added_to_database"
    let recordType = "Fruits"
    var cancellables = Set<AnyCancellable>()
    
    func requestNotificationPermission() {
        CloudKitUtility.requestNotificationPermission()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { returnedData in
            }
            .store(in: &cancellables)
    }
    
    func subscribeToNotifications() {
        CloudKitUtility
            .subscribeToNotification(recordType: recordType, subscriptionID: subscriptionID)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                case .finished:
                    break
                }
            } receiveValue: { returnedData in
                print("SUCCESSFULLY SUBSCRIBE NOTIFICATION")
            }
            .store(in: &cancellables)
    }
    
    func unsubscribeToNotification() {
        CloudKitUtility
            .unsubsribeToNotification(subscriptionID: subscriptionID)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { returnedData in
                print("SUCCESSFULLY UNSUBSCRIBE NOTIFICATION")
            }
            .store(in: &cancellables)
    }
}

struct CloudKitPushNotificationBootCamp: View {
    @StateObject private var viewModel = CloudKitPushNotificationBootCampViewModel()
    var body: some View {
        VStack(spacing: 40) {
            Button {
                viewModel.requestNotificationPermission()
            } label: {
                Text("Request Notification Permission")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .withDefaultButtonFormmating(Color.orange.opacity(0.8))
            }
            .withPressableStyle(0.8)
            Button {
                viewModel.subscribeToNotifications()
            } label: {
                Text("Subscribe to Notification")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .withDefaultButtonFormmating(Color.blue.opacity(0.8))
            }
            .withPressableStyle(0.8)
            Button {
                viewModel.unsubscribeToNotification()
            } label: {
                Text("Unsubscribe to Notification")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .withDefaultButtonFormmating(Color.pink.opacity(0.8))
            }
            .withPressableStyle(0.8)
        }
        .padding(.horizontal, 40)
    }
}

struct CloudKitPushNotificationBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitPushNotificationBootCamp()
    }
}
