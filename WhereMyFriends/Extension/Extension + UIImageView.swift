//
//  Extension + UIImageView.swift
//  WhereMyFriends
//
//  Created by Артем Орлов on 10.03.2023.
//

import UIKit

extension UIImageView {
    convenience init(contentMode: UIView.ContentMode) {
        self.init()
        self.contentMode = contentMode
    }
}
