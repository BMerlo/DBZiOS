//
//  DialoguesScene.swift
//  dbz
//
//  Created by BM on 2019-03-14.
//  Copyright © 2019 BM. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class DialoguesScene: SKScene {
    
    //TODO: - Add label here to indicate game over
    //TODO: - Add button to restart to menu
    var musicDialogue:AVAudioPlayer = AVAudioPlayer()
    var musicDialogue1:AVAudioPlayer = AVAudioPlayer()
    var musicDialogue2:AVAudioPlayer = AVAudioPlayer()
    var musicDialogue3:AVAudioPlayer = AVAudioPlayer()
    //TODO: - Use this to create a menu scene
    var dialogue1:SKSpriteNode! //Sprite
    var dialogue2:SKSpriteNode! //Sprite
    var dialogue3:SKSpriteNode! //Sprite
    
    var counter:Int!;
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    override init(size: CGSize) {
        super.init(size: size)
        counter = 1;
        
        let dialogue1File =    Bundle.main.path(forResource: "music/dialogue", ofType: ".mp3")
        let dialogue2File =    Bundle.main.path(forResource: "sounds/vegetaDialog", ofType: ".mp3")
        let dialogue3File =    Bundle.main.path(forResource: "sounds/vegetaDialog2", ofType: ".mp3")
        let dialogue4File =    Bundle.main.path(forResource: "sounds/gokuDialog", ofType: ".mp3")
        
        do{
            try musicDialogue = AVAudioPlayer (contentsOf: URL (fileURLWithPath: dialogue1File!))
            try musicDialogue1 = AVAudioPlayer (contentsOf: URL (fileURLWithPath: dialogue2File!))
            try musicDialogue2 = AVAudioPlayer (contentsOf: URL (fileURLWithPath: dialogue3File!))
            try musicDialogue3 = AVAudioPlayer (contentsOf: URL (fileURLWithPath: dialogue4File!))
        }
        catch{
            print(error)
        }
        musicDialogue.play()
        musicDialogue1.play()
        
        dialogue1 = SKSpriteNode(imageNamed: "vegeta1")
        dialogue1.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        dialogue1.size = CGSize(width: screenSize.width, height: screenSize.height)
        dialogue1.name = "d1"
        
        dialogue2 = SKSpriteNode(imageNamed: "goku1")
        dialogue2.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        dialogue2.size = CGSize(width: screenSize.width, height: screenSize.height)
        dialogue2.name = "d2"
        
        dialogue3 = SKSpriteNode(imageNamed: "vegeta2")
        dialogue3.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        dialogue3.size = CGSize(width: screenSize.width, height: screenSize.height)
        dialogue3.name = "d3"
        
        addChild(dialogue1)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            enumerateChildNodes(withName: "//*", using: { ( node, stop) in
                if node.name == "d1" {
                    if node.contains(t.location(in:self))// do whatever here
                    {
                        self.musicDialogue1.stop()
                        //self.musicDialogue.stop()
                        
                        self.dialogue1.removeFromParent()
                        print("trying to remove d1")
                        
                        self.addChild(self.dialogue2)
                        self.musicDialogue3.play()
                        
                    //    self.addChild(dialogue2)
                    }
                }
                if node.name == "d2" {
                    if node.contains(t.location(in:self))
                    {
                        self.musicDialogue3.stop()
                      //  self.musicDialogue.stop()
                        print("trying to remove d2")
                        
                        self.addChild(self.dialogue3)
                        
                        self.dialogue2.removeFromParent()
                        self.musicDialogue2.play()
                    }
                }
                if node.name == "d3" {
                    if node.contains(t.location(in:self))
                    {
                        self.musicDialogue.stop()
                        self.musicDialogue2.stop()
                        print("trying to remove d3")
                        
                        //self.dialogue2.removeFromParent()
                        let reveal = SKTransition.reveal(with: .down, duration: 1)
                        let newScene = GameScene(size:self.size)
                        self.view?.presentScene(newScene, transition: reveal)
                        
                        
                    }
                }
            })
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

    }
    
}
