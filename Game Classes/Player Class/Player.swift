//
//  Player.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/15/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import SpriteKit

enum ColliderType: UInt32 {
    case player = 0, cloud, darkCloudAndCollectables
}

class Player: SKSpriteNode {
    private var textureAtlas = SKTextureAtlas()
    private var playerTexture = [SKTexture]()
    private var animatedPlayerAction = SKAction()
    
    func initializePlayerAndAnimations() {
        textureAtlas = SKTextureAtlas(named: "Player.atlas")
        for i in 2...textureAtlas.textureNames.count {
            let name = "Player \(i)"
            playerTexture.append(SKTexture(imageNamed: name))
        }
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width - 50, height: self.size.height - 5))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        self.physicsBody?.categoryBitMask = ColliderType.player.rawValue
        self.physicsBody?.collisionBitMask = ColliderType.cloud.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.darkCloudAndCollectables.rawValue
        
        animatedPlayerAction = SKAction.animate(with: playerTexture, timePerFrame: 0.08, resize: true, restore: false)
    }
    
    func animatePlayer(left: Bool) {
        self.xScale = left ? -fabs(self.xScale) : fabs(self.xScale)
        self.run(SKAction.repeatForever(animatedPlayerAction), withKey: "Animate")
    }
    
    func stopPlayerAnimation() {
        self.removeAction(forKey: "Animate")
        self.texture = SKTexture(imageNamed: "Player 1")
        self.size = (self.texture?.size())!
    }
    
    func movePlayer(toLeft: Bool) {
        self.position.x = toLeft ? self.position.x - 7 : self.position.x + 7
    }
}
