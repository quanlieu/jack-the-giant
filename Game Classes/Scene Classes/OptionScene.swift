//
//  OptionScene.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/16/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import SpriteKit
import GameplayKit

class OptionScene: SKScene {
    private var easyButton: SKSpriteNode?
    private var mediumButton: SKSpriteNode?
    private var hardButton: SKSpriteNode?
    private var sign: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        getNode()
        setSign()
    }
    
    private func getNode() {
        easyButton = self.childNode(withName: "Easy Button") as? SKSpriteNode
        mediumButton = self.childNode(withName: "Medium Button") as? SKSpriteNode
        hardButton = self.childNode(withName: "Hard Button") as? SKSpriteNode
        sign = self.childNode(withName: "Sign") as? SKSpriteNode
    }
    
    private func set(difficulty level: String) {
        switch level {
        case "easy":
            GameManager.instance.setEasyDifficulty(true)
            GameManager.instance.setMediumDifficulty(false)
            GameManager.instance.setHardDifficulty(false)
        case "medium":
            GameManager.instance.setEasyDifficulty(false)
            GameManager.instance.setMediumDifficulty(true)
            GameManager.instance.setHardDifficulty(false)
        case "hard":
            GameManager.instance.setEasyDifficulty(false)
            GameManager.instance.setMediumDifficulty(false)
            GameManager.instance.setHardDifficulty(true)
        default:
            break
        }
        GameManager.instance.saveData()
    }
    
    private func setSign() {
        if GameManager.instance.getEasyDifficulty() {
            sign?.position.y = (easyButton?.position.y)!
        } else if(GameManager.instance.getMediumDifficulty()) {
            sign?.position.y = (mediumButton?.position.y)!
        } else if(GameManager.instance.getHardDifficulty()) {
            sign?.position.y = (hardButton?.position.y)!
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
            
            switch atPoint(location) {
            case easyButton:
                sign?.position.y = (easyButton?.position.y)!
                set(difficulty: "easy")
            case mediumButton:
                sign?.position.y = (mediumButton?.position.y)!
                set(difficulty: "medium")
            case hardButton:
                sign?.position.y = (hardButton?.position.y)!
                set(difficulty: "hard")
            default:
                break
            }
        }
    }
}
