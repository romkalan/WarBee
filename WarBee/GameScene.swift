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
        let screenCenterPoint = CGPoint(
            x: self.size.width / 2,
            y: self.size.height / 2
        )
        
        let background = Background.populateBackground(at: screenCenterPoint)
        background.size = self.size
        self.addChild(background)
        
        let screen = UIScreen.main.bounds
        for _ in 1...5 {
            let xPosition = CGFloat(
                GKRandomSource.sharedRandom().nextInt(
                    upperBound: Int(screen.size.width)
                )
            )
            let yPosition = CGFloat(
                GKRandomSource.sharedRandom().nextInt(
                    upperBound: Int(screen.size.height)
                )
            )
            let island = Island.populateSprite(at: CGPoint(x: xPosition, y: yPosition))
            self.addChild(island)
            
            let cloud = Cloud.populateSprite(at: CGPoint(x: xPosition, y: yPosition))
            self.addChild(cloud)
            
        }
    }
    
}
