//
//  CloudKitUtility.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/25.
//

import SwiftUI
import CloudKit
import Combine
import UserNotifications

class CloudKitUtility {
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountUnavailable
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
        case iCloudAppicationPermissionNotGranted
        case iCloudCouldNotFetchUserRecordIC
        case iCloudCouldNotDiscoverUser
    }
}

// MARK: USER FUNCTIONS
extension CloudKitUtility {
    static private func getiCloudStatus(completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async {
                switch status {
                case .couldNotDetermine:
                    completionHandler(.failure(CloudKitError.iCloudAccountNotDetermined))
                case .available:
                    completionHandler(.success(true))
                case .restricted:
                    completionHandler(.failure(CloudKitError.iCloudAccountRestricted))
                case .noAccount:
                    completionHandler(.failure(CloudKitError.iCloudAccountNotFound))
                    break
                case .temporarilyUnavailable:
                    completionHandler(.failure(CloudKitError.iCloudAccountUnavailable))
                @unknown default:
                    completionHandler(.failure(CloudKitError.iCloudAccountUnknown))
                }
            }
        }
    }
    
    static func getiCloudStatus() -> Future<Bool, Error> {
        Future { promise in
            CloudKitUtility.getiCloudStatus { result in
                promise(result)
            }
        }
    }
    
    static private func requestAplicationPermission(completionHandler: @escaping((Result<Bool, Error>) -> ())) {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { returnedStatus, returnedError in
            if returnedStatus == .granted {
                completionHandler(.success(true))
            } else {
                completionHandler(.failure(CloudKitError.iCloudAppicationPermissionNotGranted))
            }
        }
    }
    
    static func getApplicationPermission() -> Future<Bool, Error> {
        Future { promise in
            requestAplicationPermission { result in
                promise(result)
            }
        }
    }
    
    static private func fetchUserRecordId(completionHandler: (@escaping ((Result<CKRecord.ID, Error>) -> ()))) {
        CKContainer.default().fetchUserRecordID { returnedId, returnedError in
            if let id = returnedId {
                completionHandler(.success(id))
            } else {
                completionHandler(.failure(CloudKitError.iCloudCouldNotFetchUserRecordIC))
            }
        }
    }
    
    static private func discoverUserIdentity(id: CKRecord.ID, completionHandler: (@escaping ((Result<String, Error>) -> ()))) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    completionHandler(.success(name))
                } else {
                    completionHandler(.failure(CloudKitError.iCloudCouldNotDiscoverUser))
                }
            }
        }
    }
    
    static func discoverUserIdentity(completion: @escaping (Result<String, Error>) -> ()) {
        fetchUserRecordId { fetchCompletion in
            switch fetchCompletion {
            case .success(let recordID):
                discoverUserIdentity(id: recordID, completionHandler: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func discoverUserIdentity() -> Future<String, Error> {
        Future { promise in
            discoverUserIdentity { result in
                promise(result)
            }
        }
    }
}

// MARK: CRUD FUNCTIONS
extension CloudKitUtility {
    
    static func createOperation(predicate: NSPredicate,
                                recordType: CKRecord.RecordType,
                                sortDescriptors: [NSSortDescriptor]? = nil,
                                resultsLimit: Int? = nil) -> CKQueryOperation {
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        let queryOperation = CKQueryOperation(query: query)
        if let resultsLimit = resultsLimit {
            queryOperation.resultsLimit = resultsLimit
        }
        return queryOperation
    }
    
    static func fetch<T:CloudKitableProtocol>(predicate: NSPredicate,
                      recordType: CKRecord.RecordType,
                      sortDescriptors: [NSSortDescriptor]? = nil,
                      resultsLimit: Int? = nil) -> Future<[T], Error> {
        Future { promise in
            fetch(predicate: predicate, recordType: recordType) { (items:[T]) in
                promise(.success(items))
            }
        }
    }
    
    static func fetch<T:CloudKitableProtocol>(predicate: NSPredicate,
                      recordType: CKRecord.RecordType,
                      sortDescriptors: [NSSortDescriptor]? = nil,
                      resultsLimit: Int? = nil,
                      completionHandler: @escaping (_ items: [T]) -> ()) {
        // Execute operation
        let operation = createOperation(predicate: predicate, recordType: recordType, sortDescriptors: sortDescriptors, resultsLimit: resultsLimit)
        // Get items in query
        var returnedItems = [T]()
        addRecordMatchedBlock(queryOperation: operation) { item in
            returnedItems.append(item)
        }
        // Query completion
        addQueryResultBlock(queryOperation: operation) { finished in
            completionHandler(returnedItems)
        }
        add(operation: operation)
    }
    
    static func addRecordMatchedBlock<T:CloudKitableProtocol>(queryOperation: CKQueryOperation, completionHandelr: @escaping (_ item: T) -> ()) {
        if #available(iOS 15, *) {
            queryOperation.recordMatchedBlock = { (returnedRecordId, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    guard let item = T(record: record) else { return }
                    completionHandelr(item)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        } else {
            queryOperation.recordFetchedBlock = { returnedRecord in
                guard let item = T(record: returnedRecord) else { return }
                completionHandelr(item)
            }
        }
    }
    
    static private func addQueryResultBlock(queryOperation: CKQueryOperation, completionHandler: (@escaping (_ finished: Bool) -> ())) {
        if #available(iOS 15, *) {
            queryOperation.queryResultBlock = { returnedResult in
                completionHandler(true)
            }
        } else {
            queryOperation.queryCompletionBlock = { (returnedCursor, returnedError) in
                completionHandler(true)
            }
        }
    }
    
    static func add(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    static func add<T:CloudKitableProtocol>(item: T, completionHandler: @escaping(Result<Bool, Error>) -> ()) {
        let record = item.record
        // Save to CloudKit
        save(record: record, completionHandler: completionHandler)
    }
    
    static func update<T:CloudKitableProtocol>(item: T, completionHandler: @escaping(Result<Bool, Error>) -> ()) {
        add(item: item, completionHandler: completionHandler)
    }
    
    static func save(record: CKRecord, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.save(record) { (returnedRecord, returnedError) in
            if let returnedError = returnedError {
                completionHandler(.failure(returnedError))
            } else {
                completionHandler(.success(true))
            }
            
        }
    }
    
    static func delete<T:CloudKitableProtocol>(item: T) -> Future<Bool, Error> {
        Future { promise in
            CloudKitUtility.delete(item: item, completionHandler: promise)
        }
    }
    
    static func delete<T:CloudKitableProtocol>(item: T, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        delete(record: item.record, completionHandler: completionHandler)
    }
    
    static private func delete(record: CKRecord, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { returnedID, returnedError in
            if let returnedError = returnedError {
                completionHandler(.failure(returnedError))
            } else {
                completionHandler(.success(true))
            }
        }
    }
}

// MARK: PUSH NOTIFICATION FUNCTIONS
extension CloudKitUtility {
    static private func requestNotificationPermission(options: UNAuthorizationOptions, completionHandler: (@escaping (Result<Bool, Error>) -> ())) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { bool, error in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                completionHandler(.success(true))
            }
        }
    }
    
    static func requestNotificationPermission(options: UNAuthorizationOptions = [.alert, .sound, .badge]) -> Future<Bool, Error> {
        Future { promise in
            CloudKitUtility.requestNotificationPermission(options: options) { result in
                promise(result)
            }
        }
    }
    
    static private func subscribeToNotification(recordType: String, predicate: NSPredicate, options: CKQuerySubscription.Options, subscriptionID: String, title: String, alertBody: String, soundName: String, completionHandler: (@escaping (Result<Bool, Error>) -> ())) {
        let subscription = CKQuerySubscription(recordType: recordType, predicate: predicate, subscriptionID: subscriptionID, options: options)
        let notification = CKSubscription.NotificationInfo()
        notification.title = title
        notification.alertBody = alertBody
        notification.soundName = soundName
        subscription.notificationInfo = notification
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let returnedError = returnedError {
                completionHandler(.failure(returnedError))
            } else {
                completionHandler(.success(true))
            }
        }
    }
    
    static func subscribeToNotification (recordType: String, predicate: NSPredicate = NSPredicate(value: true), options: CKQuerySubscription.Options = [.firesOnRecordCreation], subscriptionID: String, title: String = "There's a new fruit here!", alertBody: String = "Open the app and check it out", soundName: String = "defaut") -> Future<Bool, Error> {
        Future { promise in
            subscribeToNotification(recordType: recordType, predicate: predicate, options: options, subscriptionID: subscriptionID, title: title, alertBody: alertBody, soundName: soundName) { result in
                promise(result)
            }
        }
    }
    
    static private func unsubsribeToNotification(subscriptionID: String, completionHandler: (@escaping (Result<Bool, Error>) -> ())) {
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: subscriptionID) { returnedID, returnedError in
            if let returnedError = returnedError {
                completionHandler(.failure(returnedError))
            } else {
                completionHandler(.success(true))
            }
        }
    }
    
    static func unsubsribeToNotification(subscriptionID: String) -> Future<Bool, Error> {
        Future { promise in
            unsubsribeToNotification(subscriptionID: subscriptionID) { result in
                promise(result)
            }
        }
    }
}

