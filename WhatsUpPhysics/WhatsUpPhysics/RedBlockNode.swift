//
//  RedBlockNode.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/26/16.
//  Copyright © 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

class RedBlockNode: SKSpriteNode {
    
    func onHit(ball: Ball) {
        
        // Calc explosive force
        let direction = ball.position - self.position
        let force = CGVectorMake(direction.x, direction.y).normalized() * 30
        
        // Apply force
        ball.shoot(force)
        
        // Remove block
        runAction(SKAction.removeFromParent())
        
    }
}
