//
//  PowerUp.swift
//  WarBee
//
//  Created by Roman Lantsov on 19.07.2023.
//

import SpriteKit

class PowerUp: SKSpriteNode {
    private let initialSize = CGSize(width: 52, height: 52)
    private var textureAtlas: SKTextureAtlas!
    private var textureNameBeginsWith = ""
    private var animationSpriteArray = [SKTexture]()
    
    init(textureAtlas: SKTextureAtlas) {
        self.textureAtlas = textureAtlas
        let textureName = textureAtlas.textureNames.sorted()[0]
        let texture = textureAtlas.textureNamed(textureName)
        textureNameBeginsWith = String(textureName.dropLast(6))
        
        super.init(texture: texture, color: .clear, size: initialSize)
        self.setScale(0.7)
        self.name = "powerUp"
        self.zPosition = 20
    }
    
    func performRotation() {
        for i in 1...15 {
            let number = String(format: "%02d", i)
            animationSpriteArray.append(SKTexture(imageNamed: textureNameBeginsWith + number.description))
        }
        
        SKTexture.preload(animationSpriteArray) {
            let rotation = SKAction.animate(
                with: self.animationSpriteArray,
                timePerFrame: 0.05,
                resize: true,
                restore: false
            )
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
