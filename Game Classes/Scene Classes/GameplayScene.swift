//
//  GameplayScene.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/15/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameplayScene: SKScene, SKPhysicsContactDelegate {
    
    private var player: Player?
    private var mainCamera: SKCameraNode?
    private var cloudController = CloudController()
    
    private var canMove = false
    private var left = false
    private var bg1: BGClass?
    private var bg2: BGClass?
    private var bg3: BGClass?
    
    private var acceleration = CGFloat()
    private var cameraSpeed = CGFloat()
    private var maxSpeed = CGFloat()
    
    private var center: CGFloat?
    private let distanceBetweenClouds = CGFloat(240)
    private var previousPlayerPositionY = CGFloat(0)
    private let minX = CGFloat(-145)
    private let maxX = CGFloat(145)
    private let playerMinX = CGFloat(-200)
    private let playerMaxX = CGFloat(200)
    
    private var cameraReCloudDistance: CGFloat?
    private var pausePanel: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self;
        center = (self.scene?.size.width)! / (self.scene?.size.height)!
        player = self.childNode(withName: "Player") as? Player
        player?.initializePlayerAndAnimations()
        previousPlayerPositionY = (player?.position.y)!
        
        cloudController.arrangeCloudsAndCollectableInScene(scene: self, distanceBetweenClouds: distanceBetweenClouds, center: center!, minX: minX, maxX: maxX, initialClouds: true)
        
        getBackgroundAndCamera()
        getLabels()
        setSpeed()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveCamera()
        managePlayer()
        manageBackground()
        reCloud()
        reScore()
        removeOffscreenChildren()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let playerBody = contact.bodyA.node?.name == "Player" ? contact.bodyA : contact.bodyB
        let objectBody = contact.bodyA.node?.name == "Player" ? contact.bodyB : contact.bodyA
        
        if playerBody.node?.name == "Player" {
            if objectBody.node?.name == "Coin" {
                self.run(SKAction.playSoundFileNamed("Coin Sound.wav", waitForCompletion: false))
                GameplayController.instance.incrementCoin()
                objectBody.node?.removeFromParent()
            }
            
            if objectBody.node?.name == "Life" {
                self.run(SKAction.playSoundFileNamed("Life Sound.wav", waitForCompletion: false))
                GameplayController.instance.incrementLife()
                objectBody.node?.removeFromParent()
            }
            
            if objectBody.node?.name == "Dark Cloud" {
                self.scene?.isPaused = true
                GameplayController.instance.life -= 1
                if GameplayController.instance.life >= 0 {
                    GameplayController.instance.lifeLabel?.text = "x\(GameplayController.instance.life)"
                } else {
                    createScorePanel()
                }
                
                playerBody.node?.removeFromParent()
                Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false)
            }
            
        }
    }
    
    func getLabels() {
        GameplayController.instance.scoreLabel = self.mainCamera?.childNode(withName: "Score Label") as? SKLabelNode
        GameplayController.instance.coinLabel = self.mainCamera?.childNode(withName: "Coin Label") as? SKLabelNode
        GameplayController.instance.lifeLabel = self.mainCamera?.childNode(withName: "Life Label") as? SKLabelNode
        GameplayController.instance.initializeLabel()
    }
    
    func getBackgroundAndCamera() {
        bg1 = self.childNode(withName: "BG 1") as? BGClass
        bg2 = self.childNode(withName: "BG 2") as? BGClass
        bg3 = self.childNode(withName: "BG 3") as? BGClass
        mainCamera = self.childNode(withName: "Main Camera") as? SKCameraNode
        cameraReCloudDistance = (mainCamera?.position.y)! - 400
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if !(self.scene?.isPaused)! && atPoint(location).name != "Pause" {
                canMove = true
                left = location.x < center!
                // left = location.x < 0
                player?.animatePlayer(left: left)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMove = false
        player?.stopPlayerAnimation()
        
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Pause" && !(self.scene?.isPaused)!{
                self.scene?.isPaused = true
                createPausePanel()
            } else if atPoint(location).name == "Resume" {
                self.scene?.isPaused = false
                pausePanel?.removeFromParent()
            } else if atPoint(location).name == "Quit" {
                let scene = MainMenuScene(fileNamed: "MainMenu")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
            }
        }
    }
    
    func managePlayer() {
        if canMove {
            player?.movePlayer(toLeft: left)
        }
        
        if (player?.position.x)! > playerMaxX {
            player?.position.x = playerMaxX
        }
        
        if (player?.position.x)! < playerMinX {
            player?.position.x = playerMinX
        }
        
        if (player?.position.y)! - 465 > (mainCamera?.position.y)! {
            self.scene?.isPaused = true
            GameplayController.instance.life -= 1
            if GameplayController.instance.life >= 0 {
                GameplayController.instance.lifeLabel?.text = "x\(GameplayController.instance.life)"
            } else {
                createScorePanel()            }
            
            Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false)
        }
        
        if (player?.position.y)! + 465 < (mainCamera?.position.y)! {
            self.scene?.isPaused = true
            GameplayController.instance.life -= 1
            if GameplayController.instance.life >= 0 {
                GameplayController.instance.lifeLabel?.text = "x\(GameplayController.instance.life)"
            } else {
                createScorePanel()
            }
            
            Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false)
        }
    }
    
    func moveCamera() {
        if cameraSpeed < maxSpeed {
            cameraSpeed += acceleration
        }
        self.mainCamera?.position.y -= cameraSpeed
    }
    
    func createPausePanel() {
        pausePanel = SKSpriteNode(imageNamed: "Pause Menu")
        let resumeButton = SKSpriteNode(imageNamed: "Resume Button")
        let quitButton = SKSpriteNode(imageNamed: "Quit Button 2")
        
        pausePanel?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pausePanel?.xScale = 1.6
        pausePanel?.yScale = 1.6
        pausePanel?.zPosition = 4
        pausePanel?.position = CGPoint(x: (self.mainCamera?.frame.size.width)! / 2, y: (self.mainCamera?.frame.size.height)! / 2)
        
        resumeButton.name = "Resume"
        resumeButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        resumeButton.zPosition = 5
        resumeButton.position = CGPoint(x: (self.mainCamera?.frame.size.width)! / 2, y: (self.mainCamera?.frame.size.height)! / 2 + 25)
        
        quitButton.name = "Quit"
        quitButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quitButton.zPosition = 5
        quitButton.position = CGPoint(x: (self.mainCamera?.frame.size.width)! / 2, y: (self.mainCamera?.frame.size.height)! / 2 - 45)
        
        self.mainCamera?.addChild(pausePanel!)
        pausePanel?.addChild(resumeButton)
        pausePanel?.addChild(quitButton)
    }
    
    func createScorePanel() {
        let scorePanel = SKSpriteNode(imageNamed: "Show Score")
        let scoreLabel = SKLabelNode(fontNamed: "Blow")
        let coinLabel = SKLabelNode(fontNamed: "Blow")

        scorePanel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scorePanel.xScale = 1
        scorePanel.yScale = 1
        scorePanel.zPosition = 4
        scorePanel.position = CGPoint(x: (self.mainCamera?.frame.size.width)! / 2, y: (self.mainCamera?.frame.size.height)! / 2)
        
        scoreLabel.fontSize = 38
        scoreLabel.text = "\(GameplayController.instance.score)"
        scoreLabel.zPosition = 5
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: scorePanel.position.x / 2 - 90, y: scorePanel.position.y / 2 + 17)
        
        coinLabel.fontSize = 38
        coinLabel.text = "\(GameplayController.instance.coin)"
        coinLabel.zPosition = 5
        coinLabel.horizontalAlignmentMode = .left
        coinLabel.position = CGPoint(x: scorePanel.position.x / 2 - 90, y: scorePanel.position.y / 2 - 102)
        
        self.mainCamera?.addChild(scorePanel)
        scorePanel.addChild(scoreLabel)
        scorePanel.addChild(coinLabel)
    }
    
    func manageBackground() {
        bg1?.moveBG(camera: mainCamera!)
        bg2?.moveBG(camera: mainCamera!)
        bg3?.moveBG(camera: mainCamera!)
    }
    
    func setSpeed() {
        if GameManager.instance.getEasyDifficulty() {
            acceleration = 0.001
            cameraSpeed = 2
            maxSpeed = 4
        }
        
        if GameManager.instance.getMediumDifficulty() {
            acceleration = 0.002
            cameraSpeed = 2.5
            maxSpeed = 6
        }
        
        if GameManager.instance.getHardDifficulty() {
            acceleration = 0.003
            cameraSpeed = 3
            maxSpeed = 7
        }
    }
    
    func removeOffscreenChildren() {
        for child in children {
            if child.position.y > (mainCamera?.position.y)! + (self.scene?.size.height)! && child.name?.range(of:"BG") == nil {
                child.removeFromParent()
            }
        }
    }
    
    func reCloud() {
        if cameraReCloudDistance! > (mainCamera?.position.y)! {
            cameraReCloudDistance = (mainCamera?.position.y)! - 400
            cloudController.arrangeCloudsAndCollectableInScene(scene: self, distanceBetweenClouds: distanceBetweenClouds, center: center!, minX: minX, maxX: maxX, initialClouds: false)
        }
    }
    
    func reScore() {
        if (player?.position.y)! < previousPlayerPositionY {
            GameplayController.instance.incrementScore()
            previousPlayerPositionY = (player?.position.y)!
        }
    }
    
    @objc private func playerDied() {
        if GameplayController.instance.life >= 0 {
            GameManager.instance.gameRestartedPlayerDied = true;
            
            let scene = GameplayScene(fileNamed: "GameplayScene");
            scene?.scaleMode = SKSceneScaleMode.aspectFill;
            self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
        } else {
            if GameManager.instance.getEasyDifficulty() {
                let highscore = GameManager.instance.getEasyDifficultyScore();
                let coinScore = GameManager.instance.getEasyDifficultyCoinScore();
                
                if highscore < Int32(GameplayController.instance.score) {
                    GameManager.instance.setEasyDifficultyScore(Int32(GameplayController.instance.score));
                }
                
                if coinScore < Int32(GameplayController.instance.coin) {
                    GameManager.instance.setEasyDifficultyCoinScore(Int32(GameplayController.instance.coin));
                }
                
            } else if GameManager.instance.getMediumDifficulty() {
                let highscore = GameManager.instance.getMediumDifficultyScore();
                let coinScore = GameManager.instance.getMediumDifficultyCoinScore();
                
                if highscore < Int32(GameplayController.instance.score) {
                    GameManager.instance.setMediumDifficultyScore(Int32(GameplayController.instance.score));
                }
                
                if coinScore < Int32(GameplayController.instance.coin) {
                    GameManager.instance.setMediumDifficultyCoinScore(Int32(GameplayController.instance.coin));
                }
                
            } else if GameManager.instance.getHardDifficulty() {
                let highscore = GameManager.instance.getHardDifficultyScore();
                let coinScore = GameManager.instance.getHardDifficultyCoinScore();
                
                if highscore < Int32(GameplayController.instance.score) {
                    GameManager.instance.setHardDifficultyScore(Int32(GameplayController.instance.score));
                }
                
                if coinScore < Int32(GameplayController.instance.coin) {
                    GameManager.instance.setHardDifficultyCoinScore(Int32(GameplayController.instance.coin));
                }
                
            }
            
            GameManager.instance.saveData();
            
            let scene = MainMenuScene(fileNamed: "MainMenu");
            scene?.scaleMode = SKSceneScaleMode.aspectFill;
            self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
        }
    }
}
