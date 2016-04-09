//
//  GameScene.swift
//  Frvr
//
//  Created by 谭钧豪 on 16/4/7.
//  Copyright (c) 2016年 谭钧豪. All rights reserved.
//

import SpriteKit

let TOPMARGING = 5
let XDISTANCE = 23
let YDISTANCE = 38
let PLAYGROUNDLINE = 9
let UNITSHAPETYPE = 16
let UNITCOLORTYPE = 5

class GameScene: SKScene {
    var unitNodeArray: NSMutableArray!
    var unitInfoArray: NSMutableArray!
    var shapePosArray: NSMutableArray!
    var shapeArray: NSMutableArray!
    var handleNode: SKSpriteNode!
    var unitTexture: SKTexture!
    var unitWidth: CGFloat!
    var unitHeight: CGFloat!
    var score: Int = 0
    var bestScore: Int = 0
    var gameOverStatu: Bool = false
    
    func startNewGame(){
        gameOverStatu = false
        self.refreshPlayground()
        self.shapeFill()
    }
    
    func gameOver(){
        gameOverStatu = true
        NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: score)
        let bestScoreLabel = self.childNodeWithName("bestScoreLabel") as! SKLabelNode
        bestScoreLabel.text = "最高纪录:\(bestScore>score ? bestScore : score)"
        
    }
    
    override func didMoveToView(view: SKView) {
        self.dataInit()
        self.addLabel()
        self.addPlayground()
        self.addShapeFrame()
        
    }
    
    func addLabel(){
        let myLabel = SKLabelNode(fontNamed: "Heiti SC")
        myLabel.text = "消除六边形"
        myLabel.fontSize = 30
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame)-40)
        self.addChild(myLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Heiti SC")
        scoreLabel.text = "当前分数 : "
        scoreLabel.fontSize = 26
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame)-120, CGRectGetHeight(self.frame)-90)
        self.addChild(scoreLabel)
        
        let bestScoreLabel = SKLabelNode(fontNamed: "Heiti SC")
        bestScoreLabel.name = "bestScoreLabel"
        bestScoreLabel.text = "最高纪录:\(bestScore)"
        bestScoreLabel.fontSize = 13
        bestScoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame)-60, CGRectGetHeight(self.frame)-90)
        self.addChild(bestScoreLabel)
        
        let scoreNumberLabel = SKLabelNode(fontNamed: "Heiti SC")
        scoreNumberLabel.name = "scoreNumberLabel"
        scoreNumberLabel.text = "\(score)"
        scoreNumberLabel.fontSize = 26
        scoreNumberLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame)-90)
        self.addChild(scoreNumberLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        var location: CGPoint!
        for touch in touches {
            location = touch.locationInNode(self)
        }
        let nodes = self.nodesAtPoint(location)
        for node in nodes {
            if node.name == "shape"{
                handleNode = node as! SKSpriteNode
                handleNode.runAction(SKAction.scaleTo(1.9, duration: 0.4))
                break
            }else if node.name == "unitShape"{
            }
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var location: CGPoint!
        for touch in touches{
            location = touch.locationInNode(self)
        }
        if handleNode != nil{
            handleNode.position = location
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if handleNode != nil{
            let handleShapeNodes = handleNode.children
            let texture = (handleNode.children.first! as! SKSpriteNode).texture
            var index = 0
            var ocuppiedCount = 0
            let tempArray = NSMutableArray()
            for child in handleShapeNodes{
                index+=1
                let childLocation = CGPointMake(child.position.x*2 + handleNode.position.x, child.position.y*2 + handleNode.position.y)
                let shapeNodes = self.nodesAtPoint(childLocation)
                for shapeNode in shapeNodes{
                    if self.isShapeUnit(shapeNode as! SKSpriteNode) && !(self.isUnitOcuppied(shapeNode as! SKSpriteNode)){
                        ocuppiedCount+=1
                        
                        tempArray.addObject(shapeNode)
                    }
                }
            }
            if index == ocuppiedCount{
                for unitNode in tempArray{
                    (unitNode as! SKSpriteNode).texture = texture
                    let unitInfo = (unitNode as! SKSpriteNode).userData?.objectForKey("unitInfo") as! ShapeUnitInfo
                    unitInfo.occupy = true
                }
                score = !gameOverStatu ? score + ocuppiedCount * 10 : score
                self.changeScore()
                shapeArray.removeObject(handleNode)
                handleNode.removeFromParent()
                self.shapeFill()
            }else{
                let index = shapeArray.indexOfObject(handleNode)
                let location = shapePosArray.objectAtIndex(index).CGPointValue()
                let scale = SKAction.scaleTo(1, duration: 0.3)
                let move = SKAction.moveTo(location, duration: 0.3)
                let group = SKAction.group([scale,move])
                group.timingMode = SKActionTimingMode.EaseOut
                handleNode.runAction(group)
            }
            handleNode = nil
            
            
        }
        self.resultDealElimination()
        self.checkContinue()
    }
    
    func resultDealElimination(){
        let resultArray = NSMutableArray()
        let compareIndexRow = [0,5,11,18,26,35,43,50,56]
        let compareIndexTopSlash = [0,1,2,3,4]
        let compareIndexBottomSlash = [56,57,58,59,60]
        
        for index in compareIndexRow{
            let compareResult = self.dealDirectOcuppiedWithStartUnit(index, direct: ShapeUnitDirector.SUDRight)
            if compareResult != nil{
                resultArray.addObject(compareResult!)
            }
        }
        
        for index in compareIndexTopSlash{
            var compareResult = self.dealDirectOcuppiedWithStartUnit(index, direct: ShapeUnitDirector.SUDBottomLeft)
            if compareResult != nil{
                resultArray.addObject(compareResult!)
            }
            
            compareResult = self.dealDirectOcuppiedWithStartUnit(index, direct: ShapeUnitDirector.SUDBottomRight)
            if compareResult != nil{
                resultArray.addObject(compareResult!)
            }
        }
        
        for index in compareIndexBottomSlash{
            var compareResult = self.dealDirectOcuppiedWithStartUnit(index, direct: ShapeUnitDirector.SUDTopLeft)
            if compareResult != nil{
                resultArray.addObject(compareResult!)
            }

            compareResult = self.dealDirectOcuppiedWithStartUnit(index, direct: ShapeUnitDirector.SUDTopRight)
            if compareResult != nil{
                resultArray.addObject(compareResult!)
            }
        }
        
        if resultArray.count > 0{
            let scoreFactor = resultArray.count * 10
            for array in resultArray{
                for node in array as! NSArray{
                    self.eliminateNode(node as! SKSpriteNode)
                    score += scoreFactor
                }
            }
            self.changeScore()
        }
    }
    
    func eliminateNode(node:SKSpriteNode){
        if self.isShapeUnit(node){
            self.setUnitOcuppied(node, ocuppied: false)
            let scaleBig = SKAction.scaleTo(2, duration: 0.2)
            let scaleNormal = SKAction.scaleTo(1, duration: 0.2)
            node.runAction(scaleBig, completion: {
                let texture = SKTexture(imageNamed: "gray")
                let action = SKAction.setTexture(texture)
                action.timingMode = SKActionTimingMode.EaseOut
                node.runAction(SKAction.group([scaleNormal,action]))
            })
        }
    }
    
    func setUnitOcuppied(node:SKSpriteNode, ocuppied:Bool){
        if self.isShapeUnit(node){
            let unitInfo = node.userData?.objectForKey("unitInfo") as! ShapeUnitInfo
            unitInfo.occupy = ocuppied
        }
    }
    
    func indexOfUnitShape(shapeNode: SKSpriteNode) -> Int{
        if unitNodeArray.containsObject(shapeNode){
            return unitNodeArray.indexOfObject(shapeNode)
        }
        return -1
    }
    
    func dealDirectOcuppiedWithStartUnit(startIndex:Int, direct:ShapeUnitDirector) -> NSArray?{
        let shapeNode = unitNodeArray.objectAtIndex(startIndex) as? SKSpriteNode
        let tempArray = NSMutableArray()
        if (shapeNode != nil) && self.isUnitOcuppied(shapeNode!){
            var tempNode = shapeNode
            let suDirect = direct
            while tempNode != nil {
                if !self.isUnitOcuppied(tempNode!){
                    return nil
                }
                tempArray.addObject(tempNode!)
                tempNode = self.fetchAdjacentUnitWithNode(tempNode!, FromDirect: suDirect)
            }
            
            return tempArray
        }
        return nil
    }
    
    func fetchAdjacentUnitWithNode(node:SKSpriteNode, FromDirect direct:ShapeUnitDirector) -> SKSpriteNode?{
        if self.isShapeUnit(node) && direct != ShapeUnitDirector.SUDNone{
            let unitInfo = node.userData?.objectForKey("unitInfo") as! ShapeUnitInfo
            let number = unitInfo.adjacentArray.objectAtIndex(direct.rawValue).integerValue
            if number == -1{
                return nil
            }
            return (unitNodeArray.objectAtIndex(number) as! SKSpriteNode)
        }
        return nil
    }
    
    func isUnitOcuppied(unitNode:SKSpriteNode) -> Bool{
        if self.isShapeUnit(unitNode){
            
            let unitInfo = unitNode.userData?.objectForKey("unitInfo") as! ShapeUnitInfo
            if unitInfo.occupy!{
                return true
            }
        }
        return false
    }
    
    func isShapeUnit(unitNode:SKSpriteNode) -> Bool{
        if unitNode.name == "unitShape"{
            return true
        }
        return false
    }
    
    func checkContinue(){

        for shape in shapeArray{
            for unitNode in unitNodeArray{
                if !(self.isOccupByShape(shape as! SKSpriteNode, unitNode: unitNode as! SKSpriteNode)){
                    return
                }
            }
        }
        self.gameOver()
    }
    
    func isOccupByShape(shapeNode:SKSpriteNode, unitNode:SKSpriteNode) -> Bool{
        let comSeqArray = shapeNode.userData?.objectForKey("shapeCompOrder") as! [Int]
        var tempNode = unitNode
        var nodeInfo = tempNode.userData?.objectForKey("unitInfo") as! ShapeUnitInfo
        if nodeInfo.isOccupied(){
            return true
        }
        
        for index in comSeqArray{
            let nodeIndex = nodeInfo.adjacentArray.objectAtIndex(index).integerValue
            if nodeIndex == -1{
                return true
            }
            tempNode = unitNodeArray.objectAtIndex(nodeIndex) as! SKSpriteNode
            nodeInfo = tempNode.userData!.objectForKey("unitInfo") as! ShapeUnitInfo
            if nodeInfo.isOccupied(){
                return true
            }
        }
        
        return false
        
    }
    
    func addPlayground(){
        var node = SKSpriteNode()
        self.unitNodeArray = NSMutableArray()
        self.unitTexture = SKTexture(imageNamed: "gray")
        self.unitWidth = self.unitTexture.size().width - 4
        self.unitHeight = self.unitTexture.size().height - 2
        
        let arrayNumber: NSArray = [5,6,7,8,9,8,7,6,5]
        let startPoint = CGPointMake(CGRectGetMidX(self.frame)-2*self.unitWidth, CGRectGetHeight(self.frame)-150)
        
        var index = 0
        var nodeCount = 0
        
        for lineNumber in arrayNumber {
            for i in 0..<lineNumber.integerValue {
                node = SKSpriteNode(texture: self.unitTexture)
                node.size = CGSizeMake(unitWidth - 4, unitHeight - 2)
                if index <= 4{
                    node.position = CGPointMake(10 + startPoint.x - CGFloat(XDISTANCE*index) + CGFloat(i)*self.unitWidth, startPoint.y - CGFloat(YDISTANCE*index))
                }else{
                    node.position = CGPointMake(10 + startPoint.x - CGFloat(XDISTANCE*((PLAYGROUNDLINE-1)-index)) + CGFloat(i)*self.unitWidth, startPoint.y - CGFloat(YDISTANCE*index))
                }
                let unitInfo = unitInfoArray.objectAtIndex(nodeCount) as! ShapeUnitInfo
                unitInfo.unitPosition = node.position
                node.userData = NSMutableDictionary()
                node.userData!.setValue(unitInfo, forKey: "unitInfo")
                node.name = "unitShape"
                
                
                self.addChild(node)
                self.unitNodeArray.addObject(node)
                nodeCount+=1
            }
            index+=1
        }
    }
    
    func shapeFill(){
        let count = 3 - shapeArray.count
        for _ in 0..<count{
            let genShapeNode = self.randomShapeGenerator()
            shapeArray.addObject(genShapeNode)
            self.addChild(genShapeNode)
        }
        for i in 0..<3{
            let shapeNode = shapeArray.objectAtIndex(i) as! SKSpriteNode
            let location = (shapePosArray.objectAtIndex(i) as! NSValue).CGPointValue()
            let move = SKAction.moveTo(location, duration: 0.5)
            move.timingMode = SKActionTimingMode.EaseOut
            shapeNode.runAction(move)
            
        }
    }
    
    func addShapeFrame(){
        var node: SKSpriteNode!
        shapePosArray = NSMutableArray(capacity: 3)
        shapeArray = NSMutableArray(capacity: 3)
        
        for i in 0..<3{
            node = SKSpriteNode()
            node.size = CGSizeMake(100, 100)
            node.position = CGPointMake(CGRectGetMidX(self.frame) + CGFloat(i - 1)*120, 120)
            node.name = "shapeFrame_\(i)"
            shapePosArray.addObject(NSValue(CGPoint: node.position))
        }
        
        self.shapeFill()
    }
    
    func refreshPlayground(){
        let texture = SKTexture(imageNamed: "gray")
        for unitNode in unitNodeArray{
            let nodeInfo = (unitNode as! SKSpriteNode).userData?.objectForKey("unitInfo") as! ShapeUnitInfo
            nodeInfo.occupy = false
            (unitNode as! SKSpriteNode).texture = texture
        }
        self.dataInit()
        self.changeScore()
    }
    
    func changeScore(){
        let scoreLabel = self.childNodeWithName("scoreNumberLabel") as! SKLabelNode
        scoreLabel.text = "\(score)"
    }
    
    func dataInit(){
        score = 0
        if let _ = NSUserDefaults.standardUserDefaults().valueForKey("bestScore"){
            bestScore = NSUserDefaults.standardUserDefaults().valueForKey("bestScore")!.integerValue
        }
        self.unitInfoInit()
    }
    
    func randomShapeGenerator() -> SKSpriteNode{
        return RandomShapeMgr.sharedRandomShapeMgr().shapeGenerator()
    }
    
    
    func unitInfoInit(){
        if unitNodeArray != nil{
            return
        }
        
        unitInfoArray = NSMutableArray()
        let bundlePath = NSBundle.mainBundle().bundlePath
        let contentURL = NSURL(fileURLWithPath: bundlePath+"/unitInfo.json")
        let data = NSData(contentsOfURL: contentURL)
        do{
            let jsonDic = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            let unitInfos = jsonDic.objectForKey("unitInfos") as? NSArray
            if unitInfos != nil {
                for unitInfoDic in unitInfos! {
                    let unitInfo = ShapeUnitInfo()
                    let x = CGFloat(unitInfoDic.objectForKey("x")!.integerValue)
                    let y = CGFloat(unitInfoDic.objectForKey("y")!.integerValue)
                    let sn = unitInfoDic.objectForKey("serialNum")!.integerValue
                    let adjacentString = unitInfoDic.objectForKey("adjacent") as? String
                    let adjacents = adjacentString?.componentsSeparatedByString(" ")
                    unitInfo.unitLocation = CGPointMake(x, y)
                    unitInfo.serialNumber = sn
                    unitInfo.adjacentArray.addObjectsFromArray(adjacents!)
                    unitInfoArray.addObject(unitInfo)
                    
                    
                }
            }
        }catch{
            print("error: \(error)")
            return
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
