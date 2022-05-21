//
//  Shop.swift
//  Touchdown_SwfitUI
//
//  Created by Junyeong Park on 2022/05/21.
//

import Foundation

class Shop: ObservableObject {
    // change of @published var in ObservableObject would be checked in View as well.
    @Published var showingProduct: Bool = false
    @Published var selectedProduct: Product? = nil
    // optional property
    
    
}
