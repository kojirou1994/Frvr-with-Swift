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

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: self.view.bounds.size)
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
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
