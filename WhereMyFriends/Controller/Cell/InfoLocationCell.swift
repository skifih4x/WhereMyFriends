//
//  InfoLocationCell.swift
//  WhereMyFriends
//
//  Created by Артем Орлов on 07.03.2023.
//

import UIKit

final class InfoLocationCell: UITableViewCell {
    
    static let identifier = "InfoLocationCell"
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy private var avatarImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy private var nameUserLabel: UILabel = {
        var label = UILabel()
        label.text = "Имя"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var userDistanceLabel: UILabel = {
        var label = UILabel()
        label.text = "666 км"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(mainStack)
        mainStack.addArrangedSubview(avatarImage)
        mainStack.addArrangedSubview(nameUserLabel)
        mainStack.addArrangedSubview(userDistanceLabel)
        
        NSLayoutConstraint.activate([
            
            mainStack.centerYAnchor.constraint(equalTo: centerYAnchor),
//            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
