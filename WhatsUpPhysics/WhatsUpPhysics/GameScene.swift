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
    var gameManager: GameManager?
    var playable: Bool = true
    var playableRect: CGRect = CGRectZero
    
    var shootingPos: CGPoint = CGPointZero
    var shootingAngle: CGFloat = 0
    
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
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameScene.panDetected(_:)))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
        setupWorld()
    }
    
    // MARK: - SKPhysicsContactDelegate -
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Block | PhysicsCategory.Ball {
            let blockNode = (contact.bodyA.categoryBitMask == PhysicsCategory.Block) ? contact.bodyA.categoryBitMask : contact.bodyB.categoryBitMask
            if let whiteBlock = blockNode as? WhiteBlockNode {
                whiteBlock.onHit()
            }
        }
    }
    
    // MARK: - Helpers -
    func setupWorld() {
        // Physics
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    func newGame() {
        view!.presentScene(GameScene.level(currentLevel))
    }
    
    func lose() {
        // restart level
        performSelector(#selector(GameScene.newGame), withObject: nil, afterDelay: 3)
    }
    
    func win() {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            shootingPos = touch.locationInNode(self)
            
            let ball = Ball(circleOfRadius: 30)
            ball.position = shootingPos
            ball.zPosition = 1
            addChild(ball)
        }
    }
    
    func panDetected(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Changed {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            let dy = touchLocation.y - shootingPos.y
            let dx = touchLocation.x - shootingPos.x
            shootingAngle = atan2(dy, dx) //+ CGFloat(M_PI/2)
            //print("Shooting Angle: \(shootingAngle)")
        }
        if recognizer.state == .Ended {
            shootBall()
            //print("Ended")
        }
    }
    
    func shootBall() {
        let ball = Ball(circleOfRadius: 30)
        ball.position = shootingPos
        //ball.zPosition = 1
        addChild(ball)
        
        let dx = cos(shootingAngle) * 20
        let dy = sin(shootingAngle) * 20
        let target = CGVectorMake(dx, dy)
            
        ball.shoot(target)
    }
}
