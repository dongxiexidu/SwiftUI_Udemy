//
//  CoreDataBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/19.
//

import SwiftUI
import CoreData

// VIEW - UI
// MODEL - Data Point
// VIEW MODEL - Manager between data and view

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities = [FruitEntity]()
    init () {
        container = NSPersistentContainer(name: "FruitsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING CORE DATA")
                print(error.localizedDescription)
            } else {
                print("SUCCESSFULLY LOAD CORE DATA")
            }
        }
        fetchFruits()
    }
    
    func fetchFruits() {
        let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("ERROR FETCHING CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func addFruit(name: String) {
        let fruit = FruitEntity(context: container.viewContext)
        fruit.name = name
        saveData()
    }
    
    func deleteFruit(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchFruits()
        } catch {
            print("ERROR SAVING CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func updateFruit(entity: FruitEntity, name: String) {
        entity.name = name
        saveData()
    }
}

struct CoreDataBootCamp: View {
    @StateObject private var viewModel = CoreDataViewModel()
    @State private var textFieldText: String = ""
    @State private var isAdd: Bool = true
    private var textFieldPlaceholder: String {
        return isAdd ? "Add New Fruit here..." : "Update Fruit name here..."
    }
    @State private var fruitEntity: FruitEntity? = nil
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField(textFieldPlaceholder, text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                Button(action: {
                    guard !textFieldText.isEmpty else { return }
                    if isAdd {
                        viewModel.addFruit(name: textFieldText)
                    } else {
                        guard let fruitEntity = fruitEntity else { return }
                        viewModel.updateFruit(entity: fruitEntity, name: textFieldText)
                    }
                    isAdd = true
                    textFieldText = ""
                }, label: {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .cornerRadius(10)
                        .padding(.horizontal)
                })
                List {
                    ForEach(viewModel.savedEntities) { entity in
                        Text(entity.name ?? "No Name")
                            .onTapGesture {
                                textFieldText = ""
                                isAdd = false
                                fruitEntity = entity
                            }
                    }
                    .onDelete(perform: viewModel.deleteFruit)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Fruits")
        }
    }
}

struct CoreDataBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataBootCamp()
    }
}
