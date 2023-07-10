//
//  GameScene.swift
//  WarBee
//
//  Created by Roman Lantsov on 10.07.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let sprite = SKSpriteNode(color: .blue, size: CGSize(width: 100, height: 100))
        sprite.position = CGPoint(x: 200, y: 200)
        self.addChild(sprite)
    }
    
}
