//
//  GameScene.swift
//  dbz
//
//  Created by BM on 2019-03-14.
//  Copyright © 2019 BM. All rights reserved.
//

import SpriteKit
import AVFoundation


let wallCategory: UInt32 = 0x1 << 0
let ballCategory: UInt32 = 0x1 << 1
let playerCategory: UInt32 = 0x1 << 2

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var music:AVAudioPlayer = AVAudioPlayer()
    var background:SKSpriteNode! //Sprite
    let screenSize: CGRect = UIScreen.main.bounds
    let velocityMultiplier: CGFloat = 0.12
    
    var gokuSprite:SKSpriteNode! //0
    var gokuIdleAtlas: SKTextureAtlas! //Spritesheet //1
    var gokuIdleFrames: [SKTexture]! //frames //2
    var gokuIdle: SKAction! //Animation //3
    
    let moveJoystick = 🕹(withDiameter: 80)

    
    override init(size: CGSize) {
        super.init(size: size)
        let musicFile = Bundle.main.path(forResource: "music/fight", ofType: ".mp3")
        
        do{
            try music = AVAudioPlayer (contentsOf: URL (fileURLWithPath: musicFile!))
        }
        catch{
            print(error)
        }
       // music.play()
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        background.size = CGSize(width: screenSize.width, height: screenSize.height)
        moveJoystick.position = CGPoint(x: screenSize.width * 0.15, y:screenSize.height * 0.2)
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
        gokuSprite?.physicsBody = SKPhysicsBody(rectangleOf: (gokuSprite?.frame.size)!)
        gokuSprite?.physicsBody?.affectedByGravity = false;
        gokuSprite?.physicsBody?.allowsRotation = false;
        gokuSprite?.physicsBody?.mass = 2.0
        
        gokuSprite?.physicsBody?.categoryBitMask = playerCategory
        gokuSprite?.physicsBody?.contactTestBitMask = wallCategory
        gokuSprite?.physicsBody?.collisionBitMask = wallCategory
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = borderBody
        self.physicsBody?.categoryBitMask = wallCategory
        self.physicsBody?.contactTestBitMask = playerCategory
        self.physicsWorld.contactDelegate = self
        
        addChild(background)
        addChild(gokuSprite)
        addChild(moveJoystick)
        
        gokuSprite.run(SKAction.repeatForever(gokuIdle)) // this way the animation will keep playing for ever
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    
   
    }
    
  /*  func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == wallCategory {
            print("player first")
        }
    }*/
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        moveJoystick.on(.move) { [unowned self] joystick in
            guard let gokuSprite = self.gokuSprite else {
                return
            }
            
            let pVelocity = joystick.velocity;
            let speed = CGFloat(0.09)
            
            gokuSprite.position = CGPoint(x: gokuSprite.position.x + (pVelocity.x * speed), y: gokuSprite.position.y + (pVelocity.y * speed))
         //   print(gokuSprite.position)
            
        }
    }
    
}
