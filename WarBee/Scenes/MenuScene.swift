//
//  MenuScene.swift
//  WarBee
//
//  Created by Roman Lantsov on 23.07.2023.
//

import SpriteKit

class MenuScene: ParentScene {
    override func didMove(to view: SKView) {
        if !Assets.shared.isLoaded {
            Assets.shared.preloadAssets()
            Assets.shared.isLoaded = true
        }
        createButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let node = self.atPoint(location)
        
        if node.name == "play" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene, transition: transition)
        } else if node.name == "options" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let optionsScene = OptionsScene(size: self.size)
            optionsScene.backScene = self
            optionsScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(optionsScene, transition: transition)
        } else if node.name == "best" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let bestScene = BestScene(size: self.size)
            bestScene.backScene = self
            bestScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(bestScene, transition: transition)
        }
    }
    
    fileprivate func createButton() {
        setHeader(with: nil, andBackground: "header1")
        
        let titles = ["play", "options", "best"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(100 * index))
            button.name = title
            button.label.name = title
            addChild(button)
        }
    }
}
