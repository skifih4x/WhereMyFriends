//
//  Extension + UILabel.swift
//  WhereMyFriends
//
//  Created by Артем Орлов on 10.03.2023.
//

import UIKit

extension UILabel {
    convenience init(textAlignment: NSTextAlignment) {
        self.init()
        self.textAlignment = textAlignment
    }
}
