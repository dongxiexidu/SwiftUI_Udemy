//
//  ViewController.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeViewUI()
    }
    
    private func setHomeViewUI() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
    }
    
    @objc private func didTapSettings() {
        let profileVC = SettingsViewController()
        profileVC.title = "Setting"
        profileVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(profileVC, animated: true)
    }


}

