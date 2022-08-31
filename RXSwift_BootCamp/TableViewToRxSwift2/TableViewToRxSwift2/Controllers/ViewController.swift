//
//  ViewController.swift
//  TableViewToRxSwift2
//
//  Created by Junyeong Park on 2022/08/31.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let tableViewItems = [FoodModel(name: "Coke", imageName: "coke"), FoodModel(name: "Hamburger", imageName: "hamburger"), FoodModel(name: "Pizza", imageName: "pizza"), FoodModel(name: "Bulgogi", imageName: "bulgogi")]
    lazy var tableViewItemsRx = Observable.just(tableViewItems)
    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
//        tableView.delegate = self
        setTableViewBindRx()
        setTableViewModelSelectedRx()
    }
    
    private func setTableViewBindRx() {
        tableViewItemsRx.bind(to: tableView
            .rx
            .items(cellIdentifier: "customTableViewCell", cellType: CustomTableViewCell.self)) {
                (tv, tableViewItem, cell) in
                cell.cellLabel.text = tableViewItem.name
                cell.cellImage.image = UIImage(named: tableViewItem.imageName)
            }
            .disposed(by: disposeBag)
    }
    
    private func setTableViewModelSelectedRx() {
        tableView
            .rx
            .modelSelected(FoodModel.self)
            .subscribe(onNext: { foodModel in
                guard let navDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodViewController") as? FoodViewController else {
                    return
                }
                navDetailVC.foodImageNameRelay.accept(foodModel.imageName)
                self.navigationController?.pushViewController(navDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setTableViewItemSelectedRx() {
        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                let foodModel = self.tableViewItems[indexPath.row]
                guard let navDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodViewController") as? FoodViewController else {
                    return
                }
                navDetailVC.foodImageName = foodModel.imageName
                self.navigationController?.pushViewController(navDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let navDetailVC = storyboard?.instantiateViewController(withIdentifier: "FoodViewController") as? FoodViewController else {
//            return
//        }
//        navDetailVC.foodImageName = tableViewItems[indexPath.row].imageName
//        navigationController?.pushViewController(navDetailVC, animated: true)
//    }
//}

