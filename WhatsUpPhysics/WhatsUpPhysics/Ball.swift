//
//  Bullet.swift
//  PointShooter
//
//  Created by Ashton Wai on 3/4/16.
//  Copyright © 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

class Ball : SKShapeNode {
    
    init(circleOfRadius: CGFloat) {
        super.init()
        
        let diameter = circleOfRadius * 2
        let center = CGPoint(x: -circleOfRadius, y: -circleOfRadius)
        let size = CGSize(width: diameter, height: diameter)
        
        self.name = "ball"
        
        self.path = CGPathCreateWithEllipseInRect(CGRect(origin: center, size: size), nil)
        self.fillColor = SKColor.whiteColor()
        self.fillTexture = SKTexture.init(image: UIImage(named: "snowball")!)
        self.lineWidth = 0
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Block
        self.physicsBody?.collisionBitMask = PhysicsCategory.Block
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.restitution = 1
        self.physicsBody?.friction = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        /*
        // Emitter
        let emitter = SKEmitterNode(fileNamed: "Fireball")!
        emitter.position = self.position
        emitter.zPosition = self.zPosition + 1
        addChild(emitter)
        */
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot(target: CGVector) {
        self.physicsBody?.applyImpulse(target)
    }
}