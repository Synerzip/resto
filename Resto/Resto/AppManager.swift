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
    var menuItemList = [MenuItem]()
    override init() {
        super.init()
    }
    
    func getSuggestedItems() -> [MenuItem] {
        var suggestedItems = [MenuItem]()
        if menuItemList.count > 0 {
            for _ in 0..<3 {
                let randomNo = randomNumber(MIN: 0, MAX: menuItemList.count - 1)
                suggestedItems.append(menuItemList[randomNo])
            }
        }
        return suggestedItems
    }
    
    private func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }
}
