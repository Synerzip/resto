//
//  AppManager.swift
//  Resto
//
//  Created by synerzip on 26/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import Foundation

class AppManager: NSObject {
    static var shared = AppManager()
    var currentOrder = [OrderItem]()
    
    override init() {
        super.init()
    }
}
