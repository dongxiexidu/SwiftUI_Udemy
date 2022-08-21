//
//  GenericsBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/21.
//

import SwiftUI

struct StringModel {
    let info: String?
    
    func removeInfo() -> StringModel {
        StringModel(info: nil)
    }
}

struct BoolModel {
    let info: Bool?
    
    func removeInfo() -> BoolModel {
        BoolModel(info: nil)
    }
}

struct GenericModel<T> {
    let info: T?
    
    func removeInfo() -> GenericModel {
        GenericModel(info: nil)
    }
}

class GenericsViewModel: ObservableObject {
    @Published var stringModel = StringModel(info: "HELLO WORLD!")
    @Published var boolModel = BoolModel(info: true)
    @Published var genericStringModel = GenericModel(info: "Hello World!")
    @Published var genericBoolModel = GenericModel(info: true)

    func removeData() {
        stringModel = stringModel.removeInfo()
        boolModel = boolModel.removeInfo()
        genericStringModel = genericStringModel.removeInfo()
        genericBoolModel = genericBoolModel.removeInfo()
    }
}

struct GenericView<T:View>: View {
    let content: T
    let title: String
    var body: some View {
        VStack {
            Text(title)
            content
        }
    }
}

struct GenericsBootCamp: View {
    @StateObject private var viewModel = GenericsViewModel()
    var body: some View {
        VStack {
            GenericView(content: MatchedGeometryEffect(), title: "NEW VIEW!")
            Text(viewModel.stringModel.info ?? "NO DATA")
                .onTapGesture {
                    viewModel.removeData()
                }
            Text(viewModel.boolModel.info?.description ?? "NO DATA")
                .onTapGesture {
                    viewModel.removeData()
                }
            Text(viewModel.genericStringModel.info ?? "NO DATA")
                .onTapGesture {
                    viewModel.removeData()
                }
            Text(viewModel.genericBoolModel.info?.description ?? "NO DATA")
                .onTapGesture {
                    viewModel.removeData()
                }
        }
    }
}

struct GenericsBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        GenericsBootCamp()
    }
}
