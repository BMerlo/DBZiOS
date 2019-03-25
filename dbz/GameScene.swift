//
//  GameScene.swift
//  dbz
//
//  Created by BM on 2019-03-14.
//  Copyright © 2019 BM. All rights reserved.
//

import SpriteKit
import GameKit

let wallCategory: UInt32 = 0x00000001 << 0
let playerCategory: UInt32 = 0x00000001 << 1
let enemyCategory: UInt32 = 0x00000001 << 2
let attackGCategory: UInt32 = 0x00000001 << 3
let attackVCategory: UInt32 = 0x00000001 << 4

class GameScene: SKScene,SKPhysicsContactDelegate {

    var background:SKSpriteNode! //Sprite
    let screenSize: CGRect = UIScreen.main.bounds
    let velocityMultiplier: CGFloat = 0.12
    let fightMusic = SKAudioNode(fileNamed: "/music/fight.mp3")
    
    //self.fightMusic.run(SKAction.stop())
    
    var isTimeUp = false;
    var gokuWon = false;
    
    //AI ?
    var vegetaUp = true;
    var AIBlock = false;
    var attackVegetaDelay = 1.0
    var vegetaCanAttack = true;
    
    var RandomNumber = 1
    
    var gokuSprite:SKSpriteNode! //0
    //idle
    var gokuIdleAtlas: SKTextureAtlas! //Spritesheet //1
    var gokuIdleFrames: [SKTexture]! //frames //2
    var gokuIdle: SKAction! //Animation //3
    //move
    var gokuMoveAtlas: SKTextureAtlas! //Spritesheet //1
    var gokuMoveFrames: [SKTexture]! //frames //2
    var gokuMove: SKAction! //Animation //3
    //attack
    var gokuAttackAtlas: SKTextureAtlas! //Spritesheet //1
    var gokuAttackFrames: [SKTexture]! //frames //2
    var gokuAttack: SKAction! //Animation //3
    //attack2
    var gokuAttack2Atlas: SKTextureAtlas! //Spritesheet //1
    var gokuAttack2Frames: [SKTexture]! //frames //2
    var gokuAttack2: SKAction! //Animation //3
    
    var vegetaSprite:SKSpriteNode! //0
    //idle
    var vegetaIdleAtlas: SKTextureAtlas! //Spritesheet //1
    var vegetaIdleFrames: [SKTexture]! //frames //2
    var vegetaIdle: SKAction! //Animation //3
    //move
    var vegetaMoveAtlas: SKTextureAtlas! //Spritesheet //1
    var vegetaMoveFrames: [SKTexture]! //frames //2
    var vegetaMove: SKAction! //Animation //3
    //attack
    var vegetaAttackAtlas: SKTextureAtlas! //Spritesheet //1
    var vegetaAttackFrames: [SKTexture]! //frames //2
    var vegetaAttack: SKAction! //Animation //3
    //block
    var vegetaBlockAtlas: SKTextureAtlas! //Spritesheet //1
    var vegetaBlockFrames: [SKTexture]! //frames //2
    var vegetaBlock: SKAction! //Animation //3
    
    //SOUNDS
    let attackSfx = SKAudioNode(fileNamed: "/sounds/attack.wav")
    let attack2Sfx = SKAudioNode(fileNamed: "/sounds/attack1.wav")
    let clashSfx = SKAudioNode(fileNamed: "/sounds/clash.wav")
    let gokuAh = SKAudioNode(fileNamed: "/sounds/gokuAh.mp3")
    let gokuDies = SKAudioNode(fileNamed: "/sounds/gokuDies.mp3")
    let gokuPunch = SKAudioNode(fileNamed: "/sounds/punch.mp3")
    
    let vegetaAh = SKAudioNode(fileNamed: "/sounds/vegetaAh.mp3")
    let vegetaDamaged = SKAudioNode(fileNamed: "/sounds/vegetaDamaged.mp3")
    let vegetaDies = SKAudioNode(fileNamed: "/sounds/vegetaDies.mp3")
    
