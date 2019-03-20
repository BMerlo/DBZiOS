//
//  GameOverScene.swift
//  SuperSpaceMan
//
//  Created by Apptist Inc on 2019-03-11.
//  Copyright © 2019 Mark Meritt. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class GameOverScene2: SKScene {
    
    var music:AVAudioPlayer = AVAudioPlayer()
    var background:SKSpriteNode! //Sprite
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var startBtn: SKSpriteNode!
    var quitBtn: SKSpriteNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let musicFile =    Bundle.main.path(forResource: "music/menu", ofType: ".mp3")
        
        do{
            try music = AVAudioPlayer (contentsOf: URL (fileURLWithPath: musicFile!))
        }
        catch{
            print(error)
        }
        music.play()
        
        background = SKSpriteNode(imageNamed: "vegetaSmile2")
        background.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        background.size = CGSize(width: screenSize.width, height: screenSize.height)
        background.name = "bg"
        
        startBtn = SKSpriteNode(imageNamed: "Start")
        startBtn.position = CGPoint(x: screenSize.width/2, y:screenSize.height * 0.70)
        startBtn.name = "startButton"
        
        quitBtn = SKSpriteNode(imageNamed: "Quit")
        quitBtn.position = CGPoint(x: screenSize.width/2, y:screenSize.height * 0.50)
        quitBtn.name = "quitButton"
        
        addChild(background)
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
                        print("Button Pressed")
                        self.perform(#selector(self.changeScene), with: nil, afterDelay: 0.5)
                        
                    }
                }
                if node.name == "quitButton" {
                    if node.contains(t.location(in:self))// do whatever here
                    {
                        exit(0)
                        //test area
                        //let newScene = GameScene(size:self.size)
                        
                    }
                }
                if node.name == "bg" {
                    if node.contains(t.location(in:self))// do whatever here
                    {
                        self.music.stop()
                        //test area
                        //let newScene = GameScene(size:self.size)
                        
                    }
                }
            })
        }
    }
    
    @objc func changeScene(){ //change scene after 1 sec
        let reveal = SKTransition.reveal(with: .up, duration: 0.6)
        //let newScene = DialoguesScene(size:self.size)
        let newScene = MenuScene(size:self.size)
        self.view?.presentScene(newScene, transition: reveal)
        
    }
    
}
