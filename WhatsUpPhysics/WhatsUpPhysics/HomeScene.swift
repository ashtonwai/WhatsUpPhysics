//
//  HomeScene.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/20/16.
//  Copyright © 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let gameManager: GameManager
    let start: SKLabelNode
    var myLevel: Int = 0
    
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
        // get last played level
        if let lastLevel = userDefaults.valueForKey("lastLevel") as? Int {
            myLevel = lastLevel
        } else {
            userDefaults.setValue(0, forKey: "lastLevel")
            userDefaults.synchronize()
        }
        
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
        logo.position = CGPointMake(size.width/2, size.height/2 + 300)
        logo.zPosition = 1
        addChild(logo)
        
        let lastLevelLabel = SKLabelNode(fontNamed: "Spongeboy Me Bob")
        lastLevelLabel.text = "Last Played Level"
        lastLevelLabel.fontSize = 50
        lastLevelLabel.fontColor = UIColor.blueColor()
        lastLevelLabel.position = CGPointMake(size.width/2, size.height/2 + 100)
        lastLevelLabel.zPosition = 1
        addChild(lastLevelLabel)
        
        let lastLevel = SKLabelNode(fontNamed: "Spongeboy Me Bob")
        lastLevel.text = "\(myLevel)"
        lastLevel.fontSize = 150
        lastLevel.fontColor = UIColor.blueColor()
        lastLevel.position = CGPointMake(size.width/2, size.height/2 - 100)
        lastLevel.zPosition = 1
        addChild(lastLevel)
        
        start.position = CGPointMake(size.width/2, size.height/2 - 300)
        start.zPosition = 1
        start.text = "Start"
        start.fontSize = 100
        start.fontColor = UIColor.blueColor()
        addChild(start)
    }
    
    // MARK: - Event Handlers -
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            if nodeAtPoint(touch.locationInNode(self)) == start {
                gameManager.loadGameScene(true, level: myLevel)
            }
        }
    }
}
