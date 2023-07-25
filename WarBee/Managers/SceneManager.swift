//
//  SceneManager.swift
//  WarBee
//
//  Created by Roman Lantsov on 25.07.2023.
//

import Foundation

class SceneManager {
    static let shared = SceneManager()
    
    var gameScene: GameScene? = nil
    
    private init() {}
}
