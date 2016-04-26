//
//  GameViewController.swift
//  WhatsUpPhysics
//
//  Created by Ashton Wai on 4/13/16.
//  Copyright (c) 2016 Ashton Wai & Zachary Bebel. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameManager {
    var skView: SKView!
    let debugMode = true
    let debugPhysics = false
    let screenSize = CGSize(width: 2048, height: 1536)
    let scaleMode = SKSceneScaleMode.AspectFill
    var gameScene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        
        // configure view
        skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        loadHomeScene()
    }
    
    // MARK: - Scene Navigation -
    func loadHomeScene() {
        let scene = HomeScene(size: screenSize, scaleMode: scaleMode, gameManager: self)
        let reveal = SKTransition.crossFadeWithDuration(1.0)
        skView.presentScene(scene, transition: reveal)
    }
    
    func loadGameScene(transition: Bool, level: Int) {
        gameScene = GameScene(fileNamed: "Level\(level)")!
        gameScene?.scaleMode = scaleMode
        gameScene?.currentLevel = level
        gameScene?.gameManager = self
        
        // debug
        if debugMode {
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
        if debugPhysics {
            skView.showsPhysics = true
        }
        
        if transition {
            let reveal = SKTransition.crossFadeWithDuration(1.0)
            skView.presentScene(gameScene!, transition: reveal)
        } else {
            skView.presentScene(gameScene!)
        }
    }
    
    func loadLevelScene(win: Bool, level: Int) {
        let levelScene = LevelScene(size: screenSize, scaleMode: scaleMode, gameManager: self)
        levelScene.currentLevel = level
        levelScene.win = win
        let reveal = SKTransition.crossFadeWithDuration(1.0)
        skView.presentScene(levelScene, transition: reveal)
    }
    
    // MARK: - Notifications -
    func setupNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(GameViewController.willResignActive(_:)),
            name: UIApplicationWillResignActiveNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(GameViewController.didBecomeActive(_:)),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
    }
    func willResignActive(n:NSNotification){
        print("willResignActive notification")
        gameScene?.gameLoopPaused = true
    }
    func didBecomeActive(n:NSNotification){
        print("didBecomeActive notification")
        gameScene?.gameLoopPaused = false
    }
    func teardownNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(
            self)
    }
    
    // MARK: - View Lifecycle -
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
