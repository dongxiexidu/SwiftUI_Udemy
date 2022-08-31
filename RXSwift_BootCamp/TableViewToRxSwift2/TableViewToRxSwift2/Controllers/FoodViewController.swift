//
//  FoodViewController.swift
//  TableViewToRxSwift2
//
//  Created by Junyeong Park on 2022/08/31.
//

import UIKit
import RxSwift
import RxCocoa

class FoodViewController: UIViewController {
    @IBOutlet weak var foodImage: UIImageView!
    var foodImageName: String? = nil
    let foodImageNameRelay: BehaviorRelay = BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setFoodImageRx()
    }
    
    private func setFoodImage() {
        guard let foodImageName = foodImageName else {
            return
        }
        foodImage.image = UIImage(named: foodImageName)
    }
    
    private func setFoodImageRx() {
        foodImageNameRelay
            .map{UIImage(named: $0)}
            .bind(to: foodImage
                .rx
                .image)
            .disposed(by: disposeBag)
    }
}

