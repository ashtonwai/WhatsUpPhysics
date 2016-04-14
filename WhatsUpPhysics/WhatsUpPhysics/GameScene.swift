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
        ball.name = "ball"
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
    
    // MARK: - SKPhysicsContactDelegate Methods -
    func didBeginContact(contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Shape | PhysicsCategory.Target {
            print("A shape hit the target!")
            
            // which physicsBody belongs to a shape?
            var shapeNode:SKNode?
            if contact.bodyA.categoryBitMask == PhysicsCategory.Shape {
                shapeNode = contact.bodyA.node
            } else {
                shapeNode = contact.bodyB.node
            }
            
            // bail out if the shapeNode isn't in the scene anymore
            guard shapeNode != nil else {
                print("shapeNode is nil, so it's already been removed for some reason!")
                return
            }
            
            // cast the SKNode to an SKSpriteNode
            // Use SKSpriteNode built-in dictionary property, "userData"
            if let spriteNode = shapeNode as? SKSpriteNode {
                
                var isActive:Bool = false
                
                // does the userData dictionary exist, is there an "active" value?
                if let userData = spriteNode.userData, activeValue = userData["active"] {
                    // grab the value
                    isActive = activeValue as! Bool
                }
                
                if isActive {
                    print("DO NOT runAction() on  \(spriteNode.name!)")
                } else {
                    // set "active" to true so we can only run the action once
                    print("runAction() on  \(spriteNode.name!)")
                    spriteNode.userData = NSMutableDictionary()
                    spriteNode.userData = ["active":true]
                    
                    // trigger impulse on shapes except the square
                    if spriteNode.name == "ball" {
                        let bounceAction = SKAction.sequence([
                            SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
                            SKAction.runBlock({ print("bounce") }),
                            SKAction.applyImpulse(CGVectorMake(-500, -500), duration: 0.1),
                            SKAction.waitForDuration(0.5), // set active back to false after 1/2 a second so that the shapes can trigger the bounceAction more than once
                            SKAction.runBlock({
                                print("reset active on \(spriteNode.name)")
                                spriteNode.userData = ["active":false]
                            })
                            ])
                        
                        spriteNode.runAction(bounceAction)
                    }
                    
                }
                
            }
            
        }
    }

}
