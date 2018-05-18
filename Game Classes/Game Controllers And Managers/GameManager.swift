//
//  GameManager.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/17/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import Foundation

class GameManager {
    static let instance = GameManager()
    
    private init() {}
    
    private var gameData: GameData?
    
    var gameStartedFromMainMenu = false
    var gameRestartedPlayerDied = false
    
    func initializeGameData() {
        if !FileManager.default.fileExists(atPath: getFilePath()) {
            gameData = GameData();
            saveData()
        }
        
        loadData()
    }
    
    func loadData() {
        gameData = NSKeyedUnarchiver.unarchiveObject(withFile: getFilePath() as String) as! GameData?
    }
    
    func saveData() {
        if gameData != nil {
            NSKeyedArchiver.archiveRootObject(gameData!, toFile: getFilePath() as String)
        }
    }
    
    private func getFilePath() -> String {
        let manager = FileManager.default;
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first as URL?
        return url!.appendingPathComponent("Game Data").path
    }
    
    
    
    func setEasyDifficultyScore(_ easyDifficultyScore: Int32) {
        gameData!.setEasyDifficultyScore(easyDifficultyScore);
    }
    
    func setEasyDifficultyCoinScore(_ easyDifficultyCoinScore: Int32) {
        gameData!.setEasyDifficultyCoinScore(easyDifficultyCoinScore);
    }
    
    func getEasyDifficultyScore() -> Int32 {
        return gameData!.getEasyDifficultyScore();
    }
    
    func getEasyDifficultyCoinScore() -> Int32 {
        return gameData!.getEasyDifficultyCoinScore();
    }
    
    func setMediumDifficultyScore(_ mediumDifficultyScore: Int32) {
        gameData!.setMediumDifficultyScore(mediumDifficultyScore);
    }
    
    func setMediumDifficultyCoinScore(_ mediumDifficultyCoinScore: Int32) {
        gameData!.setMediumDifficultyCoinScore(mediumDifficultyCoinScore);
    }
    
    func getMediumDifficultyScore() -> Int32 {
        return gameData!.getMediumDifficultyScore();
    }
    
    func getMediumDifficultyCoinScore() -> Int32 {
        return gameData!.getMediumDifficultyCoinScore();
    }
    
    func setHardDifficultyScore(_ hardDifficultyScore: Int32) {
        gameData!.setHardDifficultyScore(hardDifficultyScore);
    }
    
    func setHardDifficultyCoinScore(_ hardDifficultyCoinScore: Int32) {
        gameData!.setHardDifficultyCoinScore(hardDifficultyCoinScore);
    }
    
    func getHardDifficultyScore() -> Int32 {
        return gameData!.getHardDifficultyScore();
    }
    
    func getHardDifficultyCoinScore() -> Int32 {
        return gameData!.getHardDifficultyCoinScore();
    }
    
    func setEasyDifficulty(_ easyDifficulty: Bool) {
        gameData!.setEasyDifficulty(easyDifficulty);
    }
    
    func getEasyDifficulty() -> Bool {
        return gameData!.getEasyDifficulty();
    }
    
    func setMediumDifficulty(_ mediumDifficulty: Bool) {
        gameData!.setMediumDifficulty(mediumDifficulty);
    }
    
    func getMediumDifficulty() -> Bool {
        return gameData!.getMediumDifficulty();
    }
    
    func setHardDifficulty(_ hardDifficulty: Bool) {
        gameData!.setHardDifficulty(hardDifficulty);
    }
    
    func getHardDifficulty() -> Bool {
        return gameData!.getHardDifficulty();
    }
    
    func setIsMusicOn(_ isMusicOn: Bool) {
        gameData!.setIsMusicOn(isMusicOn);
    }
    
    func getIsMusicOn() -> Bool {
        return gameData!.getIsMusicOn();
    }
}

