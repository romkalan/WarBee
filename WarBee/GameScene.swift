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
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        configureStartScene()
        spawnClouds()
        spawnIslands()
        
        DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
            self.player.performFly()
        }
        
        spawnPowerUp()
        spawnEnemies()
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        player.checkPosition()
        
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "shotSprite") { (node, stop) in
            if node.position.y >= self.size.height + 100 {
                node.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerFire()
    }
    
    //Spawn playerFire
    fileprivate func playerFire() {
        let shot = YellowShot()
        shot.position = self.player.position
        shot.startMovement()
        self.addChild(shot)
    }
    
    //Spawn powerUp for player
    fileprivate func spawnPowerUp() {
        let spawnAction = SKAction.run {
            let randomNumber = Int(arc4random_uniform(2))
            let powerUp = randomNumber == 1 ? BluePowerUp() : GreenPowerUp()
            
            let randomPositionX = arc4random_uniform(UInt32(self.size.width - 30))
            
            powerUp.position = CGPoint(x: CGFloat(randomPositionX), y: self.size.height + 100)
            powerUp.startMovement()
            self.addChild(powerUp)
        }
        
        let randomTimeSpawn = Double(arc4random_uniform(11) + 10)
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        
        self.run(SKAction.repeatForever(SKAction.sequence([waitAction, spawnAction])))
    }
    
    // Spawn Enemies
    
    fileprivate func spawnEnemies() {
        let waitAction = SKAction.wait(forDuration: 3)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnEnemy(count: 3)
        }
        self.run(SKAction.repeatForever(SKAction.sequence([waitAction, spawnSpiralAction])))
    }
    
    fileprivate func spawnEnemy(count: Int) {
        let enemyTextureAtlas1 = Assets.shared.enemy_1Atlas
        let enemyTextureAtlas2 = Assets.shared.enemy_2Atlas
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
            
            let randomNumber = Int(arc4random_uniform(2))
            let arrayOfAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
            let textureAtlas = arrayOfAtlases[randomNumber]
            
            let waitAction = SKAction.wait(forDuration: 1.0)
            let spawnEnemy = SKAction.run({ [unowned self] in
                let textureNames = textureAtlas.textureNames.sorted()
                let texture = textureAtlas.textureNamed(textureNames[12])
                let enemy = Enemy(enemyTexture: texture)
                enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 110)
                self.addChild(enemy)
                enemy.flySpiral()
            })
            
            let spawnAction = SKAction.sequence([waitAction, spawnEnemy])
            let repeatAction = SKAction.repeat(spawnAction, count: 3)
            self.run(repeatAction)
        }
    }
    // initial settings for scene
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

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        let player = BitMaskCategory.player
        let enemy = BitMaskCategory.enemy
        let powerUp = BitMaskCategory.powerUp
        let shot = BitMaskCategory.shot
        
        if bodyA == player && bodyB == enemy || bodyA == enemy && bodyB == player {
            print("player vs enemy")
        } else if bodyA == enemy && bodyB == shot || bodyA == shot && bodyB == enemy {
            print("shot vs enemy")
        } else if bodyA == player && bodyB == powerUp || bodyA == powerUp && bodyB == player {
            print("player vs powerUp")
        }
    }
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