    //UI
    let moveJoystick = 🕹(withDiameter: 80)
    var redButton:SKSpriteNode!
    var blueButton:SKSpriteNode!
    var backButton:SKSpriteNode!
    
    var vegetaAvatar:SKSpriteNode!
    var gokuAvatar:SKSpriteNode!
    
    var gokuBar:SKSpriteNode! //0
    var vegetaBar:SKSpriteNode! //0
    var redBar1:SKSpriteNode! //0
    var redBar2:SKSpriteNode! //0
    var gHealth = 140.0
    var vHealth = 140.0
        
    let myLabel = SKLabelNode(fontNamed:"Helvetica")
    var timer = Timer()
    var timerAI = Timer()
    var timerDelay = Timer()
    var time = 180
    
    var moveBall:SKAction!
    var moveBall2:SKAction!
    
    var gDiedAudio = false;
    var vDiedAudio = false;
    var gameOver = false;
    
    var coolDownAttack1 = 1.0
    var coolDownAttack1passed = 0.0
    var boolAttack1 = false;
    
    override init(size: CGSize) {
        super.init(size: size)
        
        addChild(fightMusic)
        attackSfx.autoplayLooped = false;
        attack2Sfx.autoplayLooped = false;
        clashSfx.autoplayLooped = false;
        gokuAh.autoplayLooped = false;
        gokuDies.autoplayLooped = false;
        gokuPunch.autoplayLooped = false;
        vegetaAh.autoplayLooped = false;
        vegetaDamaged.autoplayLooped = false;
        vegetaDies.autoplayLooped = false;
        
        moveBall = SKAction.moveBy(x: screenSize.width, y: 0, duration: 1.6)
        moveBall2 = SKAction.moveBy(x: -screenSize.width, y: 0, duration: 1.8)
        
        myLabel.text = "\(time)"
        myLabel.fontSize = 36
        myLabel.position = CGPoint(x: screenSize.width/2, y:screenSize.height * 0.88)
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
    
        let timerAI = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(VegetaRandomAI(timer:)), userInfo: nil, repeats: true)
        
