//
//  GameManager.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/20/16.
//  Copyright © 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import Foundation

protocol GameManager {
    func loadHomeScene()
    func loadGameScene(level: Int)
    func loadLevelScene(win: Bool, level: Int)
}