//
//  GameScene.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/13/16.
//  Copyright (c) 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

struct SpriteLayer {
    static let Background   : CGFloat = 0
    static let PlayableRect : CGFloat = 1
    static let HUD          : CGFloat = 2
    static let Sprite       : CGFloat = 3
    static let Message      : CGFloat = 4
}

struct PhysicsCategory {
    static let None     : UInt32 = 0        // 0
    static let Sand     : UInt32 = 0b1      // 1
    static let Shape    : UInt32 = 0b10     // 2
    static let Target   : UInt32 = 0b100    // 4
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
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height-playableMargin*2)
    }
    
    // MARK: - Helpers -
    func setupWorld() {
        
        // Ball Shape
        ball.name = "shape"
        ball.setScale(2.0)
        ball.position = CGPoint(x: playableRect.width * 0.50, y: playableRect.height * 0.50)
        ball.zPosition = SpriteLayer.Sprite
        
        addChild(ball)
        
        // Physics
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        
        // Contact Delegates
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Shape
    }
}
