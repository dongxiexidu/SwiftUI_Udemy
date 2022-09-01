//
//  SettingsViewController.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import UIKit

class SettingsViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        return tableView
    }()
    private var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSettingsViewUI()
        setTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setSettingsViewUI() {
        title = "Settings"
        view.backgroundColor = .systemBackground
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        configureModels()
    }
    
    private func viewProfile() {
        let profileVC = ProfileViewController()
        profileVC.title = "Profile"
        profileVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func signOutTapped() {
        
    }
    
    
    private func configureModels() {
        sections.append(Section(title: "Profile", options: [Option(title: "View Your Profile", handler: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { self.viewProfile() }
        })]))
        sections.append(Section(title: "Account", options: [Option(title: "Sign Out", handler: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { self.signOutTapped() }
        })]))
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Call completionhandlder to this cell
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
}
