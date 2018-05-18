//
//  GameplayController.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/17/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import Foundation
import SpriteKit

class GameplayController {
    static let instance = GameplayController()
    
    var scoreLabel: SKLabelNode?
    var coinLabel: SKLabelNode?
    var lifeLabel: SKLabelNode?
    
    var score = 0
    var coin = 0
    var life = 0
    
    private init() {}
    
    func initializeLabel() {
        if GameManager.instance.gameStartedFromMainMenu {
            GameManager.instance.gameStartedFromMainMenu = false
            score = 0
            coin = 0
            life = 1
            
            scoreLabel?.text = "\(score)"
            coinLabel?.text = String(coin)
            lifeLabel?.text = "x\(life)"
        } else if GameManager.instance.gameRestartedPlayerDied {
            GameManager.instance.gameRestartedPlayerDied = false

            scoreLabel?.text = "\(score)"
            coinLabel?.text = String(coin)
            lifeLabel?.text = "x\(life)"
        }
    }
    
    func incrementScore() {
        score += 1
        scoreLabel?.text = "\(score)"
    }
    
    func incrementCoin() {
        coin += 1
        score += 200
        
        coinLabel?.text = "\(coin)"
        scoreLabel?.text = "\(score)"
    }
    
    func incrementLife() {
        life += 1
        score += 300
        
        lifeLabel?.text = "x\(life)"
        scoreLabel?.text = "\(score)"
    }
}


