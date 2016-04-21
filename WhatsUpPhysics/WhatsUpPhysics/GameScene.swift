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
            
            // which physicsBody belongs to a shape?
            let blockNode = contact.bodyA.categoryBitMask == PhysicsCategory.Block ? contact.bodyA.node : contact.bodyB.node
            
            // bail out if the shapeNode isn't in the scene anymore
            guard blockNode != nil else {
                print("blockNode is nil, so it's already been removed for some reason!")
                return
            }
            
            // cast the SKNode to an SKSpriteNode
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
            addChild(ball)
        }
    }
    
    func panDetected(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Changed {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            let dy = touchLocation.y - shootingPos.y
            let dx = touchLocation.x - shootingPos.x
            shootingAngle = atan2(dy, dx)
        }
        if recognizer.state == .Ended {
            shootBall()
        }
    }
    
    func shootBall() {
        let ball = Ball(circleOfRadius: 30)
        ball.position = shootingPos
        addChild(ball)
        
        let force: CGFloat = 20
        let dx = cos(shootingAngle) * force
        let dy = sin(shootingAngle) * force
        let target = CGVectorMake(dx, dy)
            
        ball.shoot(target)
    }
}
