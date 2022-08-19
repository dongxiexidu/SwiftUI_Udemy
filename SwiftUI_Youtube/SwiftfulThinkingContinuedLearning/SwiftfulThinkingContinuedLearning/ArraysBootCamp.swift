//
//  ArraysBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/19.
//

import SwiftUI

struct UserModel: Identifiable {
    let id = UUID().uuidString
    let name: String?
    let point: Int
    var isVerfied: Bool
}

class ArrayModificationViewModel: ObservableObject {
    @Published var dataArray: [UserModel] = []
    @Published var filteredArray: [UserModel] = []
    @Published var mappedArray: [String] = []
    
    init() {
        getUsers()
    }
    
    func getUsers() {
        let user1 = UserModel(name: "Junyeong Park", point: 100, isVerfied: true)
        let user2 = UserModel(name: nil, point: 90, isVerfied: true)
        let user3 = UserModel(name: "Noah", point: 70, isVerfied: false)
        let user4 = UserModel(name: nil, point: 80, isVerfied: true)
        let user5 = UserModel(name: "Noel", point: 56, isVerfied: true)
        let user6 = UserModel(name: "Joseph", point: 30, isVerfied: false)
        let user7 = UserModel(name: "Daniel", point: 0, isVerfied: true)
        let user8 = UserModel(name: "Dune", point: 20, isVerfied: false)
        let user9 = UserModel(name: "Mark", point: 10, isVerfied: true)
        let user10 = UserModel(name: "Tony", point: 1, isVerfied: true)
        dataArray.append(contentsOf: [user1, user2, user3, user4, user5, user6, user7, user8, user9, user10])
    }
    
    enum FilterType: String {
        case Sort = "sort"
        case Filter = "filter"
        case Map = "map"
        
        
    }
    
    func updateFilterArray(_ filterType: FilterType) {
        switch filterType {
        case .Sort:
            let sortedArray = dataArray.sorted(by: {$0.point >= $1.point})
            filteredArray = sortedArray
        case .Filter:
            let filteredArray = dataArray.filter{$0.point > 50}
            self.filteredArray = filteredArray
        case .Map:
            let mappedArray = dataArray.compactMap({$0.name})
            // compactMap -> String? excludes all of nil things out
            self.mappedArray = mappedArray
        }
    }
    
    func updateComplexFilterArray() {
        let filteredArray = dataArray.filter{$0.isVerfied}.sorted(by: {$0.point > $1.point}).compactMap({$0.name})
        self.mappedArray = filteredArray
    }
}

struct ArraysBootCamp: View {
    @StateObject private var viewModel = ArrayModificationViewModel()
    @State private var dataArray: [UserModel] = []
    @State private var mappedArray: [String] = []
    @State private var isMapped: Bool = false
    var body: some View {
        
        VStack {
            HStack {
                Button("Total") {
                    isMapped = false
                    dataArray = viewModel.dataArray
                }
                Button("Sorted") {
                    isMapped = false
                    viewModel.updateFilterArray(.Sort)
                    dataArray = viewModel.filteredArray
                }
                Button("Filtered") {
                    isMapped = false
                    viewModel.updateFilterArray(.Filter)
                    dataArray = viewModel.filteredArray
                }
                Button("Mapped") {
                    isMapped = true
                    viewModel.updateFilterArray(.Map)
                    mappedArray = viewModel.mappedArray
                }
                Button("Complex Mapped") {
                    isMapped = true
                    viewModel.updateComplexFilterArray()
                    mappedArray = viewModel.mappedArray
                }
            }
            ScrollView {
                VStack {
                    if isMapped {
                        ForEach(mappedArray, id:\.self) { name in
                            Text(name)
                                .font(.headline)
                        }
                    } else {
                        ForEach(dataArray) { user in
                            VStack {
                                Text(user.name ?? "")
                                    .font(.headline)
                                HStack {
                                    Text("Points : \(user.point)")
                                    Spacer()
                                    if user.isVerfied {
                                        Image(systemName: "flame.fill")
                                    }
                                }
                            }
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal)
                            .background(Color.blue.cornerRadius(10))
                        }
                    }
                }
            }
        }
    }
}

struct ArraysBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        ArraysBootCamp()
    }
}
