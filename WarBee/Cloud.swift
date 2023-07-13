//
//  Cloud.swift
//  WarBee
//
//  Created by Roman Lantsov on 13.07.2023.
//

import SpriteKit
import GameplayKit

protocol GameBackgroundSpriteable {
    static func populateIsland(at point: CGPoint) -> Self
}

final class Cloud: SKSpriteNode, GameBackgroundSpriteable {
    static func populateIsland(at point: CGPoint) -> Cloud {
        let cloudImage = configureName()
        let cloud = Cloud(imageNamed: cloudImage)
        cloud.setScale(randomScaleFactor)
        cloud.position = point
        cloud.zPosition = 1

        return cloud
    }
    
    fileprivate static func configureName() -> String {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
        let randomNumber = distribution.nextInt()
        let imageName = "is" + "\(randomNumber)"
        
        return imageName
    }
    
    fileprivate static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 10)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
}
