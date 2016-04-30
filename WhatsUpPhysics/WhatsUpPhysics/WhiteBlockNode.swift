//
//  WhiteBlockNode.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/13/16.
//  Copyright © 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

class WhiteBlockNode: SKSpriteNode {
    
    func onHit(scene: GameScene) {
        
        // Trigger explosion
        let emitter = SKEmitterNode(fileNamed: "Explosion")!
        emitter.position = self.position
        emitter.zPosition = 1
        scene.addChild(emitter)
        
        // Remove block
        runAction(SKAction.removeFromParent())
        
        // Play sound and then remove explosion
        runAction(SKAction.sequence([
            SKAction.playSoundFileNamed("break white block.mp3", waitForCompletion: false),
            SKAction.waitForDuration(0.3),
            SKAction.runBlock() {
                emitter.removeFromParent()
            }
        ]))
        
    }
}
