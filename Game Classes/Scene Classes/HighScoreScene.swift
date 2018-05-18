//
//  HighScoreScene.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/16/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import SpriteKit
import GameplayKit

class HightScoreScene: SKScene {
    private var scoreLabel: SKLabelNode?
    private var coinLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        getLabel()
        setScore()
    }
    
    private func getLabel() {
        scoreLabel = self.childNode(withName: "Score Label") as? SKLabelNode
        coinLabel = self.childNode(withName: "Coin Label") as? SKLabelNode
    }
    
    private func setScore() {
        if GameManager.instance.getEasyDifficulty() {
            scoreLabel?.text = "\(GameManager.instance.getEasyDifficultyScore())"
            coinLabel?.text = "\(GameManager.instance.getEasyDifficultyCoinScore())"
        } else if(GameManager.instance.getMediumDifficulty()) {
            scoreLabel?.text = "\(GameManager.instance.getMediumDifficultyScore())"
            coinLabel?.text = "\(GameManager.instance.getMediumDifficultyCoinScore())"
        } else if(GameManager.instance.getHardDifficulty()) {
            scoreLabel?.text = "\(GameManager.instance.getHardDifficultyScore())"
            coinLabel?.text = "\(GameManager.instance.getHardDifficultyCoinScore())"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Back" {
                let scene = MainMenuScene(fileNamed: "MainMenu")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
            }
        }
    }
}
