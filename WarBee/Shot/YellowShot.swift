//
//  YellowShot.swift
//  WarBee
//
//  Created by Roman Lantsov on 22.07.2023.
//

import SpriteKit

class YellowShot: Shot {
    init() {
        let textureAtlas = Assets.shared.yellowAmmoAtlas
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
