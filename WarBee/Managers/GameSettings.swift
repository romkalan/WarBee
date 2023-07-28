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

    override init() {
        super.init()
        loadGameSettings()
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
}
