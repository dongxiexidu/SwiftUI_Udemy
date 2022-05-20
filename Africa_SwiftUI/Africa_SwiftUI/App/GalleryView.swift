//
//  GalleryView.swift
//  Africa_SwiftUI
//
//  Created by Junyeong Park on 2022/05/17.
//

import SwiftUI

struct GalleryView: View {
    
    @State private var selectedAnimal: String = "lion"
    let animals: [Animal] = Bundle.main.decode("animals.json")
    
//    let gridLayout: [GridItem] = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
    
//    let gridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @State private var gridColumn: Double = 3.0
    @State private var isAnimating: Bool = false
    
    func gridSwitch() {
        gridLayout = Array(repeating: .init(.flexible()), count: Int(gridColumn))
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // MARK: - GRID
            VStack(alignment: .center, spacing: 30) {
                Image(selectedAnimal)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 8))
                
                Slider(value: $gridColumn, in: 2...4, step: 1)
                    .padding(.horizontal)
                    .onChange(of: gridColumn, perform: {
                        value in
                        gridSwitch()
                        isAnimating.toggle()
                    })
                
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                    ForEach(animals) { animal in
                        Image(animal.image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            .onTapGesture {
                                selectedAnimal = animal.image
                            }
                    }
                }
                .animation(.easeOut, value: isAnimating)
                .onAppear{
                    gridSwitch()
                    isAnimating.toggle()
                }
                .padding(.horizontal, 10)
            .padding(.vertical, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(MotionAnimationView())
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
