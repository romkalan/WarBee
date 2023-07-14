//
//  GameScene.swift
//  WarBee
//
//  Created by Roman Lantsov on 10.07.2023.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    var player: SKSpriteNode!
    
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
        
        player = PlayerPlane.populate(at: CGPoint(
            x: screen.size.width / 2,
            y: 100)
        )
        self.addChild(player)
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            guard let data = data else { return }
            let acceleration = data.acceleration
            self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
        }
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        player.position.x += xAcceleration * 50
        
        if player.position.x < -70 {
            player.position.x = self.size.width + 70
        } else if player.position.x > self.size.width + 70 {
            player.position.x = -70
        }
    }
    
}