        let timerDelay = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(VegetaDeleayAttack(timer:)), userInfo: nil, repeats: true)
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        background.size = CGSize(width: screenSize.width, height: screenSize.height)
        
        moveJoystick.position = CGPoint(x: screenSize.width * 0.15, y:screenSize.height * 0.2)
        moveJoystick.zPosition = 4
        
        gokuBar = SKSpriteNode(color: SKColor.green, size: CGSize(width: gHealth, height: 30))
        gokuBar.position = CGPoint(x: screenSize.width * 0.12, y:screenSize.height * 0.90)
        gokuBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        redBar1 = SKSpriteNode(color: SKColor.red, size: CGSize(width: gHealth, height: 32))
        redBar1.position = CGPoint(x: screenSize.width * 0.12 - 1, y:screenSize.height * 0.90)
        redBar1.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        vegetaBar = SKSpriteNode(color: SKColor.green, size: CGSize(width: vHealth, height: 30))
        vegetaBar.position = CGPoint(x: screenSize.width * 0.85, y:screenSize.height * 0.90)
        vegetaBar.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        
        redBar2 = SKSpriteNode(color: SKColor.red, size: CGSize(width: vHealth, height: 32))
        redBar2.position = CGPoint(x: screenSize.width * 0.85 + 1, y:screenSize.height * 0.90)
        redBar2.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        
        blueButton = SKSpriteNode(imageNamed: "blueButton")
        blueButton.position = CGPoint(x: screenSize.width * 0.85, y:screenSize.height * 0.2)
        blueButton.size = CGSize(width: screenSize.width * 0.06, height: screenSize.height * 0.08)
        blueButton.name = "blue"
        
        redButton = SKSpriteNode(imageNamed: "redButton")
        redButton.position = CGPoint(x: screenSize.width * 0.75, y:screenSize.height * 0.15)
        redButton.size = CGSize(width: screenSize.width * 0.06, height: screenSize.height * 0.08)
        redButton.name = "red"
        
        backButton = SKSpriteNode(imageNamed: "smallerback")
        backButton.setScale(0.35)
        backButton.position = CGPoint(x: screenSize.width * 0.98, y:screenSize.height * 0.95)
        backButton.name = "back"
        
        vegetaAvatar = SKSpriteNode(imageNamed: "vegetaPortrait")
        vegetaAvatar.setScale(0.15)
        vegetaAvatar.position = CGPoint(x: screenSize.width * 0.93, y:screenSize.height * 0.90)
        gokuAvatar = SKSpriteNode(imageNamed: "gokuPortrait")
        gokuAvatar.setScale(0.15)
        gokuAvatar.position = CGPoint(x: screenSize.width * 0.07, y:screenSize.height * 0.90)
        
        //GOKU
        //idle
        gokuIdleAtlas = SKTextureAtlas(named: "idle2.1") //0
        gokuIdleFrames = [] //2. Initialize empty texture array
        let gokuIdleImages = gokuIdleAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        //move
        gokuMoveAtlas = SKTextureAtlas(named: "move.1") //0
        gokuMoveFrames = [] //2. Initialize empty texture array
        let gokuMoveImages = gokuMoveAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        //attack
        gokuAttackAtlas = SKTextureAtlas(named: "attack.1") //0
        gokuAttackFrames = [] //2. Initialize empty texture array
        let gokuAttackImages = gokuAttackAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        //attack2
        gokuAttack2Atlas = SKTextureAtlas(named: "attack2.1") //0
        gokuAttack2Frames = [] //2. Initialize empty texture array
        let gokuAttack2Images = gokuAttack2Atlas.textureNames.count-1
        
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
        }
        gokuMove = SKAction.animate(with: gokuMoveFrames, timePerFrame: 0.3, resize: true, restore: true)
        //attack
        for i in 0...gokuAttackImages {
            let texture = "attack_\(i)" //grab each frame in atlas
            gokuAttackFrames.append(gokuAttackAtlas.textureNamed(texture))
        }
        gokuAttack = SKAction.animate(with: gokuAttackFrames, timePerFrame: 0.2, resize: true, restore: true)
        //attack2
        for i in 0...gokuAttack2Images {
            let texture = "attack2_\(i)" //grab each frame in atlas
            gokuAttack2Frames.append(gokuAttack2Atlas.textureNamed(texture))
        }
        gokuAttack2 = SKAction.animate(with: gokuAttack2Frames, timePerFrame: 0.2, resize: true, restore: true)
       
        gokuSprite = SKSpriteNode(texture: SKTexture(imageNamed: "idle_0.png"))
        gokuSprite.setScale(0.6)
        gokuSprite.position = CGPoint(x: screenSize.width * 0.2, y:screenSize.height/2)
        gokuSprite?.physicsBody = SKPhysicsBody(rectangleOf: (gokuSprite?.frame.size)!)
        gokuSprite?.physicsBody?.affectedByGravity = false;
        gokuSprite?.physicsBody?.allowsRotation = false;
        gokuSprite?.physicsBody?.mass = 2.0
        
        gokuSprite?.physicsBody?.categoryBitMask = playerCategory
        gokuSprite?.physicsBody?.contactTestBitMask = 00011111
        gokuSprite?.physicsBody?.collisionBitMask = 00000101
        
        //VEGETA
        //idle
        vegetaIdleAtlas = SKTextureAtlas(named: "vIddle.1") //0
        vegetaIdleFrames = [] //2. Initialize empty texture array
        let vegetaIdleImages = vegetaIdleAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        //move
        vegetaMoveAtlas = SKTextureAtlas(named: "vMove.1") //0
        vegetaMoveFrames = [] //2. Initialize empty texture array
        let vegetaMoveImages = vegetaMoveAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        //attack
        vegetaAttackAtlas = SKTextureAtlas(named: "vAttack.1") //0
        vegetaAttackFrames = [] //2. Initialize empty texture array
        let vegetaAttackImages = vegetaAttackAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        //block
        vegetaBlockAtlas = SKTextureAtlas(named: "vBlock.1") //0
        vegetaBlockFrames = [] //2. Initialize empty texture array
        let vegetaBlockImages = vegetaBlockAtlas.textureNames.count-1//3. count how many frames inside atlas (if this does not work do
        
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
        }
        vegetaMove = SKAction.animate(with: vegetaMoveFrames, timePerFrame: 0.3, resize: true, restore: true)
        //attack
        for i in 0...vegetaAttackImages {
            let texture = "vAttack_\(i)" //grab each frame in atlas
            vegetaAttackFrames.append(vegetaAttackAtlas.textureNamed(texture))
        }
        vegetaAttack = SKAction.animate(with: vegetaAttackFrames, timePerFrame: 0.3, resize: true, restore: true)
        //block
        for i in 0...vegetaBlockImages {
            let texture = "vBlock_\(i)" //grab each frame in atlas
            vegetaBlockFrames.append(vegetaBlockAtlas.textureNamed(texture))
        }
        vegetaBlock = SKAction.animate(with: vegetaBlockFrames, timePerFrame: 0.3, resize: true, restore: true)
        
        vegetaSprite = SKSpriteNode(texture: SKTexture(imageNamed: "vidle_0.png"))
        vegetaSprite.setScale(0.6)
        vegetaSprite.position = CGPoint(x: screenSize.width * 0.8, y:screenSize.height/2)
        vegetaSprite?.physicsBody = SKPhysicsBody(rectangleOf: (vegetaSprite?.frame.size)!)
        vegetaSprite?.physicsBody?.affectedByGravity = false;
        vegetaSprite?.physicsBody?.allowsRotation = false;
        vegetaSprite?.physicsBody?.mass = 2.0
        
        vegetaSprite?.physicsBody?.categoryBitMask = enemyCategory
        vegetaSprite?.physicsBody?.contactTestBitMask = 00011111
        vegetaSprite?.physicsBody?.collisionBitMask = 00001111;
        
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
        addChild(vegetaAvatar)
        addChild(gokuAvatar)
        addChild(moveJoystick)
        addChild(blueButton)
        addChild(redButton)
       // addChild(backButton) added to debug AI
        
        addChild(redBar1)
        addChild(gokuBar)
        addChild(redBar2)
        addChild(vegetaBar)
        
        addChild(attackSfx)
        addChild(attack2Sfx)
        addChild(clashSfx)
        addChild(gokuAh)
        addChild(gokuDies)
        addChild(gokuPunch)
        addChild(vegetaAh)
        
        addChild(vegetaDamaged)
        addChild(vegetaDies)
        
        gokuSprite.run(SKAction.repeatForever(gokuIdle)) // this way the animation will keep playing for ever
        vegetaSprite.run(SKAction.repeatForever(vegetaIdle)) // this way the animation will keep playing for ever
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    
   
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == wallCategory {
            print("player first")
        }
        
        if contact.bodyA.categoryBitMask == wallCategory && contact.bodyB.categoryBitMask == playerCategory {
            
        }
        
        if contact.bodyA.categoryBitMask == wallCategory && contact.bodyB.categoryBitMask == enemyCategory {
            vegetaUp = !vegetaUp;
        }
        
        if contact.bodyA.categoryBitMask == wallCategory && contact.bodyB.categoryBitMask == attackGCategory {
            contact.bodyB.node?.removeFromParent()
            print("attackG removed")
        }
        
        if contact.bodyA.categoryBitMask == wallCategory && contact.bodyB.categoryBitMask == attackVCategory {
            contact.bodyB.node?.removeFromParent()
            print("attackV removed")
        }
        
        if contact.bodyA.categoryBitMask == enemyCategory && contact.bodyB.categoryBitMask == attackGCategory {
            contact.bodyB.node?.removeFromParent()
            if AIBlock {
                vHealth -= 5
            self.clashSfx.run(SKAction.play());
            }
            else {
                vHealth -= 15
                self.vegetaDamaged.run(SKAction.play());
            }
            
            
        }
        
        if contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == enemyCategory {

            let moveBack = SKAction.moveBy(x: -10, y: 0, duration: 0.3)
            gokuSprite.run(moveBack)
            print("player collided enemy")
            
        }
        
        if contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == attackVCategory {
            contact.bodyB.node?.removeFromParent()
            self.gokuAh.run(SKAction.play());
            gHealth -= 15
            print("player collided enemyBall")
        }
        
        if contact.bodyA.categoryBitMask == attackVCategory && contact.bodyB.categoryBitMask == attackGCategory {
            //if ki blasts collide they will destroy each other
            contact.bodyB.node?.removeFromParent()
            contact.bodyA.node?.removeFromParent()
            
        }
        
    }
    
    @objc func fire(timer: Timer)
    {
       // print("I got called")
        time -= 1
        myLabel.text = String(time)
    }
    
    @objc func VegetaRandomAI(timer: Timer)
    {
        // print("I got called")
        RandomNumber = Int.random(in: 0 ..< 100)
        
    }
    
    @objc func VegetaDeleayAttack(timer: Timer)
    {
        // print("I got called")
        vegetaCanAttack = true;
        
    }
    
    @objc func VegetaRandomAI(){
        RandomNumber = Int.random(in: 0 ..< 100)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        myLabel.text = "\(time)"
       
        //AI?
        if(vegetaSprite.position.x != screenSize.width * 0.8){
            let moveOrigin = SKAction.moveTo(x: screenSize.width * 0.8, duration: 0.3)
            
            vegetaSprite.run(moveOrigin)
            
        }
        
        
        
        moveJoystick.on(.move) { [unowned self] joystick in
            guard let gokuSprite = self.gokuSprite else {
                return
            }
            
            let pVelocity = joystick.velocity;
            let speed = CGFloat(0.09)
            self.gokuSprite.run(SKAction.repeat(self.gokuMove, count: 1))
            gokuSprite.position = CGPoint(x: gokuSprite.position.x + (pVelocity.x * speed), y: gokuSprite.position.y + (pVelocity.y * speed))
         //   print(gokuSprite.position)
            
        }
        
        if time <= 0{
            isTimeUp = true
            myLabel.removeFromParent()
        }
        
        if(isTimeUp){
            if gokuWon && !gameOver{
                self.perform(#selector(self.changeScene), with: nil, afterDelay: 2.0)
                gameOver = true
                
            }
            else if !gokuWon && !gameOver{
               self.perform(#selector(self.changeScene2), with: nil, afterDelay: 2.0)
                gameOver = true
            }
            
        }
        
        self.gokuBar.size = self.CGSizeMake(CGFloat(self.gHealth), 30.0)
        self.vegetaBar.size = self.CGSizeMake(CGFloat(self.vHealth), 30.0)
        
        if(gHealth > vHealth){
            gokuWon = true
        }
        else {
            gokuWon = false
        }
        
        if(gHealth < 0){
            gHealth = 0
        }
        
        if(vHealth < 0){
            vHealth = 0
        }
        
        if vHealth == 0 {
            if !vDiedAudio {
            vegetaDies.run(SKAction.play());
                vDiedAudio = true
                isTimeUp = true
                moveJoystick.removeFromParent()
                redButton.removeFromParent()
                blueButton.removeFromParent()
                vegetaSprite.removeFromParent()
                myLabel.removeFromParent()
            }
        }
        
        if(gHealth == 0){
            if !gDiedAudio {
                gokuDies.run(SKAction.play());
                gDiedAudio = true
                isTimeUp = true
                moveJoystick.removeFromParent()
                redButton.removeFromParent()
                blueButton.removeFromParent()
                gokuSprite.removeFromParent()
                vegetaSprite.removeFromParent()
                myLabel.removeFromParent()
            }
        }
        
        //AIVE
        switch RandomNumber { // 0 to 99
        case 0..<5:
            self.AIBlock = true
            self.vegetaSprite.run(SKAction.repeatForever(self.vegetaBlock), completion: {
                print(self.RandomNumber)
            })
        case 5..<20:
            self.AIBlock = false
            self.vegetaSprite.run(SKAction.repeatForever(self.vegetaIdle))
        case 20..<30:
            self.AIBlock = false
            if(self.vegetaUp){
            self.vegetaSprite.run(SKAction.repeat(self.vegetaMove, count: 1))
            vegetaSprite.position = CGPoint(x: vegetaSprite.position.x, y: vegetaSprite.position.y + 10)
            }
            else{
                self.vegetaSprite.run(SKAction.repeat(self.vegetaMove, count: 1))
                vegetaSprite.position = CGPoint(x: vegetaSprite.position.x, y: vegetaSprite.position.y - 10)
            }
        case 30..<40:
            if(!self.vegetaUp){
                self.vegetaSprite.run(SKAction.repeat(self.vegetaMove, count: 1))
                vegetaSprite.position = CGPoint(x: vegetaSprite.position.x, y: vegetaSprite.position.y + 10)
            }
            else{
                self.vegetaSprite.run(SKAction.repeat(self.vegetaMove, count: 1))
                vegetaSprite.position = CGPoint(x: vegetaSprite.position.x, y: vegetaSprite.position.y - 10)
            }
        case 40..<60:
            if self.vegetaCanAttack {
               self.vegetaCanAttack = false
                self.AIBlock = false
                self.vegetaSprite.run(self.vegetaAttack, completion: {
            
                    var vegetaBall:SKSpriteNode!
            vegetaBall = SKSpriteNode(imageNamed: "ballVegeta")
            vegetaBall.setScale(0.5)
            vegetaBall.position = CGPoint(x: self.vegetaSprite.position.x - 30, y:self.vegetaSprite.position.y)
            vegetaBall.run(self.moveBall2)
            
            vegetaBall?.physicsBody = SKPhysicsBody(rectangleOf: (vegetaBall?.frame.size)!)
            vegetaBall?.physicsBody?.affectedByGravity = false;
            vegetaBall?.physicsBody?.allowsRotation = false;
            vegetaBall?.physicsBody?.mass = 2.0
            vegetaBall?.physicsBody?.categoryBitMask = attackVCategory
            vegetaBall?.physicsBody?.contactTestBitMask = 00011111
            vegetaBall?.physicsBody?.collisionBitMask = 00010011;
            
            self.addChild(vegetaBall)
            print(self.RandomNumber)
            self.vegetaCanAttack = false
            })
            }
            else {
                self.vegetaCanAttack = false
                  self.VegetaRandomAI()
            }
        case 60..<85:
            self.AIBlock = false
            self.vegetaSprite.run(SKAction.repeatForever(vegetaIdle))
        case 85..<100:
            self.AIBlock = true
            self.vegetaSprite.run(SKAction.repeatForever(self.vegetaBlock), completion: {
                print(self.RandomNumber)
            })
        default:
            self.AIBlock = false
            print(self.RandomNumber)
        }
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            enumerateChildNodes(withName: "//*", using: { ( node, stop) in
                if node.name == "red" {
                    if node.contains(t.location(in:self))// do whatever here
                    {
                        self.gokuPunch.run(SKAction.play());
                        //self.gokuSprite.run(SKAction.repeat(self.gokuAttack,  count: 1))
                        self.gokuSprite.run(self.gokuAttack, completion: {
                        self.boolAttack1 = true;
                        //self.AIBlock = !self.AIBlock
                            if self.gokuSprite.position.x < self.vegetaSprite.position.x - 38 &&
                                self.gokuSprite.position.x > 400 &&
                                self.gokuSprite.position.y < self.vegetaSprite.position.y + 80 &&
                                self.gokuSprite.position.y > self.vegetaSprite.position.y - 80
                                {
                                    if self.AIBlock {
                                        self.vHealth -= 5;
                                        self.attack2Sfx.run(SKAction.play());
                                    }
                                    else{
                                        self.vHealth -= 20;
                                        self.vegetaDamaged.run(SKAction.play());
                                    }
                            }
                            //("\(ship.position.x)")
                     /*       print("goku x " + "\(self.gokuSprite.position.x)")
                            print("goku y " + "\(self.gokuSprite.position.y)")
                            print("veg x " + "\(self.vegetaSprite.position.x - 42)")
                            print("veg y + 80 " + "\(self.vegetaSprite.position.y + 80)")
                            print("veg y - 80 " + "\(self.vegetaSprite.position.y - 80)")*/
                        //print("RED Button Pressed")
                        })
                    }
                }
                if node.name == "blue" {
                    if node.contains(t.location(in:self))// do whatever here
                    {
                        //self.vegetaSprite.position = CGPoint(x: self.vegetaSprite.position.x, y: self.vegetaSprite.position.y - 10)
                        self.attackSfx.run(SKAction.play());
                        self.gokuSprite.run(self.gokuAttack2,  completion: {
                        
                        //ATTACKS
                        var gokuBall:SKSpriteNode!
                        gokuBall = SKSpriteNode(imageNamed: "ballGoku")
                        gokuBall.setScale(0.5)
                        gokuBall.position = CGPoint(x: self.gokuSprite.position.x + 25, y:self.gokuSprite.position.y)
                        gokuBall.run(self.moveBall)
                        
                        gokuBall?.physicsBody = SKPhysicsBody(rectangleOf: (gokuBall?.frame.size)!)
                        gokuBall?.physicsBody?.affectedByGravity = false;
                        gokuBall?.physicsBody?.allowsRotation = false;
                        gokuBall?.physicsBody?.mass = 2.0
                        gokuBall?.physicsBody?.categoryBitMask = attackGCategory
                        gokuBall?.physicsBody?.contactTestBitMask = 00011111
                        gokuBall?.physicsBody?.collisionBitMask = 00010001;
                        
                        self.addChild(gokuBall)
                        })
                    }
                }
                if node.name == "back" {
                    if node.contains(t.location(in:self))// do whatever here
                    {
                        self.attackSfx.run(SKAction.play());
                        self.vegetaSprite.run(SKAction.repeat(self.vegetaAttack,  count: 1))
                        var vegetaBall:SKSpriteNode!
                        vegetaBall = SKSpriteNode(imageNamed: "ballVegeta")
                        vegetaBall.zPosition = 3
                        vegetaBall.setScale(0.5)
                        vegetaBall.position = CGPoint(x: self.vegetaSprite.position.x - 30, y:self.vegetaSprite.position.y)
                        vegetaBall.run(self.moveBall2)
                        
                        vegetaBall?.physicsBody = SKPhysicsBody(rectangleOf: (vegetaBall?.frame.size)!)
                        vegetaBall?.physicsBody?.affectedByGravity = false;
                        vegetaBall?.physicsBody?.allowsRotation = false;
                        vegetaBall?.physicsBody?.mass = 2.0
                        vegetaBall?.physicsBody?.categoryBitMask = attackVCategory
                        vegetaBall?.physicsBody?.contactTestBitMask = 00011111
                        vegetaBall?.physicsBody?.collisionBitMask = 00001001;
                        
                        self.addChild(vegetaBall)
                //        print("BACK Button Pressed")
                    }
                }
          
            })
        }
    }

    @objc func changeScene(){ //change scene after 2 sec
        fightMusic.run(SKAction.stop())
        let reveal = SKTransition.reveal(with: .up, duration: 0.6)
        let newScene = GameOverScene(size:self.size)
        self.view?.presentScene(newScene, transition: reveal)
    }
    
    
    @objc func changeScene2(){ //change scene after 2 sec
        fightMusic.run(SKAction.stop())
        let reveal = SKTransition.reveal(with: .up, duration: 0.6)
        let newScene = GameOverScene2(size:self.size)
        self.view?.presentScene(newScene, transition: reveal)
    }
    
    func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
}
