//
//  CollectablesController.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/17/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import Foundation
import SpriteKit

class CollectablesController {
    func getCollectable() -> SKSpriteNode {
        var collectable = SKSpriteNode()
        
        if arc4random_uniform(7) >= 4 {
            if GameplayController.instance.life < 2 {
                collectable = SKSpriteNode(imageNamed: "Life")
                collectable.name = "Life"
                collectable.physicsBody = SKPhysicsBody(rectangleOf: collectable.size)
            } else {
                collectable.name = "False life"
            }
        } else {
            collectable = SKSpriteNode(imageNamed: "Coin")
            collectable.name = "Coin"
            collectable.physicsBody = SKPhysicsBody(rectangleOf: collectable.size)
        }
        
        collectable.physicsBody?.affectedByGravity = false
        collectable.physicsBody?.categoryBitMask = ColliderType.darkCloudAndCollectables.rawValue
        collectable.physicsBody?.collisionBitMask = ColliderType.player.rawValue
        collectable.zPosition = 3
        
        return collectable
    }
}
