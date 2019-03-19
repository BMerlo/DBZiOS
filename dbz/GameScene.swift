//
//  GameScene.swift
//  dbz
//
//  Created by BM on 2019-03-14.
//  Copyright © 2019 BM. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit

let wallCategory: UInt32 = 0x1 << 0
let ballCategory: UInt32 = 0x1 << 1
let playerCategory: UInt32 = 0x1 << 2
let enemyCategory: UInt32 = 0x1 << 2

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var music:AVAudioPlayer = AVAudioPlayer()
    var background:SKSpriteNode! //Sprite
    let screenSize: CGRect = UIScreen.main.bounds
    let velocityMultiplier: CGFloat = 0.12
    
    var gokuSprite:SKSpriteNode! //0
    //idle
    var gokuIdleAtlas: SKTextureAtlas! //Spritesheet //1
    var gokuIdleFrames: [SKTexture]! //frames //2
    var gokuIdle: SKAction! //Animation //3
    //move
    var gokuMoveAtlas: SKTextureAtlas! //Spritesheet //1
    var gokuMoveFrames: [SKTexture]! //frames //2
    var gokuMove: SKAction! //Animation //3
    
    var vegetaSprite:SKSpriteNode! //0
    //idle
    var vegetaIdleAtlas: SKTextureAtlas! //Spritesheet //1
    var vegetaIdleFrames: [SKTexture]! //frames //2
    var vegetaIdle: SKAction! //Animation //3
    //move
    var vegetaMoveAtlas: SKTextureAtlas! //Spritesheet //1
    var vegetaMoveFrames: [SKTexture]! //frames //2
    var vegetaMove: SKAction! //Animation //3
    
    let moveJoystick = 🕹(withDiameter: 80)
    var redButton:SKSpriteNode!
    var blueButton:SKSpriteNode!
        
    let myLabel = SKLabelNode(fontNamed:"Helvetica")
    var timer = Timer()
    var time = 60
    
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
        
        myLabel.text = "\(time)"
        myLabel.fontSize = 36
        myLabel.position = CGPoint(x: screenSize.width/2, y:screenSize.height * 0.88)
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
  
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        background.size = CGSize(width: screenSize.width, height: screenSize.height)
        moveJoystick.position = CGPoint(x: screenSize.width * 0.15, y:screenSize.height * 0.2)
        
        blueButton = SKSpriteNode(imageNamed: "blueButton")
        blueButton.position = CGPoint(x: screenSize.width * 0.85, y:screenSize.height * 0.2)
        blueButton.size = CGSize(width: screenSize.width * 0.06, height: screenSize.height * 0.08)
        blueButton.name = "blue"
        
        redButton = SKSpriteNode(imageNamed: "redButton")
        redButton.position = CGPoint(x: screenSize.width * 0.75, y:screenSize.height * 0.15)
        redButton.size = CGSize(width: screenSize.width * 0.06, height: screenSize.height * 0.08)
        redButton.name = "red"
        
        //GOKU
        //idle
        gokuIdleAtlas = SKTextureAtlas(named: "idle.1") //0
        gokuIdleFrames = [] //2. Initialize empty texture array
        let gokuIdleImages = gokuIdleAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        //move
        gokuMoveAtlas = SKTextureAtlas(named: "move.1") //0
        gokuMoveFrames = [] //2. Initialize empty texture array
        let gokuMoveImages = gokuMoveAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        
        //4. for loop
        //idle
        for i in 0...gokuIdleImages {
            let texture = "idle_\(i)" //grab each frame in atlas
            gokuIdleFrames.append(gokuIdleAtlas.textureNamed(texture))
        }//add frame to texture array
        gokuIdle = SKAction.animate(with: gokuIdleFrames, timePerFrame: 0.3, resize: true, restore: true)
        //move
        for i in 0...gokuMoveImages {
            let texture = "move_\(i)" //grab each frame in atlas
            gokuMoveFrames.append(gokuMoveAtlas.textureNamed(texture))
        }//add frame to texture array
        gokuMove = SKAction.animate(with: gokuMoveFrames, timePerFrame: 0.3, resize: true, restore: true)
       
        gokuSprite = SKSpriteNode(texture: SKTexture(imageNamed: "idle_0.png"))
        gokuSprite.position = CGPoint(x: screenSize.width * 0.2, y:screenSize.height/2)
        gokuSprite?.physicsBody = SKPhysicsBody(rectangleOf: (gokuSprite?.frame.size)!)
        gokuSprite?.physicsBody?.affectedByGravity = false;
        gokuSprite?.physicsBody?.allowsRotation = false;
        gokuSprite?.physicsBody?.mass = 2.0
        
        gokuSprite?.physicsBody?.categoryBitMask = playerCategory
        gokuSprite?.physicsBody?.contactTestBitMask = wallCategory
        gokuSprite?.physicsBody?.collisionBitMask = wallCategory
        
        //VEGETA
        //idle
        vegetaIdleAtlas = SKTextureAtlas(named: "vIddle.1") //0
        vegetaIdleFrames = [] //2. Initialize empty texture array
        let vegetaIdleImages = vegetaIdleAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        //move
        vegetaMoveAtlas = SKTextureAtlas(named: "vMove.1") //0
        vegetaMoveFrames = [] //2. Initialize empty texture array
        let vegetaMoveImages = vegetaMoveAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        
        //4. for loop
        //idle
        for i in 0...vegetaIdleImages {
            let texture = "vidle_\(i)" //grab each frame in atlas
            vegetaIdleFrames.append(vegetaIdleAtlas.textureNamed(texture))
        }//add frame to texture array
        vegetaIdle = SKAction.animate(with: vegetaIdleFrames, timePerFrame: 0.3, resize: true, restore: true)
        //move
        for i in 0...vegetaMoveImages {
            let texture = "vMove_\(i)" //grab each frame in atlas
            vegetaMoveFrames.append(vegetaMoveAtlas.textureNamed(texture))
        }//add frame to texture array
        vegetaMove = SKAction.animate(with: vegetaMoveFrames, timePerFrame: 0.3, resize: true, restore: true)
        
        vegetaSprite = SKSpriteNode(texture: SKTexture(imageNamed: "vidle_0.png"))
        vegetaSprite.setScale(0.6)
        vegetaSprite.position = CGPoint(x: screenSize.width * 0.8, y:screenSize.height/2)
        vegetaSprite?.physicsBody = SKPhysicsBody(rectangleOf: (vegetaSprite?.frame.size)!)
        vegetaSprite?.physicsBody?.affectedByGravity = false;
        vegetaSprite?.physicsBody?.allowsRotation = false;
        vegetaSprite?.physicsBody?.mass = 2.0
        
        vegetaSprite?.physicsBody?.categoryBitMask = enemyCategory
        vegetaSprite?.physicsBody?.contactTestBitMask = wallCategory
        vegetaSprite?.physicsBody?.collisionBitMask = wallCategory
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = borderBody
        self.physicsBody?.categoryBitMask = wallCategory
        self.physicsBody?.contactTestBitMask = playerCategory
        self.physicsBody?.contactTestBitMask = enemyCategory
        self.physicsWorld.contactDelegate = self
        
        addChild(background)
        addChild(gokuSprite)
        addChild(vegetaSprite)
        addChild(myLabel)
        addChild(moveJoystick)
        addChild(blueButton)
        addChild(redButton)

        
        gokuSprite.run(SKAction.repeatForever(gokuIdle)) // this way the animation will keep playing for ever
        vegetaSprite.run(SKAction.repeatForever(vegetaIdle)) // this way the animation will keep playing for ever
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    
   
    }
    
    @objc func fire(timer: Timer)
    {
       // print("I got called")
        time -= 1
        myLabel.text = String(time)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        myLabel.text = "\(time)"
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            enumerateChildNodes(withName: "//*", using: { ( node, stop) in
                if node.name == "red" {
                    if node.contains(t.location(in:self))// do whatever here
                    {
                        
                        //self.vegetaSprite.run(SKAction.repeat(self.vegetaMove, count: 1))
                        print("RED Button Pressed")
                    }
                }
                if node.name == "blue" {
                    if node.contains(t.location(in:self))// do whatever here
                    {
                        
                        self.gokuSprite.run(SKAction.repeat(self.gokuMove, count: 1))
                        print("RED Button Pressed")
                    }
                }
          
            })
        }
    }

}
