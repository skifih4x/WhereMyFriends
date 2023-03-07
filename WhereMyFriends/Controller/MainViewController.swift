//
//  MainViewController.swift
//  WhereMyFriends
//
//  Created by Артем Орлов on 07.03.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    lazy var currentUser: UILabel = {
        var label = UILabel()
        label.text = "Лейбл"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var userTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .blue
        table.register(InfoLocationCell.self, forCellReuseIdentifier: InfoLocationCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        layout()
    }
    
    // MARK: - Private Methods
    
    private func layout() {
        view.addSubview(currentUser)
        view.addSubview(userTableView)
        
        NSLayoutConstraint.activate([
            currentUser.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            currentUser.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentUser.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            userTableView.topAnchor.constraint(equalTo: currentUser.bottomAnchor, constant: 50),
            userTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
        ])
    }
}

// MARK: - Table Data Source

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoLocationCell.identifier, for: indexPath) as? InfoLocationCell else { return UITableViewCell()}
//        cell.textLabel?.text = "Ячейка"
        return cell
    }
}

// MARK: - Table Delegate

extension MainViewController: UITableViewDelegate {
    
}

