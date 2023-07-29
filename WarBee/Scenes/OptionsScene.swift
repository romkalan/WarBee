//
//  OptionsScene.swift
//  WarBee
//
//  Created by Roman Lantsov on 26.07.2023.
//

import SpriteKit

class OptionsScene: ParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!
    
    override func didMove(to view: SKView) {
        
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound
        
        setHeader(with: "options", andBackground: "header_background")
        
        let backgroundNameForMusic = isMusic == true ? "music" : "nomusic"
        let music = ButtonNode(titled: nil, backgroundName: backgroundNameForMusic)
        music.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
        music.name = "music"
        music.label.isHidden = true
        addChild(music)
        
        let backgroundNameForSound = isMusic == true ? "sound" : "nosound"
        let sound = ButtonNode(titled: nil, backgroundName: backgroundNameForSound)
        sound.position = CGPoint(x: self.frame.midX + 50, y: self.frame.midY)
        sound.name = "sound"
        sound.label.isHidden = true
        addChild(sound)
        
        let back = ButtonNode(titled: "back", backgroundName: "button_background")
        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        back.name = "back"
        back.label.name = "back"
        addChild(back)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let node = self.atPoint(location)

        if node.name == "music" {
            print("music")
        } else if node.name == "sound" {
            print("sound")
        } else if node.name == "back" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(backScene, transition: transition)
        }
    }
}
