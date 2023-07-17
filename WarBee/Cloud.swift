//
//  Cloud.swift
//  WarBee
//
//  Created by Roman Lantsov on 13.07.2023.
//

import SpriteKit
import GameplayKit


final class Cloud: SKSpriteNode, GameBackgroundSpriteable {
    static func populateSprite(at point: CGPoint?) -> Cloud {
        let cloudImage = configureName()
        let cloud = Cloud(imageNamed: cloudImage)
        cloud.setScale(randomScaleFactor)
        cloud.position = point ?? randomPoint()
        cloud.zPosition = 10
        cloud.name = "backgroundSprite"
        cloud.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        cloud.run(move(from: cloud.position))

        return cloud
    }
    
    fileprivate static func configureName() -> String {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 3)
        let randomNumber = distribution.nextInt()
        let imageName = "cl" + "\(randomNumber)"
        
        return imageName
    }
    
    fileprivate static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 10, highestValue: 20)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
    
    fileprivate static func move(from point: CGPoint) -> SKAction {
        let movePoint = CGPoint(x: point.x, y: -200)
        let moveDistance = point.y + 200
        let movementSpeed: CGFloat = 150.0
        let duration = moveDistance / movementSpeed
        
        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
    }
}
