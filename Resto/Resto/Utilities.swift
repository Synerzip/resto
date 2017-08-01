//
//  Utilities.swift
//  Resto
//
//  Created by synerzip on 28/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import Foundation

class Utilities {
    
    class func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }
}
