//
//  GameScene.swift
//  WarBee
//
//  Created by Roman Lantsov on 10.07.2023.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: ParentScene {
    
    var backgroundMusic: SKAudioNode!
        
    fileprivate var player: PlayerPlane!
    fileprivate let hud = HUD()
    fileprivate let screenSize = UIScreen.main.bounds.size
    
    fileprivate var lives = 3 {
        didSet {
            switch lives {
            case 3:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = false
            case 2:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = true
            case 1:
                hud.life1.isHidden = false
                hud.life2.isHidden = true
                hud.life3.isHidden = true
            default:
                break
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        gameSettings.loadGameSettings()
        
        if gameSettings.isMusic && backgroundMusic == nil {
            guard let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a") else { return }
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        self.scene?.isPaused = false
        
        guard sceneManager.gameScene == nil else { return }
        
        sceneManager.gameScene = self
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        configureStartScene()
        spawnClouds()
        spawnIslands()
        player.performFly()
        spawnPowerUp()
        spawnEnemies()
        createHUD()
        
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        player.checkPosition()
        
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "greenPowerUp") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "bluePowerUp") { (node, stop) in
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
        guard let location = touches.first?.location(in: self) else { return }
        let node = self.atPoint(location)
        
        if node.name == "pause" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let gameScene = PauseScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            
            sceneManager.gameScene = self
            self.scene?.isPaused = true
            
            self.scene?.view?.presentScene(gameScene, transition: transition)
        } else {
            playerFire()
        }
    }
    
    // Configure User Interface
    fileprivate func createHUD() {
        self.addChild(hud)
        hud.configureUI(screenSize: screenSize)
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
                
                let randomPositionX = arc4random_uniform(UInt32(self.size.width - 100))
                enemy.position = CGPoint(x: CGFloat(randomPositionX), y: self.size.height + 110)
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
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")
        let contactPoint = contact.contactPoint
        explosion?.position = contactPoint
        explosion?.zPosition = 25
        
        let waitForExplosionAction = SKAction.wait(forDuration: 1.0)
        
        let hitSoundAction = SKAction.playSoundFileNamed("hitSound", waitForCompletion: false)
        
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        switch contactCategory {
        case [.enemy, .player]:
            if contact.bodyA.node?.name == "sprite" {
                if contact.bodyA.node?.parent != nil {
                    contact.bodyA.node?.removeFromParent()
                    lives -= 1
                }
            } else {
                if contact.bodyB.node?.parent != nil {
                    contact.bodyB.node?.removeFromParent()
                    lives -= 1
                }
            }
            
            self.run(hitSoundAction)
            addChild(explosion!)
            self.run(waitForExplosionAction) {
                explosion?.removeFromParent()
            }
            
            
            if lives == 0 {
                gameSettings.currentScore = hud.score
                gameSettings.saveScores()
                
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let gameOverScene = GameOverScene(size: self.size)
                gameOverScene.scaleMode = .aspectFill
                self.scene?.view?.presentScene(gameOverScene, transition: transition)
            }
        case [.powerUp, .player]:
            if contact.bodyA.node?.parent != nil && contact.bodyA.node?.parent != nil {
                if contact.bodyA.node?.name == "greenPowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    lives = 3
                    player.greenPowerUp()
                } else if contact.bodyB.node?.name == "greenPowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    lives = 3
                    player.greenPowerUp()
                }
                
                if contact.bodyA.node?.name == "bluePowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    lives = 3
                    player.bluePowerUp()
                } else if contact.bodyB.node?.name == "bluePowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    lives = 3
                    player.bluePowerUp()
                }
            }
        case [.enemy, .shot]:
            if contact.bodyA.node?.parent != nil {
                
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                
                if gameSettings.isSound {
                    self.run(SKAction.playSoundFileNamed("hitSound", waitForCompletion: false))
                }
                
                addChild(explosion!)
                self.run(waitForExplosionAction) {  explosion?.removeFromParent() }
                
                hud.score += 5
            }
        default: preconditionFailure("Unable to detect collision category")
        }
    }
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
