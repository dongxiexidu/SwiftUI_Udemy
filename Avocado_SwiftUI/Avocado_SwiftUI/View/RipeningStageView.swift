//
//  RipeningStageView.swift
//  Avocado_SwiftUI
//
//  Created by Junyeong Park on 2022/07/03.
//

import SwiftUI

struct RipeningStageView: View {
    let ripeningStage: [Ripening] = ripeningData
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack {
                HStack(alignment: .center, spacing: 25) {
                    ForEach(ripeningStage) { item in
                        RipeningView(ripening: item)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 25)
                Spacer()
            }
        }
    }
}

struct RipeningStageView_Previews: PreviewProvider {
    static var previews: some View {
        RipeningStageView()
    }
}
