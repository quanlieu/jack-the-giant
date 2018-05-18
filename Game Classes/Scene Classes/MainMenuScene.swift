//
//  GameplayScene.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/15/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    private var musicBtn: SKSpriteNode?
    private let musicOn = SKTexture(imageNamed: "Music On Button")
    private let musicOff = SKTexture(imageNamed: "Music Off Button")
    
    override func didMove(to view: SKView) {
        musicBtn = self.childNode(withName: "Music") as? SKSpriteNode
        GameManager.instance.initializeGameData()
        setMusic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            let scene: SKScene?
            switch atPoint(location).name {
            case "Start Game":
                GameManager.instance.gameStartedFromMainMenu = true
                scene = GameplayScene(fileNamed: "GameplayScene")
            case "High Score":
                scene = HightScoreScene(fileNamed: "HighScoreScene")
            case "Options":
                scene = OptionScene(fileNamed: "OptionScene")
            default:
                scene = nil
            }
            
            if atPoint(location).name == "Music" {
                handleMusicButton()
            }
            
            if scene != nil {
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.doorsOpenVertical(withDuration: 0.5))
            }
        }
    }
    
    private func setMusic() {
        if GameManager.instance.getIsMusicOn() && !AudioManager.instance.isAudioPlayerInitialized() {
            AudioManager.instance.playBGMusic();
            musicBtn?.texture = musicOff
        }
    }
    
    private func handleMusicButton() {
        if GameManager.instance.getIsMusicOn() {
            AudioManager.instance.stopBGMusic();
            musicBtn?.texture = musicOn
        } else {
            AudioManager.instance.playBGMusic();
            musicBtn?.texture = musicOff
        }
        GameManager.instance.setIsMusicOn(!GameManager.instance.getIsMusicOn())
        GameManager.instance.saveData()
    }
}
