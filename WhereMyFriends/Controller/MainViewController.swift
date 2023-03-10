//
//  MainViewController.swift
//  WhereMyFriends
//
//  Created by Артем Орлов on 07.03.2023.
//

import UIKit
import CoreLocation

final class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    /// MARK: - Properties
    
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

    private lazy var currentUser: UILabel = {
        let label = UILabel()
        label.text = "No user selected"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var userTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.dataSource = self
        table.delegate = self
        table.register(InfoLocationCell.self, forCellReuseIdentifier: InfoLocationCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        layout()
        startUpdatingLocations()
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

    private func startUpdatingLocations() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.updateLocations()
        }
        locationManager.startUpdatingLocation()
    }

    private func stopUpdatingLocations() {
        timer?.invalidate()
        timer = nil
        locationManager.stopUpdatingLocation()
    }

    private func updateCurrentUserLabel() {
        if let selectedUser = selectedUser {
            let latitude = String(format: "%.2f", selectedUser.latitude)
            let longitude = String(format: "%.2f", selectedUser.longitude)
            let distanceInKm = String(format: "%.2f", calculateDistance(user: selectedUser))
            currentUser.text = "\(selectedUser.name) (\(latitude), \(longitude)), Distance: \(distanceInKm) km"
        } else {
            currentUser.text = "No user selected"
        }
    }
    
    private func updateLocations() {
        networkManager.getUsers { [weak self] users in
            guard let self = self else { return }
            self.users = users
            self.userTableView.reloadData()
            
            for i in 0..<self.users.count {
                let latitude = Double.random(in: -90...90)
                let longitude = Double.random(in: -180...180)
                self.users[i].latitude = latitude
                self.users[i].longitude = longitude
            }
            
            self.updateCurrentUserLabel()
            self.userTableView.reloadData()
        }
    }
    
    private func calculateDistance(user: User, to selectedUser: User? = nil) -> Double {
        let userLocation = CLLocation(latitude: user.latitude, longitude: user.longitude)
        let selectedUserLocation = selectedUser != nil ? CLLocation(latitude: selectedUser!.latitude, longitude: selectedUser!.longitude) : locationManager.location
        let distance = userLocation.distance(from: selectedUserLocation ?? CLLocation())
        return distance / 1000 // convert to km
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
        selectedUser = users[indexPath.row]
        updateCurrentUserLabel()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

