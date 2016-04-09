//
//  GameViewController.swift
//  Frvr
//
//  Created by 谭钧豪 on 16/4/7.
//  Copyright (c) 2016年 谭钧豪. All rights reserved.
//

import UIKit
import SpriteKit

enum ShapeUnitDirector: Int {
    case SUDNone = -1
    case SUDTopLeft = 0
    case SUDTopRight
    case SUDRight
    case SUDBottomRight
    case SUDBottomLeft
    case SUDLeft
}
enum ShapeType: Int {
    case STypeSingle = 0
    case STypeLine
    case STypeLeftSlashLine
    case STypeRightSlashLine
    case STypeLeftSquare
    case STypeRightSquare
    case STypeSquare
    case STypeLLTCompositeOne
    case STypeLRTCompositeOne
    case STypeLLBCompositeOne
    case STypeLRBCompositeOne
    case STypeRLTCompositeOne
    case STypeRRTCompositeOne
    case STypeRLBCompositeOne
    case STypeRRBCompositeOne
    case STypeTopLeftCompositeTwo
    case STypeBottomLeftCompositeTwo
    case STypeTopRightCompositeTwo
    case STypeBottomRightCompositeTwo
    case STypeZeroCompositeThree
    case STypeOneCompositeThree
    case STypeTwoCompositeThree
    case STypeThreeCompositeThree
    case STypeFourCompositeThree
    case STypeFiveCompositeThree
}

class GameViewController: UIViewController {
    
    var gameScene:GameScene!
    var popAlert:UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()

        gameScene = GameScene(size: self.view.bounds.size)
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        gameScene.scaleMode = .AspectFill
        
        skView.presentScene(gameScene)
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.gameOver(_:)), name: "GameOver", object: nil)
        
        
        
        
    }
    
    func gameOver(sender:NSNotification){
        let score = sender.object as! Int
        var beststr = ""
        if let bestScore = NSUserDefaults.standardUserDefaults().valueForKey("bestScore"){
            if score > bestScore.integerValue{
                NSUserDefaults.standardUserDefaults().setValue(score, forKey: "bestScore")
                beststr = "\n最高纪录:\(score)"
            }else{
                beststr = "\n最高纪录:\(bestScore)"
            }
        }else{
            NSUserDefaults.standardUserDefaults().setValue(score, forKey: "bestScore")
        }
        popAlert = UIAlertController(title: "提示", message: "游戏结束\n得分:\(score)"+beststr, preferredStyle: UIAlertControllerStyle.Alert)
        popAlert.addAction(UIAlertAction(title: "重新开始", style: UIAlertActionStyle.Default, handler: { (resetAction) in
            self.gameScene.startNewGame()
        }))
        popAlert.addAction(UIAlertAction(title: "关闭提示", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(popAlert, animated: true, completion: nil)
    }
    


    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
