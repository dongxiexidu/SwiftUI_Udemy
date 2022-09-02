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
        fetchData()
    }
    
    private func setHomeViewUI() {
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
    }
    
    private func fetchData() {
//        APICaller.shared.getNewReleases { result in
//            switch result {
//            case .success(let model):
//                print(model)
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//                break
//            }
//        }
//        APICaller.shared.getFeaturedPlaylists { result in
//            switch result {
//            case .success(let model):
//                print(model)
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//                break
//            }
//        }
        
//        APICaller.shared.getRecommendations { result in
//            switch result {
//            case .success(let model):
//                print(model)
//                break
//            case .failure(let error):
//                print(error)
//                break
//            }
//        }
        
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let genre = genres.randomElement() {
                        seeds.insert(genre)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) { result in
                    switch result {
                    case .success(let model):
                        print(model)
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                    }
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
    }
    
    @objc private func didTapSettings() {
        let profileVC = SettingsViewController()
        profileVC.title = "Setting"
        profileVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(profileVC, animated: true)
    }


}

