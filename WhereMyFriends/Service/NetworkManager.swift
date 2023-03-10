//
//  NetworkManager.swift
//  WhereMyFriends
//
//  Created by Артем Орлов on 10.03.2023.
//


final class NetworkManager {
    
    func getUsers(completion: @escaping ([User]) -> Void) {
        
        let users: [User] = [
            User(name: "Alice", latitude: 51.507222, longitude: -0.127647),
            User(name: "Bob", latitude: 40.712776, longitude: -74.005974),
            User(name: "Charlie", latitude: 48.856613, longitude: 2.352222)
        ]
        completion(users)
    }
}
