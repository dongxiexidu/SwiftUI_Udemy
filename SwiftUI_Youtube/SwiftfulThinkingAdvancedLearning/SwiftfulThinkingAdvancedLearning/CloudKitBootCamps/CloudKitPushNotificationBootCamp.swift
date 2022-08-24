//
//  CloudKitPushNotificationBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/24.
//

import SwiftUI
import CloudKit

class CloudKitPushNotificationBootCampViewModel: ObservableObject {
    let subscriptionID = "fruit_added_to_database"

    func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error.localizedDescription)
            } else if success {
                print("NOTIFICATION PERMISSION SUCCESS")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("NOTIFICATION PERMISSION FAILURE")
            }
        }
    }
    
    func subscribeToNotifications() {
        let recordType = CKRecord(recordType: "Fruits")
        let predicate = NSPredicate(value: true)
        let options: CKQuerySubscription.Options = [.firesOnRecordCreation]
        let subscription = CKQuerySubscription(recordType: recordType.recordType, predicate: predicate, subscriptionID: subscriptionID, options: options)
        let notification = CKSubscription.NotificationInfo()
        notification.title = "There's a new fruit!"
        notification.alertBody = "Open the app to check your fruit!"
        notification.soundName = "default"
        subscription.notificationInfo = notification
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let returnedError = returnedError {
                print(returnedError.localizedDescription)
            } else {
                print("SUCCESSFULLY SUBSCRIBE NOTIFICATION")
            }
        }
    }
    
    func unsubscribeToNotification() {
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: subscriptionID) { returnedID, returnedError in
            if let returnedError = returnedError {
                print(returnedError.localizedDescription)
            } else {
                print("SUCCESSFULLY UNSUBSCRIBE NOTIFICATION")
            }
        }
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
