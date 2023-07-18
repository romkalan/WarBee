//
//  PlayerPlane.swift
//  WarBee
//
//  Created by Roman Lantsov on 14.07.2023.
//

import SpriteKit
import CoreMotion

enum TurnDirection {
    case left
    case right
    case none
}

class PlayerPlane: SKSpriteNode {
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    var leftTextureArrayAnimation = [SKTexture]()
    var rightTextureArrayAnimation = [SKTexture]()
    var forwardTextureArrayAnimation = [SKTexture]()
    
    var moveDirection: TurnDirection = .none
    var stillTurning = false
    
    static func populate(at point: CGPoint) -> PlayerPlane {
        let playerPlaneTexture = SKTexture(imageNamed: "airplane_3ver2_13")
        let playerPlane = PlayerPlane(texture: playerPlaneTexture)
        playerPlane.setScale(0.5)
        playerPlane.position = point
        playerPlane.zPosition = 20
        
        return playerPlane
    }
    
    func checkPosition() {
        self.position.x += xAcceleration * 50
        
        if self.position.x < -70 {
            self.position.x = screenSize.width + 70
        } else if self.position.x > screenSize.width + 70 {
            self.position.x = -70
        }
    }
    
    func performFly() {
        planeAnimationFillArray()
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            guard let data = data else { return }
            let acceleration = data.acceleration
            self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
        }
    }
    
    fileprivate func planeAnimationFillArray() {
        SKTextureAtlas.preloadTextureAtlases([SKTextureAtlas(named: "PlayerPlane")]) {
            
            self.leftTextureArrayAnimation = {
                var array = [SKTexture]()
                for i in stride(from: 13, through: 1, by: -1) {
                    let number = String(format: "%02d", i)
                    let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
                    array.append(texture)
                }
                SKTexture.preload(array, withCompletionHandler: {
                    print("preload is done")
                })
                return array
            }()
            
            self.rightTextureArrayAnimation = {
                var array = [SKTexture]()
                for i in stride(from: 13, through: 26, by: 1) {
                    let number = String(format: "%02d", i)
                    let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
                    array.append(texture)
                }
                
                SKTexture.preload(array, withCompletionHandler: {
                    print("preload is done")
                })
                return array
            }()
            
            self.forwardTextureArrayAnimation = {
                var array = [SKTexture]()
                let texture = SKTexture(imageNamed: "airplane_3ver2_13")
                array.append(texture)
                
                SKTexture.preload(array, withCompletionHandler: {
                    print("preload is done")
                })
                return array
            }()
            
        }
    }
    
    fileprivate func movementDirection() {
        if xAcceleration > 0.02, moveDirection != .right, stillTurning == false {
            stillTurning = true
            moveDirection = .right
        } else if xAcceleration < 0.02, moveDirection != .left, stillTurning == false {
            stillTurning = true
            moveDirection = .left
        } else {
            
        }
    }
}
