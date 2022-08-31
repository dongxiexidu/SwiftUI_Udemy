//
//  ViewController.swift
//  TableViewToRxSwift
//
//  Created by Junyeong Park on 2022/08/31.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let tableViewItems = ["Item 1", "Item 2", "Item 3", "Item 4"]
    let tableViewRxItems = Observable.just(["Item 1", "Item 2", "Item 3", "Item 4"])
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewRx()
    }
    
    private func setTableViewRx() {
        tableViewRxItems
            .bind(to: tableView
                .rx
                .items(cellIdentifier: "tableViewCell")) {
                    (tv, tableViewItem, cell) in
                    cell.textLabel?.text = tableViewItem
                }
                .disposed(by: disposeBag)
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "tableViewCell")
        cell.textLabel?.text = tableViewItems[indexPath.row]
        return cell
    }
}
