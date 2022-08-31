//
//  ViewController.swift
//  TableViewToRxSwift2
//
//  Created by Junyeong Park on 2022/08/31.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {
    let tableViewItems = [FoodModel(name: "Coke", imageName: "coke"), FoodModel(name: "Hamburger", imageName: "hamburger"), FoodModel(name: "Pizza", imageName: "pizza"), FoodModel(name: "Bulgogi", imageName: "bulgogi")]
    let tableViewItemSection = [SectionModel(header: "Main Courses", items: [FoodModel(name: "Hamburger", imageName: "hamburger"), FoodModel(name: "Pizza", imageName: "pizza"), FoodModel(name: "Bulgogi", imageName: "bulgogi")]), SectionModel(header: "Desserts", items: [FoodModel(name: "Coke", imageName: "coke")])]
    lazy var tableViewItemsRx = BehaviorRelay.init(value: tableViewItems)
    lazy var tableViewItemSectionsRx = BehaviorRelay.init(value: tableViewItemSection)
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: {
        ds, tv, indexPath, item in
        let cell: CustomTableViewCell
        if let dequeuedCell = tv.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as? CustomTableViewCell {
            cell = dequeuedCell
        } else {
            cell = CustomTableViewCell()
        }
        cell.cellLabel.text = item.name
        cell.cellImage.image = UIImage(named: item.imageName)
        return cell
    }, titleForHeaderInSection: {
        ds, index in
        return ds.sectionModels[index].header
    })

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
//        tableView.delegate = self
//        setSearchingTableView()
        setSearchingTableViewWithSection()
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
    
    private func setSearchingTableViewWithSection() {
        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { query in
                self.tableViewItemSectionsRx.value.map { sectionModel in
                    SectionModel(header: sectionModel.header, items: sectionModel.items.filter({ foodModel in
                        if query.isEmpty || foodModel.name.lowercased().contains(query.lowercased()) {
                            return true
                        } else {
                            return false
                        }
                    }))
                }
            }
            .bind(to: tableView
                .rx
                .items(dataSource: dataSource))
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

