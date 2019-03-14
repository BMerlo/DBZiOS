//
//  GameScene.swift
//  dbz
//
//  Created by BM on 2019-03-14.
//  Copyright © 2019 BM. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var music:AVAudioPlayer = AVAudioPlayer()
    
    
    //TODO: - Use this to create a menu scene
    var background:SKSpriteNode! //Sprite
    var goku = SKSpriteNode()
    let screenSize: CGRect = UIScreen.main.bounds
    
    var TextureAtlas:[SKTextureAtlas]!
    var idleAnimation: SKAction?
    var idleFrames = [SKTexture]()
    
    override init(size: CGSize) {
        super.init(size: size)
        let musicFile = Bundle.main.path(forResource: "music/fight", ofType: ".mp3")
        
        do{
            try music = AVAudioPlayer (contentsOf: URL (fileURLWithPath: musicFile!))
        }
        catch{
            print(error)
        }
        music.play()
        
        TextureAtlas = [SKTextureAtlas]()
        TextureAtlas.append(SKTextureAtlas(named: "idle.1"))
        
        var punchFrames1: [SKTexture] = []
        let numImages0 = TextureAtlas[0].textureNames.count - 1
            
        
        for i in 0...numImages0 {
            let Name = "idle_\(i).png"
           // idleFrames.append(SKTexture(imageNamed: Name))
            idleFrames.append(TextureAtlas[0].textureNamed(Name))
            
        }
        
        goku = SKSpriteNode(texture: SKTexture(imageNamed: "idle_0"))
        goku.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        
        goku.run(SKAction.repeatForever(SKAction.animate(with: punchFrames1, timePerFrame: 0.2, resize: true, restore: true)))
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        background.size = CGSize(width: screenSize.width, height: screenSize.height)
        
        addChild(background)
        addChild(goku)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    
   
    }


}
