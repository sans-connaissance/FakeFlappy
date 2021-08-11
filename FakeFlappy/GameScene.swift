//
//  GameScene.swift
//  FakeFlappy
//
//  Created by David Malicke on 8/10/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "plane")
    var touchingScreen = false
    
    override func didMove(to view: SKView) {
        //add gravity to the GameScene node
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        //give the player a physics body using it's image texture
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        
        
        player.position = CGPoint(x: -400, y: 250)
        addChild(player)
        
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
    
}
