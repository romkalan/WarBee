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
        self.name = "sprite"
        self.zPosition = 20
        
        self.physicsBody = SKPhysicsBody(
            texture: texture,
            alphaThreshold: 0.5,
            size: self.size
        )
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.powerUp
        self.physicsBody?.collisionBitMask = BitMaskCategory.player
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player
    }
    
    func startMovement() {
        performRotation()
        
        let moveForward = SKAction.moveTo(y: -100, duration: 5)
        self.run(moveForward)
    }
    
    fileprivate func performRotation() {
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
