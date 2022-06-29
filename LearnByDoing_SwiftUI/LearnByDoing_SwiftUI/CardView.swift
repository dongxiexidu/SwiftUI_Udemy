//
//  CardView.swift
//  LearnByDoing_SwiftUI
//
//  Created by Junyeong Park on 2022/06/04.
//

import SwiftUI

struct CardView: View {
    // MARK: - PROPERTY
    
    let card: Card
    
    @State private var fadeIn: Bool = false
    
    // MARK: - CARD
    var body: some View {
        ZStack {
            Image(card.imageName)
                .opacity(fadeIn ? 1.0 : 0.0)
            
            VStack {
                Text(card.title)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text(card.headline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .italic()
            }
            .offset(y: -218)
            
            Button(action: {
                print("action tapped")
                playSound(sound: "sound-chime", type: "mp3")
            }, label: {
                HStack {
                    Text(card.callToAction.uppercased())
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    .tint(.white)
                    
                    Image(systemName: "arrow.right.circle")
                        .font(Font.title.weight(.medium))
                        .tint(.white)
                }
                .padding(.vertical)
                .padding(.horizontal, 24)
                .background(LinearGradient(gradient: Gradient(colors: card.gradientColors), startPoint: .leading, endPoint: .trailing))
                .clipShape(Capsule())
                .shadow(color: Color("ColorShadow"), radius: 6, x: 0, y: 3)
            })
            .offset(y: 210)
        }
        .frame(width: 335, height: 545)
        .background(LinearGradient(gradient: Gradient(colors: card.gradientColors), startPoint: .top, endPoint: .bottom))
        .cornerRadius(16)
        .shadow(radius: 8)
        .onAppear {
            withAnimation(.linear(duration: 0.2)) {
                fadeIn.toggle()
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: cardData[0])
            .previewLayout(.sizeThatFits)
    }
}
