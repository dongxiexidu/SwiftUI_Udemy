//
//  SoundEffectsBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/18.
//

import SwiftUI
import AVKit

class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case rainfall = "rainfall"
        case medieval = "medieval"
    }
    
    func playSound(sound: SoundOption) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}

struct SoundEffectsBootCamp: View {
    private let soundManager = SoundManager.instance
    var body: some View {
        VStack(spacing: 40) {
            Button("Play Sound 1") {
                soundManager.playSound(sound: .rainfall)
            }
            Button("Play Sound 2") {
                soundManager.playSound(sound: .medieval)
            }
        }
    }
}

struct SoundEffectsBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        SoundEffectsBootCamp()
    }
}
