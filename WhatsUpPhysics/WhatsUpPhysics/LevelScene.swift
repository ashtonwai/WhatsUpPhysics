//
//  LevelScene.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/26/16.
//  Copyright © 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    let gameManager: GameManager
    var currentLevel: Int = 0
    var win: Bool = true
    
    // MARK: - Initialization -
    init(size: CGSize, scaleMode: SKSceneScaleMode, gameManager: GameManager) {
        self.gameManager = gameManager
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "level.jpg")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.xScale = 1.8
        background.yScale = 1.8
        addChild(background)
        
        let nextLevel = SKLabelNode(fontNamed: "Spongeboy Me Bob")
        nextLevel.zPosition = 1
        nextLevel.fontSize = 300
        nextLevel.fontColor = UIColor.blueColor()
        nextLevel.text = "\(currentLevel)"
        nextLevel.alpha = 0
        
        let fadeTime = 0.5
        let moveTime = 0.5
        let waitTime = 0.5
        
        if win {
            nextLevel.position = CGPoint(x: self.size.width/2, y: -300)
            addChild(nextLevel)
            
            nextLevel.runAction(SKAction.sequence([
                SKAction.group([
                    SKAction.fadeInWithDuration(fadeTime),
                    SKAction.moveToY(self.size.height/2-100, duration: moveTime)
                ]),
                SKAction.waitForDuration(waitTime),
                SKAction.group([
                    SKAction.fadeOutWithDuration(fadeTime),
                    SKAction.moveToY(self.size.height+300, duration: moveTime)
                ]),
                SKAction.runBlock({
                    self.gameManager.loadGameScene(self.currentLevel)
                })
            ]))
        } else {
            nextLevel.position = CGPoint(x: self.size.width/2, y: self.size.height+300)
            addChild(nextLevel)
            
            nextLevel.runAction(SKAction.sequence([
                SKAction.group([
                    SKAction.fadeInWithDuration(fadeTime),
                    SKAction.moveToY(self.size.height/2-100, duration: moveTime)
                ]),
                SKAction.waitForDuration(waitTime),
                SKAction.group([
                    SKAction.fadeOutWithDuration(fadeTime),
                    SKAction.moveToY(-300, duration: moveTime)
                ]),
                SKAction.runBlock({
                    self.gameManager.loadGameScene(self.currentLevel)
                })
            ]))
        }
    }
}
