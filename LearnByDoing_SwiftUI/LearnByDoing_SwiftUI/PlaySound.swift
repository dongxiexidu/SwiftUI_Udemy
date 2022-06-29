//
//  PlaySound.swift
//  LearnByDoing_SwiftUI
//
//  Created by Junyeong Park on 2022/06/30.
//

import Foundation
import AVFoundation

// MARK: - AUDIO PLAYER

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not find any play the sound file.")
        }
    }
}
