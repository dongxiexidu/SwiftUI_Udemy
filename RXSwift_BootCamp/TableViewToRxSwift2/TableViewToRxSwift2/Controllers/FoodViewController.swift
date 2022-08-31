//
//  FoodViewController.swift
//  TableViewToRxSwift2
//
//  Created by Junyeong Park on 2022/08/31.
//

import UIKit

class FoodViewController: UIViewController {
    
    var foodImageName: String? = nil
    @IBOutlet weak var foodImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setFoodImage()
    }
    
    private func setFoodImage() {
        guard let foodImageName = foodImageName else {
            return
        }
        foodImage.image = UIImage(named: foodImageName)
    }
}
