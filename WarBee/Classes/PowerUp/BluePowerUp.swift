//
//  BluePowerUp.swift
//  WarBee
//
//  Created by Roman Lantsov on 21.07.2023.
//

import SpriteKit

class BluePowerUp: PowerUp {
    init() {
        let textureAtlas = Assets.shared.bluePowerUpAtlas
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
