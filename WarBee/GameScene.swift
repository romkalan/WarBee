//
//  GameScene.swift
//  WarBee
//
//  Created by Roman Lantsov on 10.07.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: PlayerPlane!
    let deadline = DispatchTime.now() + .nanoseconds(1)
    
    override func didMove(to view: SKView) {
        configureStartScene()
        spawnClouds()
        spawnIslands()
        
        DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
            self.player.performFly()
        }
        
        spawnPowerUp()
        spawnSpiralOfEnemies()
        
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        player.checkPosition()
        
        enumerateChildNodes(withName: "backgroundSprite") { (node, stop) in
            if node.position.y < -199 {
                node.removeFromParent()
            }
        }
    }
    
    fileprivate func spawnPowerUp() {
        let powerUp = PowerUp()
        powerUp.performRotation()
        powerUp.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(powerUp)
    }
    
    fileprivate func spawnSpiralOfEnemies() {
        let textureAtlas = SKTextureAtlas(named: "Enemy_1")
        SKTextureAtlas.preloadTextureAtlases([textureAtlas]) {
            Enemy.textureAtlas = textureAtlas
            let enemy = Enemy()
            enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 120)
            self.addChild(enemy)
            enemy.flySpiral()
        }
    }
    
    fileprivate func configureStartScene() {
        let screenCenterPoint = CGPoint(
            x: self.size.width / 2,
            y: self.size.height / 2
        )
        
        let background = Background.populateBackground(at: screenCenterPoint)
        background.size = self.size
        self.addChild(background)
        
        let screen = UIScreen.main.bounds
       
        let island1 = Island.populateSprite(at: CGPoint(x: 100, y: 200))
        self.addChild(island1)
        
        let island2 = Island.populateSprite(at: CGPoint(
            x: self.size.width - 100,
            y: self.size.height - 200
        ))
        self.addChild(island2)
        
        let cloud1 = Cloud.populateSprite(at: CGPoint(x: 150, y: 150))
        self.addChild(cloud1)
        
        let cloud2 = Cloud.populateSprite(at: CGPoint(
            x: self.size.width - 150,
            y: self.size.height - 200
        ))
        self.addChild(cloud2)
        
        player = PlayerPlane.populate(at: CGPoint(
            x: screen.size.width / 2,
            y: 100)
        )
        self.addChild(player)
        
    }
    
    //Spawn Background Objects methods
    fileprivate func spawnClouds() {
        let spawnCloudWait = SKAction.wait(forDuration: 1)
        let spawnCloudAction = SKAction.run {
            let cloud = Cloud.populateSprite(at: nil)
            self.addChild(cloud)
        }
        
        let spawnCloudSequence = SKAction.sequence([
            spawnCloudWait,
            spawnCloudAction
        ])
        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
        run(spawnCloudForever)
    }
    
    fileprivate func spawnIslands() {
        let spawnIslandWait = SKAction.wait(forDuration: 2)
        let spawnIslandAction = SKAction.run {
            let island = Island.populateSprite(at: nil)
            self.addChild(island)
        }
        
        let spawnIslandSequence = SKAction.sequence([
            spawnIslandWait,
            spawnIslandAction
        ])
        let spawnIslandForever = SKAction.repeatForever(spawnIslandSequence)
        run(spawnIslandForever)
    }
    
}
