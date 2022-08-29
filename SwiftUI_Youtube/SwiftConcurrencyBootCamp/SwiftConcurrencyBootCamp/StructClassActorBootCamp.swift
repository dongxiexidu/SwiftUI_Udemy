//
//  StructClassActorBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/29.
//

import SwiftUI

actor StructClassActorBootCampDataManager {
    
    init() {
        print("StructClassActorBootCampDataManager Init")
    }
    
    deinit {
        print("StructClassActorBootCampDataManager Deinit")
    }
    
    func getDataFromDatabase() {
        
    }
}

class StructClassActorBootCampViewModel: ObservableObject {
    @Published var title: String = ""
    let dataManager: StructClassActorBootCampDataManager
    
    init(dataManager: StructClassActorBootCampDataManager) {
        self.dataManager = dataManager
        print("StructClassActorBootCampViewModel Init")
    }
    
    deinit {
        print("StructClassActorBootCampViewModel Deinit")
    }
}

struct StructClassActorBootCamp: View {
    @StateObject private var viewModel = StructClassActorBootCampViewModel(dataManager: StructClassActorBootCampDataManager())
    // -> ObservableObject class: Init ...
    // Even if this entire struct View would be re-rendered, its StateObject would be same
    // @ObservedObject private var viewModel = StructClassActorBootCampViewModel()
    // -> ObservableObject class: Init and Deinit ...

    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View Init, isActive : \(isActive)")
        /*
         View Init, isActive : true
         View Init, isActive : false
         View Init, isActive : true
         View Init, isActive : false
         ... -> Whenever isActive toggled, this View has been initiated.
         */
    }
    
    var body: some View {
        Text(viewModel.title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? .red : .blue)
            .onAppear {
                runTest()
            }
    }
}

struct StructClassActorBootCampHomeView: View {
    @State private var isActive: Bool = false
    var body: some View {
        StructClassActorBootCamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}


struct CustomStruct {
    var title: String
    // Default Initializer from Swift
}

struct CustomStruct2 {
    var title: String
    
    func makeNewStruct(_ title: String) -> CustomStruct2 {
        return CustomStruct2(title: title)
    }
    
    mutating func updateTitle(_ title: String) {
        self.title = title
    }
}

struct CustomStruct3 {
    private var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func getTitle() -> String {
        return title
    }
    
    mutating func setTitle(_ title: String) {
        self.title = title
    }
}

class CustomClass {
    var title: String
    init(title: String) {
        self.title = title
    }
    func updateTitle(_ title: String) {
        self.title = title
    }
}

class CustomClass2 {
    var title: String
    init(title: String) {
        self.title = title
        print("\(title) is initiated")
    }
    
    deinit {
        print("\(title) is deinitiated")
    }
}

class StrongClass1 {
    var title: String
    var strongClass2: StrongClass2?
    var weakClass: WeakClass?
    
    init(title: String, strongClass2: StrongClass2? = nil, weakClass: WeakClass? = nil) {
        self.title = title
        self.strongClass2 = strongClass2
        self.weakClass = weakClass
        print("\(title) is initiated")
    }
    
    deinit {
        print("\(title) is deinitiated")
    }
}

class StrongClass2 {
    var title: String
    var strongClass1: StrongClass1?
    
    init(title: String, strongClass1: StrongClass1? = nil) {
        self.title = title
        self.strongClass1 = strongClass1
        print("\(title) is initiated")
    }
    
    deinit {
        print("\(title) is deinitiated")
    }
}

class WeakClass {
    var title: String
    weak var strongClass1: StrongClass1?
    
    init(title: String, strongClass1: StrongClass1? = nil) {
        self.title = title
        self.strongClass1 = strongClass1
        print("\(title) is initiated")
    }
    
    deinit {
        print("\(title) is deinitiated")
    }
}

actor CustomActor {
    var title: String
    // to be updated
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(_ title: String) {
        self.title = title
    }
}

extension StructClassActorBootCamp {
    private func runTest() {
        actorTest()
    }
    
