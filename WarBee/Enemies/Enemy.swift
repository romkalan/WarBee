//
//  Enemy.swift
//  WarBee
//
//  Created by Roman Lantsov on 20.07.2023.
//

import SpriteKit

class Enemy: SKSpriteNode {
    static var textureAtlas: SKTextureAtlas?
    var enemyTexture: SKTexture!
    
    init(enemyTexture: SKTexture) {
        let texture = enemyTexture
        super.init(
            texture: texture,
            color: .clear,
            size: CGSize(width: 221, height: 204)
        )
        self.xScale = 0.5
        self.yScale = -0.5
        self.zPosition = 20
        self.name = "sprite"
        
        self.physicsBody = SKPhysicsBody(
            texture: texture,
            alphaThreshold: 0.5,
            size: self.size
        )
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.enemy
        self.physicsBody?.collisionBitMask = BitMaskCategory.player | BitMaskCategory.shot
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player | BitMaskCategory.shot
    }
    
    func flySpiral() {
        let timeHorizontal: Double = 3
        let timeVertical: Double = 5
        let screenSize = UIScreen.main.bounds
        
        let moveLeft = SKAction.moveTo(x: 50, duration: timeHorizontal)
        moveLeft.timingMode = .easeInEaseOut
        
        let moveRight = SKAction.moveTo(x: screenSize.width - 50, duration: timeHorizontal)
        moveRight.timingMode = .easeInEaseOut
        
        let forwardMovement = SKAction.moveTo(y: -120, duration: timeVertical)
        
        let randomNumber = Int(arc4random_uniform(2))
        let asideMovementSequence = randomNumber == EnemyDirection.left.rawValue
            ? SKAction.sequence([moveLeft, moveRight])
            : SKAction.sequence([moveRight, moveLeft])
        let foreverAsideMovement = SKAction.repeatForever(asideMovementSequence)
        
        let groupMovement = SKAction.group([foreverAsideMovement, forwardMovement])
        self.run(groupMovement)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum EnemyDirection: Int {
    case left = 0
    case right = 1
}
