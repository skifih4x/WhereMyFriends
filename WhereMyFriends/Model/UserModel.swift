//
//  UserModel.swift
//  WhereMyFriends
//
//  Created by Артем Орлов on 08.03.2023.
//
import CoreLocation
import UIKit

struct User {
    let name: String
    var latitude: Double
    var longitude: Double
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
    }
}

