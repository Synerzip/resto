//
//  OrderItem.swift
//  Resto
//
//  Created by synerzip on 26/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import Foundation

class OrderItem {
    
    var menuItem: MenuItem
    var quantity: Int
    var totalAmount: Int
    
    init(menuItem: MenuItem, quantity: Int) {
        self.menuItem = menuItem
        self.quantity = quantity
        self.totalAmount = menuItem.price * quantity
    }
}
