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
    var background:SKSpriteNode! //Sprite
    let screenSize: CGRect = UIScreen.main.bounds
    
    var gokuSprite:SKSpriteNode! //0
    var gokuIdleAtlas: SKTextureAtlas! //Spritesheet //1
    var gokuIdleFrames: [SKTexture]! //frames //2
    var gokuIdle: SKAction! //Animation //3
    
    
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
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        background.size = CGSize(width: screenSize.width, height: screenSize.height)
        
        //gokuSprite.name = "goku"
        gokuIdleAtlas = SKTextureAtlas(named: "idle.1") //0
        
        gokuIdleFrames = [] //2. Initialize empty texture array
        
        let gokuIdleImages = gokuIdleAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        
        //4. for loop
        for i in 0...gokuIdleImages {
            let texture = "Idle_\(i)" //grab each frame in atlas
            gokuIdleFrames.append(gokuIdleAtlas.textureNamed(texture))
        }//add frame to texture array
        gokuIdle = SKAction.animate(with: gokuIdleFrames, timePerFrame: 0.3, resize: true, restore: true)
       
        gokuSprite = SKSpriteNode(texture: SKTexture(imageNamed: "idle_0.png"))
        gokuSprite.position = CGPoint(x: screenSize.width/2-20, y:screenSize.height/2)
        
        addChild(background)
        addChild(gokuSprite)
        
        gokuSprite.run(SKAction.repeatForever(gokuIdle)) // this way the animation will keep playing for ever
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    
   
    }


}
