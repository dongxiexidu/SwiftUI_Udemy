//
//  CloudKitCRUDBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/24.
//

import SwiftUI
import CloudKit

struct FruitModel: Identifiable {
    let id = UUID().uuidString
    let name: String
    let record: CKRecord
}

class CloudKitCRUDBootCampViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = []
    @Published var isUpdatingItem: Bool = false
    var selectedFruit: FruitModel? = nil
    var placeholder: String {
        isUpdatingItem ? "Update \(selectedFruit?.name ?? "Fruit") name with..." : "Add fruit name here..."
    }
    
    init() {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    private func addItem(name: String) {
        let newFruit = CKRecord(recordType: "Fruits")
        newFruit["name"] = name
        saveItem(record: newFruit)
    }
    
    private func saveItem(record: CKRecord) {
        CKContainer.default().database(with: .public).save(record) { returnedRecord, returnedError in
            print("Record: \(String(describing: returnedRecord))")
            print("Error: \(String(describing: returnedError))")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.text = ""
                self.fetchItems()
            }
        }
    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Fruits", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
        var returnedItems: [FruitModel] = []
        
        if #available(iOS 15, *) {
            queryOperation.recordMatchedBlock = { (returnedRecordId, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    guard let name = record["name"] as? String else { return }
                    returnedItems.append(FruitModel(name: name, record: record))
                    print(name)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            queryOperation.recordFetchedBlock = { returnedRecord in
                guard let name = returnedRecord["name"] as? String else { return }
                returnedItems.append(FruitModel(name: name, record: returnedRecord))
            }
        }
        if #available(iOS 15, *) {
            queryOperation.queryResultBlock = { [weak self] returnedResult in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.fruits = returnedItems
                }
                print("RETURNED RESULT: \(returnedResult)")
            }
        } else {
            queryOperation.queryCompletionBlock = { [weak self] (returnedCursor, returnedError) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.fruits = returnedItems
                }
                print("RETURNED queryCompletionBlock")
            }
        }
        addOperation(operation: queryOperation)
    }
    
    func updateItem() {
        guard !text.isEmpty && isUpdatingItem, let fruit = selectedFruit else { return }
        let record = fruit.record
        record["name"] = text
        isUpdatingItem = false
        saveItem(record: record)
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        let record = fruit.record
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { [weak self] returnedID, returnedError in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.fruits.remove(at: index)
            }
        }
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}

struct CloudKitCRUDBootCamp: View {
    @StateObject private var viewModel = CloudKitCRUDBootCampViewModel()
    var body: some View {
        NavigationView {
            VStack {
                header
                textField
                button
                List {
                    ForEach(viewModel.fruits) { fruit in
                        Text(fruit.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .onTapGesture {
                                viewModel.selectedFruit = fruit
                                viewModel.isUpdatingItem = true
                            }
                    }
                    .onDelete(perform: viewModel.deleteItem)
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

extension CloudKitCRUDBootCamp {
    private var header: some View {
        Text("CloudKit CRUD ☁☁☁")
            .font(.headline)
            .underline()
    }
    private var textField: some View {
        TextField(viewModel.placeholder, text: $viewModel.text)
            .frame(height: 55)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
    private var button: some View {
        Button {
            viewModel.isUpdatingItem ? viewModel.updateItem() : viewModel.addButtonPressed()
        } label: {
            Text(viewModel.isUpdatingItem ? "UPDATE" : "ADD")
                .font(.headline)
                .foregroundColor(.black)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.pink.opacity(0.4))
                .cornerRadius(10)
        }
    }
}

struct CloudKitCRUDBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitCRUDBootCamp()
    }
}
