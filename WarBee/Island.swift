//
//  Island.swift
//  WarBee
//
//  Created by Roman Lantsov on 12.07.2023.
//

import SpriteKit
import GameplayKit

class Island: SKSpriteNode {
    static func populateIsland(at point: CGPoint) -> Island {
        let islandImage = configureIslandName()
        let island = Island(imageNamed: islandImage)
        island.setScale(randomScaleFactor)
        island.position = point
        island.zPosition = 1
        island.run(rotateFromRandomAngle())

        return island
    }
    
    static func configureIslandName() -> String {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
        let randomNumber = distribution.nextInt()
        let imageName = "is" + "\(randomNumber)"
        
        return imageName
    }
    
    static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 10)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
    
    static func rotateFromRandomAngle() -> SKAction {
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return SKAction.rotate(
            toAngle: randomNumber * CGFloat(Double.pi / 180),
            duration: 0
        )
    }
}
