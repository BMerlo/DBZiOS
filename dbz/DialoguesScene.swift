//
//  DialoguesScene.swift
//  dbz
//
//  Created by BM on 2019-03-14.
//  Copyright © 2019 BM. All rights reserved.
//

import Foundation
import SpriteKit

class DialoguesScene: SKScene {
    
    //TODO: - Add label here to indicate game over
    //TODO: - Add button to restart to menu
    let dialogueMusic = SKAudioNode(fileNamed: "/music/dialogue.mp3")
    let dialogue2File = SKAudioNode(fileNamed: "/sounds/vegetaDialog.mp3")
    let dialogue3File = SKAudioNode(fileNamed: "/sounds/gokuDialog.mp3")
    let dialogue4File = SKAudioNode(fileNamed: "/sounds/vegetaDialog2.mp3")
    //TODO: - Use this to create a menu scene
    var dialogue1:SKSpriteNode! //Sprite
    var dialogue2:SKSpriteNode! //Sprite
    var dialogue3:SKSpriteNode! //Sprite
    
    var counter:Int!;
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    override init(size: CGSize) {
        super.init(size: size)
        counter = 1;
        dialogue2File.autoplayLooped = false;
        dialogue3File.autoplayLooped = false;
        dialogue4File.autoplayLooped = false;
        
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
        addChild(dialogueMusic)
        addChild(dialogue2File)
        self.dialogue2File.run(SKAction.play());
        addChild(dialogue3File)
        addChild(dialogue4File)
        
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
                        self.dialogue2File.run(SKAction.stop());
                        self.dialogue3File.run(SKAction.play());
                                        
                        print("trying to remove d1")
                        
                        self.addChild(self.dialogue2)
                        self.dialogue1.removeFromParent()
                    }
                }
                if node.name == "d2" {
                    if node.contains(t.location(in:self))
                    {
                        print("trying to remove d2")
                        
                        self.addChild(self.dialogue3)
                        self.dialogue3File.run(SKAction.stop());
                        self.dialogue4File.run(SKAction.play());
                        self.dialogue2.removeFromParent()
                        
                    }
                }
                if node.name == "d3" {
                    if node.contains(t.location(in:self))
                    {
                        print("trying to remove d3")
                        self.dialogue4File.run(SKAction.stop());
                        self.dialogueMusic.run(SKAction.stop());
                        //self.dialogue2.removeFromParent()
                    self.perform(#selector(self.changeScene), with: nil, afterDelay: 0.5)
                        
                        
                    }
                }
            })
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

    }
    
    @objc func changeScene(){ //change scene after 1 sec
        let reveal = SKTransition.reveal(with: .up, duration: 0.6)
        //let newScene = DialoguesScene(size:self.size)
        let newScene = GameScene(size:self.size)
        self.view?.presentScene(newScene, transition: reveal)
        
    }
    
}
