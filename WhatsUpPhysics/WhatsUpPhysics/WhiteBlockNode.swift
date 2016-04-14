//
//  WhiteBlockNode.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/13/16.
//  Copyright © 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

class WhiteBlockNode: SKSpriteNode {
    func onHit() {
        runAction(SKAction.group([
            SKAction.scaleTo(1.5, duration: 0.5),
            SKAction.fadeOutWithDuration(0.5),
            SKAction.removeFromParent()
        ]))
    }
}
