//
//  GameSettings.swift
//  WarBee
//
//  Created by Roman Lantsov on 28.07.2023.
//

import UIKit

class GameSettings: NSObject {

    let userDefaults = UserDefaults.standard

    var isMusic = true
    var isSound = true

    let musicKey = "music"
    let soundKey = "sound"
    
    var highScore: [Int] = []
    var currentScore = 0
    let highScoreKey = "highScore"

    override init() {
        super.init()
        loadGameSettings()
        loadScores()
    }

    func saveGameSettings() {
        userDefaults.set(isMusic, forKey: musicKey)
        userDefaults.set(isSound, forKey: soundKey)
    }

    func loadGameSettings() {
        guard userDefaults.value(forKey: musicKey) != nil && userDefaults.value(forKey: soundKey) != nil else { return }
        isMusic = userDefaults.bool(forKey: musicKey)
        isMusic = userDefaults.bool(forKey: soundKey)
    }
    
    func saveScores() {
        highScore.append(currentScore)
        highScore = Array(highScore.sorted { $0 > $1 }.prefix(3))
        
        userDefaults.set(highScore, forKey: highScoreKey)
        userDefaults.synchronize()
    }
    
    func loadScores() {
        guard userDefaults.value(forKey: highScoreKey) != nil else { return }
        highScore = userDefaults.array(forKey: highScoreKey) as! [Int]
    }
}
