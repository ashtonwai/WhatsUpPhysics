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
        runAction(SKAction.removeFromParent())
    }
}
