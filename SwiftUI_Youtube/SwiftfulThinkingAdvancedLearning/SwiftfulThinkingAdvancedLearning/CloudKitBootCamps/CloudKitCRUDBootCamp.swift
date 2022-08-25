//
//  CloudKitCRUDBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/24.
//

import SwiftUI
import Combine

class CloudKitCRUDBootCampViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = []
    @Published var isUpdatingItem: Bool = false
    var selectedFruit: FruitModel? = nil
    var placeholder: String {
        isUpdatingItem ? "Update \(selectedFruit?.name ?? "Fruit") name with..." : "Add fruit name here..."
    }
    var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
        
        CloudKitUtility.fetch(predicate: predicate, recordType: "Fruits")
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] (returnedItems:[FruitModel]) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.fruits = returnedItems
                }
            }
            .store(in: &cancellables)
    }
    
    private func addItem(name: String) {
        guard
            let image = UIImage(named: "peach"),
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("peach.png"),
            let data = image.pngData() else { return }
        do {
            try data.write(to: url)
            guard let newFruit = FruitModel(name: name, imageURL: url) else { return }
            CloudKitUtility.add(item: newFruit) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.fetchItems()
                    self.text = ""
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateItem() {
        guard !text.isEmpty && isUpdatingItem, let fruit = selectedFruit, let newFruit = fruit.update(newName: text) else { return }
        isUpdatingItem = false
        CloudKitUtility.update(item: newFruit) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.text = ""
                self.fetchItems()
            }
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        CloudKitUtility.delete(item: fruit)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] success in
                print("DELETE IS: \(success)")
                guard let self = self else { return }
                self.fruits.remove(at: index)
            }
            .store(in: &cancellables)
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
                        HStack {
                            Text(fruit.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                            if let url = fruit.imageURL, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        .contentShape(Rectangle())
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
