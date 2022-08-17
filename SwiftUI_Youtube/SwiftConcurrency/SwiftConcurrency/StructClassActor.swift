//
//  StructClassActor.swift
//  SwiftConcurrency
//
//  Created by Junyeong Park on 2022/08/16.
//


/*
 Value Type:
 - Struct, Enum, String, Int, etc.
 - Stored in the stack
 - Faster
 - Thread Safe
 - When you assign or pass value type a new copy of data is created
 
 Referecen Type:
 - Class, Function, Actor
 - Stored in the Heap
 - Slower, but synchronized
 - Not Thread Safe
 - When you assign or pass reference type a new reference to original instance will be created pointer
 
 Stack:
 - Most of Valus Types are stored in Stack
 - Variables allocated on the stack are stored directly to the memory, and access to memory will be faster than heap
 - Each thread has it's own stack!
 
 Heap:
 - Stores Reference types
 - Shared accross threads!
 - In case of Class -> Not Thread safe so use actor if you worry about the synchronization issue
 
 Struct
 - Based on Values
 - Can be mutated
 - Stored in the Stack!
 
 Class
 - Based on Referecnes. Instances
 - Stored in the Heap!
 - Inherit from other classes
 
 Actor:
 - Same as Class but thread safe!
 - Using await/async enviornment you can get multiple access on some like class safe
 
 Structs: Data Models -> Much Faster than Class. Great Data Model to be used in App
 
 View: Struct using Protocol View!
 
 ViewModel: ObservableClass
 
 Actors: Shared "Manager" and "data Store"
 
 MVVM: View, ViewModel, Data
 
 SwiftUI: View Protocol as Struct -> View Rendering all of time if you change some values so make it split!
 
 UIKit: ViewController -> View Rendering as Class so it woul be slower than SwiftUI 
 */

import SwiftUI

actor StructClassActorDataManager {
    // // used in multiple viewModels but dataManager is same! -> Make this Singleton.
    
    
    func getDataFromDatabase() {
        
    }
}

class StructClassActorViewModel: ObservableObject {
    @Published var title: String = ""
}

struct StructClassActor: View {
    @StateObject private var viewModel = StructClassActorViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("INIT VIEWMODEL!")
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .foregroundColor(isActive ? .red : .blue)
            .onAppear {
                runTest()
            }
    }
}

struct StructClassHome: View {
    @State private var isActive: Bool = false
    var body: some View {
        StructClassActor(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

//struct StructClassActor_Previews: PreviewProvider {
//    static var previews: some View {
//        StructClassActor()
//    }
//}

struct MyStruct {
    var title: String
}

class MyClass {
    var title: String
    init(title: String) {
        self.title = title
        print("\(title) is inited!")
    }
    
    func updatingTitle(title: String) {
        self.title = title
    }
    
    deinit {
        print("\(title) is deinited!")
    }
}

extension StructClassActor {
    private func runTest() {
        print("RUN TEST")
//        structTest1()
//        classTest1()
//        structTest2()
//        classTest2()
        actorTest1()
    }
    
    private func structTest1() {
        let objectA = MyStruct(title: "Starting Title!")
        print("ObjectA : \(objectA.title)")
        
        print("Pass values of objectA to the objectB")
        
        var objectB = objectA
        print("ObjectB : \(objectB.title)")
        objectB.title = "Second Title!"
        print("ObjectA : \(objectA.title)")
        print("ObjectB : \(objectB.title)")
        printDivider()
    }
    
    private func printDivider() {
        print()
        print("------------------------------")
        print()
    }
    
    private func classTest1() {
        let objectA = MyClass(title: "Starting Title!")
        print("objectA : \(objectA.title)")
        let objectB = objectA
        print("objectB : \(objectB.title)")
        print("Pass the Reference of objectA to the objectB, exactly same object in same memory!")
        
        objectB.title = "Second Title!"
        print("ObjectA : \(objectA.title)")
        print("ObjectB : \(objectB.title)")
        printDivider()
    }
}

struct CustomStruct {
    let title: String
    // Immutable variable let
    
//    mutating func updatingTitle(title: String) {
//        self.title = title
//    }
    func updatingTitle(title: String) -> CustomStruct {
        return CustomStruct(title: title)
    }
}

struct MutableStruct {
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func printTitle() {
        print(title)
    }
    
    mutating func updatingTitle(title: String) {
        self.title = title
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updatingTitle(title: String) {
        self.title = title
    }
}

extension StructClassActor {
    private func structTest2() {
        print("StructTest2")
        
        var struct1 = MyStruct(title: "Title1")
        print(struct1.title)
        struct1.title = "Title2"
        print(struct1.title)
        var struct2 = CustomStruct(title: "Title2")
        print(struct2.title)
        struct2 = CustomStruct(title: "Title3")
        print(struct2.title)
        struct2 = struct2.updatingTitle(title: "Title4")
        print(struct2.title)
        var struct3 = MutableStruct(title: "Title5")
        struct3.printTitle()
        struct3.updatingTitle(title: "Title6")
        struct3.printTitle()
    }
}

extension StructClassActor {
    private func classTest2() {
//        print("classTest2")
//        let class1 = MyClass(title: "title1")
//        print(class1.title)
//        class1.title = "aaa"
//        print(class1.title)
//        class1.updatingTitle(title: "AAA")
//        print(class1.title)
        var class1 = MyClass(title: "title1")
        printDivider()
    }
    
    private func actorTest1() {
        Task {
            let objectA = MyActor(title: "Starting title!")
            await print("objectA : \(objectA.title)")
            
            let objectB = objectA
            await print("objectB : \(objectB.title)")
            
            await objectB.updatingTitle(title: "aaa")
            await print("objectB : \(objectB.title)")
        }
    }
}
