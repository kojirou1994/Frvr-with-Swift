//
//  RandomShapeMgr.swift
//  Frvr
//
//  Created by 谭钧豪 on 16/4/8.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import Foundation
import SpriteKit

class RandomShapeMgr: NSObject {
    var posResultsArray: NSMutableArray!
    var compareSeqArray: NSMutableArray!
    
    class func sharedRandomShapeMgr() -> RandomShapeMgr{
        let defaultManagerInstance: RandomShapeMgr!
        defaultManagerInstance = RandomShapeMgr()
        return defaultManagerInstance
    }
    
    override init() {
        super.init()
        self.posInfoInit()
    }
    
    func shapeGenerator() -> SKSpriteNode{
        let array = [1,3,3,4,4,4,6]
        let shapeCategory = Int(arc4random()%UInt32(array.count))
        let shapeType = Int(arc4random()%UInt32(array[shapeCategory]))
        
        var count = 0
        for i in 0..<shapeCategory{
            count += array[i]
        }
        count += shapeType
        return nodeType(count)
    }
    
    func nodeType(shapeType: Int) -> SKSpriteNode{
        let shape = SKSpriteNode()
        shape.name = "shape"
        shape.size = CGSizeMake(100, 100)
        shape.zPosition = 2
        let texture = self.textureWithShapeType(shapeType)
        let posArray = posResultsArray.objectAtIndex(shapeType) as! NSArray
        let count = posArray.count
        for index in 0..<count{
            let node = SKSpriteNode(texture: texture)
            node.size = CGSizeMake(43, 45)
            node.setScale(0.5)
            node.position = posArray.objectAtIndex(index).CGPointValue()
            node.name = NSString(format: "%d",index) as String
            shape.addChild(node)
        }
        
        shape.userData = NSMutableDictionary()
        shape.userData?.setObject(shapeType, forKey: "shapeType")
        shape.userData?.setObject(compareSeqArray[shapeType], forKey: "shapeCompOrder")
        
        return shape
    }
    
    func shapeWithType(shapeType: Int) -> SKSpriteNode{
        return self.nodeType(shapeType)
    }
    
    func textureWithShapeType(shapeType: Int) -> SKTexture{
        let array = [1,3,3,4,4,4,6]
        let count = array.count
        var number = 0
        var index = 0
        for i in 0..<count{
            number += array[i]
            if number>shapeType{
                break
            }
            index = i
        }
        return SKTexture(imageNamed: NSString(format: "%d",index+1) as String)
    }
    
