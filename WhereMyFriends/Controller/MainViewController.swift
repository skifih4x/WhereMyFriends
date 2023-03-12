//
//  MainViewController.swift
//  WhereMyFriends
//
//  Created by Артем Орлов on 07.03.2023.
//

import UIKit
import CoreLocation

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private var currentUserModel: User?
    private var selectedUser: User?
    private var users: [User] = [] {
        didSet {
            userTableView.reloadData()
        }
    }
    
    private var timer: Timer?
    private let networkManager = NetworkManager()
    
    private lazy var currentUserLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь не выбран"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.register(InfoLocationCell.self, forCellReuseIdentifier: InfoLocationCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutSubviews()
        startUpdatingLocations()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        view.backgroundColor = .white
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    private func layoutSubviews() {
        view.addSubview(currentUserLabel)
        view.addSubview(userTableView)
        
        NSLayoutConstraint.activate([
            currentUserLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            currentUserLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentUserLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            currentUserLabel.heightAnchor.constraint(equalToConstant: 100),
            
            userTableView.topAnchor.constraint(equalTo: currentUserLabel.bottomAnchor, constant: 50),
            userTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateLocations() {
        networkManager.getUsers { [weak self] users in
            guard let self = self else { return }
            self.users = users
            
            let updatedUsers = self.users.map { user in
                var user = user
                user.latitude = Double.random(in: -90...90)
                user.longitude = Double.random(in: -180...180)
                return user
            }
            
            self.users = updatedUsers
            
            if var selectedUser = self.selectedUser {
                let latitude = Double.random(in: -90...90)
                let longitude = Double.random(in: -180...180)
                selectedUser.latitude = latitude
                selectedUser.longitude = longitude
                self.selectedUser = selectedUser
            }
            
            self.updateCurrentUserLabel()
            self.userTableView.reloadData()
        }
    }
    
    
    private func startUpdatingLocations() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.updateLocations()
        }
        locationManager.startUpdatingLocation()
    }
    
    private func updateCurrentUserLabel() {
        if let selectedUser = selectedUser {
            let latitude = String(format: "%.2f", selectedUser.latitude)
            let longitude = String(format: "%.2f", selectedUser.longitude)
            let distanceInKm = String(format: "%.2f", calculateDistance(user: selectedUser))
            currentUserLabel.text =
 """
\(selectedUser.name)
 (\(latitude), \(longitude))
 Distance: \(distanceInKm) km
"""
        } else {
            currentUserLabel.text = "Пользователь не выбран"
        }
    }
    
    private func calculateDistance(user: User, to selectedUser: User? = nil) -> Double {
        let userLocation = CLLocation(latitude: user.latitude, longitude: user.longitude)
        guard let selectedUser = selectedUser else {
            guard let currentLocation = locationManager.location else {
                return 0.0
            }
            let distance = userLocation.distance(from: currentLocation)
            return distance / 1000
        }
        let selectedUserLocation = CLLocation(latitude: selectedUser.latitude, longitude: selectedUser.longitude)
        let distance = userLocation.distance(from: selectedUserLocation)
        return distance / 1000
    }
    
    
}

// MARK: - Table Data Source

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoLocationCell.identifier, for: indexPath) as? InfoLocationCell else { return UITableViewCell()}
        let user = users[indexPath.row]
        cell.configure(with: user, selectedUser: selectedUser)
        return cell
    }
}

// MARK: - Table Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentUser = selectedUser, currentUser == users[indexPath.row] {
            selectedUser = nil
        } else {
            selectedUser = users[indexPath.row]
        }
        
        updateCurrentUserLabel()
        timer?.fire()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

// MARK: - CLLocationManagerDelegate Methods

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateCurrentUserLabel()
    }
}
