//
//  MenuScene.swift
//  SuperSpaceMan
//
//  Created by Apptist Inc on 2019-03-11.
//  Copyright © 2019 Mark Meritt. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class MenuScene: SKScene {

    var music:AVAudioPlayer = AVAudioPlayer()
    //TODO: - Use this to create a menu scene
    var background:SKSpriteNode! //Sprite
    var logo:SKSpriteNode!
    let screenSize: CGRect = UIScreen.main.bounds
    
    var startBtn: SKSpriteNode!
    var quitBtn: SKSpriteNode!
    //let startBtn = SKSpriteNode(imageNamed: "button_01")
    
    //TODO: - Add a main menu and play button
    override init(size: CGSize) {
        super.init(size: size)
       
       let musicFile =	Bundle.main.path(forResource: "music/menu", ofType: ".mp3")
        
        do{
            try music = AVAudioPlayer (contentsOf: URL (fileURLWithPath: musicFile!))
        }
            catch{
                print(error)
            }
        music.play()
   
        background = SKSpriteNode(imageNamed: "screenMenu")
        background.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        background.size = CGSize(width: screenSize.width, height: screenSize.height)
        
        logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2+80)
        logo.size = CGSize(width: screenSize.width/4, height: screenSize.height/4)
        
        startBtn = SKSpriteNode(imageNamed: "Start")
        startBtn.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2-35)
        startBtn.name = "startButton"
        
        quitBtn = SKSpriteNode(imageNamed: "Quit")
        quitBtn.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2-90)
        quitBtn.name = "startButton"
        
        addChild(background)
           
        addChild(logo)
        addChild(startBtn)
        addChild(quitBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            enumerateChildNodes(withName: "//*", using: { ( node, stop) in
                if node.name == "startButton" {
                    if node.contains(t.location(in:self))// do whatever here
                    {
                        self.music.stop()
                        let reveal = SKTransition.reveal(with: .down, duration: 1)
                        //let newScene = DialoguesScene(size:self.size)
                        let newScene = GameScene(size:self.size)
                        self.view?.presentScene(newScene, transition: reveal)
                        print("Button Pressed")
                    }
                }
            })
        }
    }
}
