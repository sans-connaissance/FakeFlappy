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
}
