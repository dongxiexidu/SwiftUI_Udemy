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
    lazy var tableViewItemsRx = BehaviorRelay.init(value: tableViewItems)
    let disposeBag = DisposeBag()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
//        tableView.delegate = self
        setSearchingTableView()
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
    
    private func setSearchingTableView() {
        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { query in
                self.tableViewItemsRx.value.filter { foodModel in
                    if query.isEmpty || foodModel.name.lowercased().contains(query.lowercased()) {
                        return true
                    } else {
                        return false
                    }
                }
            }
            .bind(to: tableView
                .rx
                .items(cellIdentifier: "customTableViewCell", cellType: CustomTableViewCell.self)) {
                    (tv, tableViewItem, cell) in
                    cell.cellLabel.text = tableViewItem.name
                    cell.cellImage.image = UIImage(named: tableViewItem.imageName)
                }
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

