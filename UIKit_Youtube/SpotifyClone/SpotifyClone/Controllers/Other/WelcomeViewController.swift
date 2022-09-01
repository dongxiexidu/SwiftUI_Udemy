//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setWelcomeViewUI()
    }
    
    private func setWelcomeViewUI() {
        title = "Spotify"
        view.backgroundColor = .systemGreen
    }
}
