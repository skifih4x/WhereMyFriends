//
//  InfoLocationCell.swift
//  WhereMyFriends
//
//  Created by Артем Орлов on 07.03.2023.
//

import UIKit
import CoreLocation

final class InfoLocationCell: UITableViewCell {
    
    static let identifier = "InfoLocationCell"
    
    var selectedUser: User?
    
    private let avatarImageView = UIImageView(contentMode: .scaleToFill)
    private let nameLabel = UILabel(textAlignment: .left)
    private let distanceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views = [avatarImageView, nameLabel, distanceLabel]
            views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(distanceLabel)
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            distanceLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            distanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User, selectedUser: User?) {
        nameLabel.text = user.name
        self.selectedUser = selectedUser
        
        if let selectedUser = selectedUser {
            if selectedUser == user {
                distanceLabel.text = "Tекущий пользователь"
                distanceLabel.adjustsFontSizeToFitWidth = true
            } else {
                let distance = calculateDistance(from: user, to: selectedUser)
                distanceLabel.text = String(format: "%.2f km", distance)
            }
        } else {
            distanceLabel.text = "Выберите пользователя"
        }
        
        avatarImageView.image = user.profileImage
    }
    
    private func calculateDistance(from user: User, to selectedUser: User) -> Double {
        let userLocation = CLLocation(latitude: user.latitude, longitude: user.longitude)
        let selectedUserLocation = CLLocation(latitude: selectedUser.latitude, longitude: selectedUser.longitude)
        let distance = userLocation.distance(from: selectedUserLocation) / 1000
        return distance
    }
}
