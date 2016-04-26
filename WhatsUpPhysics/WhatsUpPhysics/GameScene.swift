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
    static let Bounds:  UInt32 = 0b100  // 4
}

class GameScene: SKScene, UIGestureRecognizerDelegate, SKPhysicsContactDelegate {
    var gameManager: GameManager?
    var playable: Bool = true
    var playableRect: CGRect = CGRectZero
    
    var shootingPos: CGPoint = CGPointZero
    var shootingAngle: CGFloat = 0
    var dragPos: CGPoint = CGPointZero
    
    let aimStartDot: SKShapeNode = Ball(circleOfRadius: 10)
    let aimEndDot: SKShapeNode = Ball(circleOfRadius: 10)
    let aimLine: SKShapeNode = SKShapeNode()
    
    var shooting = false    // When the ball is moving
    var newTouch = false    // When the player has lifted their finger and placed it down again
    var loading = false     // When the game is performing a transition between scenes
    var blockCount = 0
    
    // MARK: - Level Setting -
    let levelCount: Int = 2
    var currentLevel: Int = 0
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .AspectFill
        return scene
    }
    
    // MARK: - Initialization -
    override func didMoveToView(view: SKView) {
        
        // Calc visible screen space
        let maxAspectRatio: CGFloat = 4.0 / 3.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight) / 2
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height-playableMargin*2)
        
        // Set up listener for dragging
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameScene.panDetected(_:)))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
        // Set up game world
        setupWorld()
    }
    
    // MARK: - SKPhysicsContactDelegate -
    func didBeginContact(contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Ball v Block
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
                blockCount -= 1
            }
            
        }
        
        // Ball v Bounds
        if collision == PhysicsCategory.Bounds | PhysicsCategory.Ball {
            
            // which physicsBody belongs to a shape?
            let ballNode = contact.bodyA.categoryBitMask == PhysicsCategory.Ball ? contact.bodyA.node : contact.bodyB.node
            
            // bail out if the shapeNode isn't in the scene anymore
            guard ballNode != nil else {
                print("ballNode is nil, so it's already been removed for some reason!")
                return
            }
            
            // cast the SKNode to an SKSpriteNode
            if let ball = ballNode as? Ball {
                
                shooting = false
                loading = true
                ball.removeFromParent()
                //print("Ball destroyed")
                
                // check win state
                if blockCount <= 0 {
                    win()
                } else {
                    lose()
                }
            }
            
        }
    }
    
    // MARK: - Helpers -
    func setupWorld() {
        
        // Physics World
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // Create bounding box for Ball
        
        // Path
        let boundingOffset: CGFloat = 50
        let boundingRect = CGRect(
            x: playableRect.minX - boundingOffset,
            y: playableRect.minY - boundingOffset,
            width: playableRect.width + boundingOffset*2,
            height: playableRect.height + boundingOffset*2)
        
        // Shape
        let boundingBox = SKShapeNode()
        boundingBox.path = CGPathCreateWithRect(boundingRect, nil)
        boundingBox.strokeColor = UIColor.whiteColor()
        boundingBox.lineWidth = 5
        
        // Physics
        boundingBox.physicsBody = SKPhysicsBody(edgeLoopFromRect: boundingRect)
        boundingBox.physicsBody?.categoryBitMask = PhysicsCategory.Bounds
        boundingBox.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        boundingBox.physicsBody?.collisionBitMask = PhysicsCategory.Ball
        addChild(boundingBox)
        
        
        // Aiming nodes
        aimLine.strokeColor = UIColor.redColor()
        aimLine.lineWidth = 5
        addChild(aimLine)
        addChild(aimStartDot)
        addChild(aimEndDot)
    }
    
    func newGame() {
        
        // Load scene
        view!.presentScene(GameScene.level(currentLevel + 1))
        loading = false
        
        // Get block count
        self.enumerateChildNodesWithName("block") {
            node, stop in
            self.blockCount += 1
        }
        print("Number of blocks in Level \(self.currentLevel + 1): \(self.blockCount)")
    }
    
    func lose() {
        // Restart level
        performSelector(#selector(GameScene.newGame), withObject: nil, afterDelay: 1)
    }
    
    func win() {
        // Next level
        // If final level, loop back to first
        currentLevel = currentLevel % levelCount
        print("Current level: \(currentLevel)")
        performSelector(#selector(GameScene.newGame), withObject: nil, afterDelay: 1)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // On tap
        for touch in touches {
            
            // Set new touch
            newTouch = true
            
            // Get shoot position
            shootingPos = touch.locationInNode(self)
        }
    }
    
    func panDetected(recognizer: UIPanGestureRecognizer) {
        if currentLevel == 0 {
            if recognizer.state == .Began {
                self.enumerateChildNodesWithName("demo") {
                    node, stop in
                    node.removeFromParent()
                }
            }
        }
        
        // On drag
        if recognizer.state == .Changed {
            
            // Prevent preparing next shot during current shot
            if shooting {
                newTouch = false
            }
                
            // Get drag position
            let touchLocation = recognizer.locationInView(recognizer.view)
            dragPos = self.convertPointFromView(touchLocation)
            
            if !shooting && newTouch && !loading {
                // Draw aim line
                drawAim()
            }
        }
        
        // On release
        if recognizer.state == .Ended {
            
            if !shooting && newTouch && !loading {
                // Shoot ball
                shootBall()
                
                // "Hide" shoot line
                aimLine.path = CGPathCreateMutable()
                aimStartDot.position = CGPoint(x: -100, y: -100) // Somewhere offscreen beyond bounds
                aimEndDot.position = CGPoint(x: -100, y: -100)
            }
        }
    }
    
    func shootBall() {
        
        shooting = true
        
        // Create a new Ball
        let ball = Ball(circleOfRadius: 30)
        ball.position = shootingPos
        addChild(ball)
        
        // Calc angle
        var dy = dragPos.y - shootingPos.y
        var dx = dragPos.x - shootingPos.x
        shootingAngle = atan2(dy, dx)
        
        // Calc force
        let force: CGFloat = 20
        dx = cos(shootingAngle) * force
        dy = sin(shootingAngle) * force
        let target = CGVectorMake(dx, dy)
        
        // Apply force
        ball.shoot(target)
    }
    
    func drawAim() {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, shootingPos.x, shootingPos.y)
        CGPathAddLineToPoint(path, nil, dragPos.x, dragPos.y)
        aimLine.path = path
        aimStartDot.position = shootingPos
        aimEndDot.position = dragPos
    }
}
