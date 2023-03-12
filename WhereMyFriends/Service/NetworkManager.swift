//
//  NetworkManager.swift
//  WhereMyFriends
//
//  Created by Артем Орлов on 10.03.2023.
//

import UIKit


final class NetworkManager {
    
    func getUsers(completion: @escaping ([User]) -> Void) {
        
        let users: [User] = [
            User(name: "Артем", latitude: 51.507222, longitude: -0.127647, profileImage: UIImage(named: "emojiThinks") ?? UIImage()),
            User(name: "Игорь", latitude: 40.712776, longitude: -74.005974, profileImage: UIImage(named: "emojiSmile") ?? UIImage()),
            User(name: "Сергей", latitude: 48.856613, longitude: 2.352222, profileImage: UIImage(named: "emojiGlasses") ?? UIImage()),
        ]
        completion(users)
    }
}

