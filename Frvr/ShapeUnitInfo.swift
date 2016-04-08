//
//  ShapeUnitInfo.swift
//  Frvr
//
//  Created by 谭钧豪 on 16/4/7.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import Foundation
import UIKit

class ShapeUnitInfo: NSObject {
    var unitLocation: CGPoint!
    var unitPosition: CGPoint!
    var serialNumber: Int!
    var occupy: Bool!
    var adjacentArray: NSMutableArray!
    
    func isOccupied() -> Bool{
        return occupy
    }
    
    override init(){
        super.init()
        self.adjacentArray = NSMutableArray(capacity: 6)
        self.occupy = false
    }
    
    func debugInfo(){
        print("location:\(unitLocation)")
        print("position:\(unitPosition)")
        print("serailNum:\(serialNumber)")
        print("adjacents:\(adjacentArray)")
        print("occupy:\(occupy)")
    }
}