//
//  WhiteBlockNode.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/13/16.
//  Copyright © 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import SpriteKit

class WhiteBlockNode: SKSpriteNode {
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.name = "block"
    }
 
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.name = "block"
    }
    
    func onHit() {
        runAction(SKAction.removeFromParent())
    }
}
