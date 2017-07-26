//
//  MenuItem.swift
//  Resto
//
//  Created by synerzip on 25/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import Foundation
import SwiftyJSON

class MenuItem {
    var name: String
    var ingredients: String
    var imagePath: String
    var price: Int
    var description: String
    
    init(menuItemJSON: JSON) {
        self.name = menuItemJSON["name"].string ?? ""
        self.ingredients = menuItemJSON["ingredients"].string ?? ""
        self.imagePath = menuItemJSON["imagepath"].string ?? ""
        self.price = menuItemJSON["price"].int ?? 0
        self.description = menuItemJSON["description"].string ?? ""
    }
}
