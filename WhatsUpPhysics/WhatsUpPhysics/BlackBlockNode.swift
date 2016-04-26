//
//  BlackBlockNode.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/26/16.
//  Copyright © 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

class BlackBlockNode: SKSpriteNode {
    func onHit() {
        runAction(SKAction.sequence([
            SKAction.scaleBy(1.1, duration: 0.1),
            SKAction.scaleBy(0.9, duration: 0.1)
        ]))
    }
}
