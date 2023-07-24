//
//  Assets.swift
//  WarBee
//
//  Created by Roman Lantsov on 22.07.2023.
//

import SpriteKit

class Assets {
    static let shared = Assets()
    
    var isLoaded = false
    let playerPlaneAtlas = SKTextureAtlas(named: "PlayerPlane")
    let yellowAmmoAtlas = SKTextureAtlas(named: "YellowAmmo")
    let enemy_1Atlas = SKTextureAtlas(named: "Enemy_1")
    let enemy_2Atlas = SKTextureAtlas(named: "Enemy_2")
    let bluePowerUpAtlas = SKTextureAtlas(named: "BluePowerUp")
    let greenPowerUpAtlas = SKTextureAtlas(named: "GreenPowerUp")
    
    func preloadAssets() {
        playerPlaneAtlas.preload { print("playerPlaneAtlas preloaded")}
        yellowAmmoAtlas.preload { print("yellowAmmoAtlas preloaded")}
        enemy_1Atlas.preload { print("enemy_1Atlas preloaded")}
        enemy_2Atlas.preload { print("enemy_2Atlas preloaded")}
        bluePowerUpAtlas.preload { print("bluePowerUpAtlas preloaded")}
        greenPowerUpAtlas.preload { print("greenPowerUpAtlas preloaded")}
    }
    
    private init() {}
}
