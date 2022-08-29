//
//  SendableBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/29.
//

import SwiftUI

actor SendableBootCampActor {
    
    func updateDataFromDatabase(userInfo: SendableBootCampUserInfoStruct) {
        // Update Data
    }
    func updateDataFromDatabase2(userInfo: SendableBootCampUserInfoClass) {
        // Update Data
    }
}

struct SendableBootCampUserInfoStruct: Sendable {
    // Value Type Struct -> Thread Safe
    let name: String
    var name2: String = ""
    /*
     var -> can be sendable
     */
}

struct SendableBootCampUserInfoStruct2 {
    let name: String
    var name2: String = ""
    // Whether or not using Sendable keyword, it would be sendable
    // but using Sendable protocol keyword, its performance would be better
}

/*
 if class -> Sendable, then ...
 Non-final class 'SendableBootCampUserInfoClass' cannot conform to 'Sendable'; use '@unchecked Sendable'
 */
final class SendableBootCampUserInfoClass: Sendable {
    let name: String
    /*
     if name -> var, then ...
     Stored property 'name' of 'Sendable'-conforming class 'SendableBootCampUserInfoClass' is mutable
     */
    init(name: String) {
        self.name = name
    }
}

/*
 even though you do not use keyword final class or let, they would be sendable confirmed using @unchecked but also very dangerous
 */

class SendalbeBootCampUserInfoClass2: @unchecked Sendable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

final class SendableBootCampUserInfoClass3: @unchecked Sendable {
    private var name: String
    let queue = DispatchQueue(label: "CustomQueue")
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
    // ensure thread-safety using custom queue(lock)
}

class SendableBootCampViewModel: ObservableObject {
    let dataService = SendableBootCampActor()
    
    func updateDataFromDatabase() async {
        let userInfo = SendableBootCampUserInfoStruct(name: "User Info")
        await dataService.updateDataFromDatabase(userInfo: userInfo)
    }
    func updateDataFromDatabase2() async {
        let userInfo = SendableBootCampUserInfoClass(name: "User Info")
        await dataService.updateDataFromDatabase2(userInfo: userInfo)
    }
}

struct SendableBootCamp: View {
    @StateObject private var viewModel = SendableBootCampViewModel()
    var body: some View {
        Text("Sendable Protocol Usage")
            .task {
                await viewModel.updateDataFromDatabase()
            }
    }
}

struct SendableBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        SendableBootCamp()
    }
}