    func posInfoInit(){
        posResultsArray = NSMutableArray()
        compareSeqArray = NSMutableArray()
        
        let width: CGFloat = 45/2
        let height: CGFloat = 45/2
        
        let pos1: NSArray = [NSValue(CGPoint: CGPointMake(0, 0))]
        let compareSeq1: NSArray = []
        posResultsArray.addObject(pos1)
        compareSeqArray.addObject(compareSeq1)
        
        let pos2: NSArray = [NSValue(CGPoint: CGPointMake(-width*3/2, 0)),
                    NSValue(CGPoint: CGPointMake(-width/2, 0)),
                    NSValue(CGPoint: CGPointMake(width/2, 0)),
                    NSValue(CGPoint: CGPointMake(width*3/2, 0))]
        let compareSeq2: NSArray = [2,2,2]
        posResultsArray.addObject(pos2)
        compareSeqArray.addObject(compareSeq2)
        
        let pos3: NSArray = [NSValue(CGPoint: CGPointMake(width*3/4, height/2+19)),
                             NSValue(CGPoint: CGPointMake(width/4, height/2)),
                             NSValue(CGPoint: CGPointMake(-width/4, height/2-19)),
                             NSValue(CGPoint: CGPointMake(-width*3/4, height/2-38))]
        let compareSeq3: NSArray = [4,4,4]
        posResultsArray.addObject(pos3)
        compareSeqArray.addObject(compareSeq3)
        
        let pos4: NSArray = [NSValue(CGPoint: CGPointMake(-width*3/4, height/2+19)),
                             NSValue(CGPoint: CGPointMake(-width/4, height/2)),
                             NSValue(CGPoint: CGPointMake(width/4, height/2-19)),
                             NSValue(CGPoint: CGPointMake(width*3/4, height/2-38))]
        let compareSeq4: NSArray = [3,3,3]
        posResultsArray.addObject(pos4)
        compareSeqArray.addObject(compareSeq4)
        
        let pos5: NSArray = [NSValue(CGPoint: CGPointMake(0, height/2)),
                             NSValue(CGPoint: CGPointMake(width, height/2)),
                             NSValue(CGPoint: CGPointMake(-width/2, height/2-19)),
                             NSValue(CGPoint: CGPointMake(width/2, height/2-19))]
        let compareSeq5: NSArray = [2,4,5]
        posResultsArray.addObject(pos5)
        compareSeqArray.addObject(compareSeq5)
        
        let pos6: NSArray = [NSValue(CGPoint: CGPointMake(0, height/2)),
                             NSValue(CGPoint: CGPointMake(-width, height/2)),
                             NSValue(CGPoint: CGPointMake(width/2, height/2-19)),
                             NSValue(CGPoint: CGPointMake(-width/2, height/2-19))]
        let compareSeq6: NSArray = [5,3,2]
        posResultsArray.addObject(pos6)
        compareSeqArray.addObject(compareSeq6)
        
        let pos7: NSArray = [NSValue(CGPoint: CGPointMake(0, height/2)),
                             NSValue(CGPoint: CGPointMake(-width/2, height/2-19)),
                             NSValue(CGPoint: CGPointMake(0, height/2-38)),
                             NSValue(CGPoint: CGPointMake(width/2, height/2-19))]
        let compareSeq7: NSArray = [4,3,1]
        posResultsArray.addObject(pos7)
        compareSeqArray.addObject(compareSeq7)
        
        let pos8: NSArray = [NSValue(CGPoint: CGPointMake(-width/2, 19)),
                             NSValue(CGPoint: CGPointMake(width/2, 19)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(-width/2, -19))]
        let compareSeq8: NSArray = [2,4,4]
        posResultsArray.addObject(pos8)
        compareSeqArray.addObject(compareSeq8)
        
        let pos9: NSArray = [NSValue(CGPoint: CGPointMake(width/2, 19)),
                             NSValue(CGPoint: CGPointMake(width, 0)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(-width/2, -19))]
        let compareSeq9: NSArray = [3,5,4]
        posResultsArray.addObject(pos9)
        compareSeqArray.addObject(compareSeq9)
        
        let pos10: NSArray = [NSValue(CGPoint: CGPointMake(width/2, 19)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(-width, 0)),
                             NSValue(CGPoint: CGPointMake(-width/2, -19))]
        let compareSeq10: NSArray = [4,5,3]
        posResultsArray.addObject(pos10)
        compareSeqArray.addObject(compareSeq10)
        
        let pos11: NSArray = [NSValue(CGPoint: CGPointMake(width/2, 19)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(-width/2, -19)),
                             NSValue(CGPoint: CGPointMake(width/2, -19))]
        let compareSeq11: NSArray = [4,4,2]
        posResultsArray.addObject(pos11)
        compareSeqArray.addObject(compareSeq11)
        
        let pos12: NSArray = [NSValue(CGPoint: CGPointMake(-width/2, 19)),
                             NSValue(CGPoint: CGPointMake(-width, 0)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(width/2, -19))]
        let compareSeq12: NSArray = [4,2,3]
        posResultsArray.addObject(pos12)
        compareSeqArray.addObject(compareSeq12)
        
        let pos13: NSArray = [NSValue(CGPoint: CGPointMake(-width/2, 19)),
                             NSValue(CGPoint: CGPointMake(width/2, 19)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(width/2, -19))]
        let compareSeq13: NSArray = [2,4,3]
        posResultsArray.addObject(pos13)
        compareSeqArray.addObject(compareSeq13)
        
        let pos14: NSArray = [NSValue(CGPoint: CGPointMake(-width/2, 19)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(-width/2, -19)),
                             NSValue(CGPoint: CGPointMake(width/2, -19))]
        let compareSeq14: NSArray = [3,3,5]
        posResultsArray.addObject(pos14)
        compareSeqArray.addObject(compareSeq14)
        
        let pos15: NSArray = [NSValue(CGPoint: CGPointMake(-width/2, 19)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(width, 0)),
                             NSValue(CGPoint: CGPointMake(width/2, -19))]
        let compareSeq15: NSArray = [3,2,4]
        posResultsArray.addObject(pos15)
        compareSeqArray.addObject(compareSeq15)
        
        let pos16: NSArray = [NSValue(CGPoint: CGPointMake(-width/2, 19)),
                             NSValue(CGPoint: CGPointMake(-width, 0)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(width, 0))]
        let compareSeq16: NSArray = [4,2,2]
        posResultsArray.addObject(pos16)
        compareSeqArray.addObject(compareSeq16)
        
        let pos17: NSArray = [NSValue(CGPoint: CGPointMake(-width/2, -19)),
                             NSValue(CGPoint: CGPointMake(-width, 0)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(width, 0))]
        let compareSeq17: NSArray = [0,2,2]
        posResultsArray.addObject(pos17)
        compareSeqArray.addObject(compareSeq17)
        
        let pos18: NSArray = [NSValue(CGPoint: CGPointMake(width/2, 19)),
                             NSValue(CGPoint: CGPointMake(width, 0)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(-width, 0))]
        let compareSeq18: NSArray = [3,5,5]
        posResultsArray.addObject(pos18)
        compareSeqArray.addObject(compareSeq18)
        
        let pos19: NSArray = [NSValue(CGPoint: CGPointMake(width/2, -19)),
                             NSValue(CGPoint: CGPointMake(width, 0)),
                             NSValue(CGPoint: CGPointMake(0, 0)),
                             NSValue(CGPoint: CGPointMake(-width, 0))]
        let compareSeq19: NSArray = [1,5,5]
        posResultsArray.addObject(pos19)
        compareSeqArray.addObject(compareSeq19)
        
        let pos20: NSArray = [NSValue(CGPoint: CGPointMake(-width/2, 19)),
                             NSValue(CGPoint: CGPointMake(width/2, 19)),
                             NSValue(CGPoint: CGPointMake(width, 0)),
                             NSValue(CGPoint: CGPointMake(width/2, -19))]
        let compareSeq20: NSArray = [2,3,4]
        posResultsArray.addObject(pos20)
        compareSeqArray.addObject(compareSeq20)
        
        let pos21: NSArray = [NSValue(CGPoint: CGPointMake(width/2, 19)),
                             NSValue(CGPoint: CGPointMake(width, 0)),
                             NSValue(CGPoint: CGPointMake(width/2, -19)),
                             NSValue(CGPoint: CGPointMake(-width/2, -19))]
        let compareSeq21: NSArray = [3,4,5]
        posResultsArray.addObject(pos21)
        compareSeqArray.addObject(compareSeq21)
        
        let pos22: NSArray = [NSValue(CGPoint: CGPointMake(width, 0)),
                             NSValue(CGPoint: CGPointMake(width/2, -19)),
                             NSValue(CGPoint: CGPointMake(-width/2, -19)),
                             NSValue(CGPoint: CGPointMake(-width, 0))]
        let compareSeq22: NSArray = [4,5,0]
        posResultsArray.addObject(pos22)
        compareSeqArray.addObject(compareSeq22)
        
        let pos23: NSArray = [NSValue(CGPoint: CGPointMake(width/2, -19)),
                             NSValue(CGPoint: CGPointMake(-width/2, -19)),
                             NSValue(CGPoint: CGPointMake(-width, 0)),
                             NSValue(CGPoint: CGPointMake(-width/2, 19))]
        let compareSeq23: NSArray = [5,0,1]
        posResultsArray.addObject(pos23)
        compareSeqArray.addObject(compareSeq23)
        
        let pos24: NSArray = [NSValue(CGPoint: CGPointMake(-width/2, -19)),
                             NSValue(CGPoint: CGPointMake(-width, 0)),
                             NSValue(CGPoint: CGPointMake(-width/2, 19)),
                             NSValue(CGPoint: CGPointMake(width/2, 19))]
        let compareSeq24: NSArray = [0,1,2]
        posResultsArray.addObject(pos24)
        compareSeqArray.addObject(compareSeq24)
        
        let pos25: NSArray = [NSValue(CGPoint: CGPointMake(-width, 0)),
                             NSValue(CGPoint: CGPointMake(-width/2, 19)),
                             NSValue(CGPoint: CGPointMake(width/2, 19)),
                             NSValue(CGPoint: CGPointMake(width, 0))]
        let compareSeq25: NSArray = [1,2,3]
        posResultsArray.addObject(pos25)
        compareSeqArray.addObject(compareSeq25)
        
        
    }

}