    private func structTest1() {
        let objectA = CustomStruct(title: "Starting Title")
        print("ObjectA : \(objectA.title)")
        print("Pass the VALUE of objectA to objectB")
        var objectB = objectA
        print("ObjectB : \(objectB.title)")
        // ObjectA : Starting Title
        // ObjectB : Starting Title
        objectB.title = "Second Title"
        // let title -> var title, let objectB -> var objectB. complier changes it
        print("ObjectB title changed")
        print("ObjectA : \(objectA.title)")
        print("ObjectB : \(objectB.title)")
        // ObjectA : Starting Title
        // ObjectB : Second Title -> ObjectA <-> ObjectB not referencing themselves. (: Value Type)
    }
    private func classTest1() {
        let objectA = CustomClass(title: "Starting Title")
        print("ObjectA : \(objectA.title)")
        print("Pass the REFERENCE of objectA to objectB")
        let objectB = objectA
        print("ObjectB : \(objectB.title)")
        // ObjectA : Starting Title
        // ObjectB : Starting Title
        objectB.title = "Second Title"
        // let title -> var title. complier changes it: not 'let' objectB.
        print("ObjectB title changed")
        print("ObjectA : \(objectA.title)")
        print("ObjectB : \(objectB.title)")
        // ObjectA : Second Title
        // ObjectB : Second Title -> ObjectA === ObjectB referencing same place (: Reference Type)
        print(objectA === objectB)
        // true
    }
}

extension StructClassActorBootCamp {
    private func structTest2() {
        var struct1 = CustomStruct(title: "Title1")
        print("Struct1: \(struct1.title)")
        struct1.title = "Title2"
        print("Struct1: \(struct1.title)")
        // Struct1: Title1
        // Struct1: Title2
        var struct2 = CustomStruct2(title: "Title1")
        print("Struct2 : \(struct2.title)")
        struct2 = CustomStruct2(title: "Title2")
        // totally new struct assigned
        print("Struct2 : \(struct2.title)")
        // struct2.title : Title1
        // struct2.title : Title2
        struct2 = struct2.makeNewStruct("New Title")
        print("Struct2 : \(struct2.title)")
        // struct2.title : New Title
        // Totally new Structure
        struct2.updateTitle("Title3")
        // Mutating function
        print("Struct2 : \(struct2.title)")
        // struct2.title : Title3
    }
    
    private func structTest3() {
        var struct1 = CustomStruct3(title: "Title1")
        var title = struct1.getTitle()
        print(title)
        // Title1
        struct1.setTitle("Title2")
        title = struct1.getTitle()
        print(title)
        // Title2
        
        // get, set method to handle data inside struct
    }
}
extension StructClassActorBootCamp {
    private func classTest2() {
        let class1 = CustomClass(title: "Title1")
        print("Class1 : \(class1.title)")
        // Class1 : Title1
        class1.updateTitle("Title2")
        print("Class1 : \(class1.title)")
        // Class1 : Title2
        // Does not have to set "mutating" keyward inside Class
    }
}

extension StructClassActorBootCamp {
    private func classTest3() {
        var class1: CustomClass2?
        class1 = CustomClass2(title: "New Class")
        // New Class is initiated
        // Reference Count : 1
        class1 = nil
        // Reference Count : 0 -> Deinit. Deallocated from Memory
        // New Class is deinitiated
    }
    private func classTest4() {
        var class1:StrongClass1? = StrongClass1(title: "Strong Class1")
        var class2:StrongClass2? = StrongClass2(title: "Strong Class2")
        // Strong Class1 is initiated
        // Strong Class2 is initiated
        class1?.strongClass2 = class2
        class2?.strongClass1 = class1
        class1?.strongClass2 = nil
        class2?.strongClass1 = nil
        class1 = nil
        class2 = nil
        // Strong Class1 is deinitiated
        // Strong Class2 is deinitiated
        
        class1 = StrongClass1(title: "Strong Class1")
        class2 = StrongClass2(title: "Strong Class2")
        // Strong Class1 is initiated
        // Strong Class2 is initiated
        class1?.strongClass2 = class2
        class2?.strongClass1 = class1
        class1 = nil
        class2 = nil
        // Still Strong reference cycle retained -> Memory leaking
    }
    
    private func classTest5() {
        var class1:StrongClass1? = StrongClass1(title: "Strong Class1")
        var class2:WeakClass? = WeakClass(title: "Weak Class")
        // Strong Class1 is initiated
        // Weak Class is initiated
        class1?.weakClass = class2
        class2?.strongClass1 = class1
        class1 = nil
        class2 = nil
        // Strong Class1 is deinitiated
        // Weak Class is deinitiated
        // strongClass1 inside class2(Weak Class instance) -> nil, then ARC -> 0, then class1 -> deinit
        // weak reference -> make its non-having strong reference less than strong reference
    }
    
    private func actorTest() {
        Task {
            // Need to get async -> Call them inside 'Task' block
            var actor1 = CustomActor(title: "Actor1")
            await print("Actor1 title : \(actor1.title)")
            // Actor1 title : Actor1
            
            // actor1.title = "Actor2" -> Ban
            // Actor-isolated property 'title' can not be mutated from a non-isolated context
            await actor1.updateTitle("Actor2")
            await print("Actor1 title : \(actor1.title)")
            // Actor1 title : Actor2
        }
    }
}
