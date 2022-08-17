//
//  Sendables.swift
//  SwiftConcurrency
//
//  Created by Junyeong Park on 2022/08/17.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: MyClassUserInfo) {
        
    }
}

struct MyUserInfo: Sendable {
    var name: String
    // Struct -> Value type, thread safe!
    // in that stack you can split that register / stack from the heap you share with others
}

final class MyClassUserInfo: @unchecked Sendable {
    // if you make class sendable you have to name this class as final class - no other class can inherit this class.
    // unchecked -> very dangerous way!
    private var name: String
    // this property cannot change -> thread safe! if another access from multi thread environment cannot change this data if data has benn set before.
    let queue = DispatchQueue(label: "com.JunyeongPark.MyClassUserInfo")
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
    // thread safe!
}

class SendablesViewModel: ObservableObject {
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        let userInfo = MyClassUserInfo(name: "User Info")
        await manager.updateDatabase(userInfo: userInfo)
    }
    
}

struct Sendables: View {
    @StateObject private var viewModel = SendablesViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Sendables_Previews: PreviewProvider {
    static var previews: some View {
        Sendables()
    }
}
