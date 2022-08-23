//
//  UnitTestingBootCampView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/22.
//

/*
1. UNIT TEST
 - test the business logic in the app, not the UI things
2. UI TEST
 - tests the UI of the app
*/
import SwiftUI

struct UnitTestingBootCampView: View {
    @StateObject private var viewModel: UnitTestingBootCampViewModel
    
    init(isPremium: Bool) {
        _viewModel = StateObject(wrappedValue: UnitTestingBootCampViewModel(isPremium: isPremium))
    }
    var body: some View {
        Text(viewModel.isPremium.description)
    }
}

struct UnitTestingBootCampView_Previews: PreviewProvider {
    static var previews: some View {
        UnitTestingBootCampView(isPremium: true)
    }
}
