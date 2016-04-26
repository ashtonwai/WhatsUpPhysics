//
//  HomeScene.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/20/16.
//  Copyright © 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {
    let gameManager: GameManager
    let start: SKLabelNode
    
    // MARK: - Initialization -
    init(size: CGSize, scaleMode: SKSceneScaleMode, gameManager: GameManager) {
        self.gameManager = gameManager
        self.start = SKLabelNode(fontNamed: "Noteworthy-Bold")
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let logo = SKLabelNode(fontNamed: "Noteworthy-Bold")
        logo.text = "WhatsUpPhysics"
        logo.fontSize = 200
        logo.position = CGPointMake(size.width/2, size.height/2 + 200)
        logo.zPosition = 1
        addChild(logo)
        
        start.position = CGPointMake(size.width/2, size.height/2 - 200)
        start.zPosition = 1
        start.text = "Start"
        start.fontSize = 70
        addChild(start)
    }
    
    // MARK: - Event Handlers -
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            if nodeAtPoint(touch.locationInNode(self)) == start {
                gameManager.loadGameScene(0)
            }
        }
    }
}
