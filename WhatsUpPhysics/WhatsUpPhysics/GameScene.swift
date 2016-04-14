//
//  GameScene.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/13/16.
//  Copyright (c) 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

// MARK: - Structs -
struct PhysicsCategory {
    static let None:    UInt32 = 0      // 0
    static let Ball:    UInt32 = 0b1    // 1
    static let Block:   UInt32 = 0b10   // 2
}

class GameScene: SKScene, UIGestureRecognizerDelegate, SKPhysicsContactDelegate {
    var playableRect: CGRect = CGRectZero
    let ball = SKSpriteNode(imageNamed: "ball")
    
    // MARK: - Level Setting -
    var currentLevel: Int = 0
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .AspectFill
        return scene
    }
    
    // MARK: - Initialization -
    override func didMoveToView(view: SKView) {
        let maxAspectRatio: CGFloat = 4.0 / 3.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight) / 2
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height-playableMargin*2)
        
        setupWorld()
    }
    
    // MARK: - Helpers -
    func setupWorld() {
        physicsWorld.contactDelegate = self
        
        // Ball Shape
        ball.name = "ball"
        ball.setScale(2.0)
        ball.position = CGPoint(x: playableRect.width * 0.50, y: playableRect.height * 0.50)
        
        addChild(ball)
        
        // Physics
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        
        // Contact Delegates
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Block | PhysicsCategory.Ball {
            let blockNode = (contact.bodyA.categoryBitMask == PhysicsCategory.Block) ? contact.bodyA.node : contact.bodyB.node
            
            guard blockNode != nil else {
                return
            }
            
            if let block = blockNode as? WhiteBlockNode {
                var isActive: Bool = true
                
                if let userData = block.userData, activeValue = userData["active"] {
                    isActive = activeValue as! Bool
                }
                
                if isActive {
                    block.userData = NSMutableDictionary()
                    block.userData = ["active": false]
                    block.onHit()
                }
            }
        }
    }
}
