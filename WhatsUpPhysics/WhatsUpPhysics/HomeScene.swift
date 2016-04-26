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
        self.start = SKLabelNode(fontNamed: "Spongeboy Me Bob")
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "home.jpg")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.xScale = 1.8
        background.yScale = 1.8
        addChild(background)
        
        let logo = SKLabelNode(fontNamed: "Spongeboy Me Bob")
        logo.text = "Whats Up Physics"
        logo.fontSize = 200
        logo.fontColor = UIColor.blueColor()
        logo.position = CGPointMake(size.width/2, size.height/2 + 200)
        logo.zPosition = 1
        addChild(logo)
        
        start.position = CGPointMake(size.width/2, size.height/2 - 200)
        start.zPosition = 1
        start.text = "Start"
        start.fontSize = 70
        start.fontColor = UIColor.blueColor()
        addChild(start)
    }
    
    // MARK: - Event Handlers -
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            if nodeAtPoint(touch.locationInNode(self)) == start {
                gameManager.loadGameScene(true, level: 0)
            }
        }
    }
}
