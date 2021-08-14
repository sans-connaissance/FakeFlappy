//
//  GameScene.swift
//  FakeFlappy
//
//  Created by David Malicke on 8/10/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "plane")
    var touchingScreen = false
    var timer: Timer?
    let music = SKAudioNode(fileNamed: "the-hero.mp3")
    
    let scoreLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
       
        scoreLabel.fontColor = UIColor.black.withAlphaComponent(0.5)
        scoreLabel.position.y = 320
        addChild(scoreLabel)
        score = 0
        
        //this is the reference that begins physics collision detection
        physicsWorld.contactDelegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(createObstacle), userInfo: nil, repeats: true)
        
        //add gravity to the GameScene node
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        //give the player a physics body using it's image texture
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        
        
        player.position = CGPoint(x: -400, y: 250)
        
        player.physicsBody?.categoryBitMask = 1
        
        addChild(player)
        addChild(music)
        
        parallaxScroll(image: "sky", y: 0, z: -3, duration: 10, needsPhysics: false)
        parallaxScroll(image: "ground", y: -340, z: -1, duration: 6, needsPhysics: true)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touchingScreen = true
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if touchingScreen {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 300)

        }
        //rotate player
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        player.run(rotate)
        
        
    }
    
    func parallaxScroll(image: String, y: CGFloat, z: CGFloat, duration: Double, needsPhysics: Bool) {
        for i in 0...1 {
            let node = SKSpriteNode(imageNamed: image)
            
            //position the first node on the left, and the second node on the right
            node.position = CGPoint(x: 1023 * CGFloat(i), y: y)
            node.zPosition = z
            addChild(node)
            
            //collision detection
            if needsPhysics {
                node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
                node.physicsBody?.isDynamic = false
                node.physicsBody?.contactTestBitMask = 1
                node.name = "obstacle"
            }
            
            
            
            // make this node move the width of the screen by whatever duration was passed in
            let move = SKAction.moveBy(x: -1024, y: 0, duration: duration)
            
            // make it jump back to the right edge
            let wrap = SKAction.moveBy(x: 1024, y: 0, duration: 0)
            
            //make these two as a sequence that loops forever
            let sequence = SKAction.sequence([move, wrap])
            let forever = SKAction.repeatForever(sequence)
            
            //need to run the forever sequence within the node that was added as a child to main game node
            node.run(forever)
        }
        
    }
    
    @objc func createObstacle() {
        // create and position the bird
        let obstacle = SKSpriteNode(imageNamed: "enemy-bird")
        obstacle.zPosition = -2
        obstacle.position.x = 768
        addChild(obstacle)
        
        
        //collision detection
        obstacle.physicsBody = SKPhysicsBody(texture: obstacle.texture!, size: obstacle.texture!.size())
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.contactTestBitMask = 1
        obstacle.name = "obstacle"
        
        // decide where to create it
        obstacle.position.y = CGFloat.random(in: -300..<350)
        
        // make it move across the screen
        let action = SKAction.moveTo(x: -786, duration: 6)
        obstacle.run(action)
        
        // can this be moved into its own function?? REFACTOR
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            let coin = SKSpriteNode(imageNamed: "coin")
            coin.physicsBody = SKPhysicsBody(texture: coin.texture!, size: coin.texture!.size())
            
            coin.physicsBody?.contactTestBitMask = 1
            
            coin.physicsBody?.isDynamic = false
            coin.position.y = CGFloat.random(in: 100...1000)
            coin.position.x = 768
            coin.name = "score"
            coin.run(action)
            
            self.addChild(coin)
        }
    }
    
    func playerHit(_ node: SKNode) {
        if node.name == "obstacle" {
            
            if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
            music.removeFromParent()
            player.removeFromParent()
        } else if node.name == "score" {
            run(SKAction.playSoundFileNamed("score.wav", waitForCompletion: false))
            node.removeFromParent()
            score += 1
        }
    }
    // this is required for the collision detection and physicsWorld stuff above
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerHit(nodeB)
        } else if nodeB == player {
            playerHit(nodeA)
        }
    }
    
}
