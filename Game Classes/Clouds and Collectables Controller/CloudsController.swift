//
//  CloudsController.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/15/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import SpriteKit
import GameplayKit

class CloudController {
    
    var collectablesController = CollectablesController()
    var lastCloudPositionY = CGFloat()

    func createRandomClouds() -> [SKSpriteNode] {
        var clouds = [SKSpriteNode]()
        
        for _ in 0..<2 {
            let cloud1 = SKSpriteNode(imageNamed: "Cloud 1");
            cloud1.name = "1"
            let cloud2 = SKSpriteNode(imageNamed: "Cloud 2");
            cloud2.name = "2"
            let cloud3 = SKSpriteNode(imageNamed: "Cloud 3");
            cloud3.name = "3"
            let darkCloud = SKSpriteNode(imageNamed: "Dark Cloud");
            darkCloud.name = "Dark Cloud"
            
            cloud1.xScale = 0.9
            cloud2.xScale = 0.9
            cloud3.xScale = 0.9
            darkCloud.xScale = 0.9
            
            cloud1.yScale = 0.9
            cloud2.yScale = 0.9
            cloud3.yScale = 0.9
            darkCloud.yScale = 0.9
            
            cloud1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cloud1.size.width - 10, height: cloud1.size.height - 18))
            cloud1.physicsBody?.restitution = 0
            cloud1.physicsBody?.affectedByGravity = false
            cloud1.physicsBody?.categoryBitMask = ColliderType.cloud.rawValue
            cloud1.physicsBody?.collisionBitMask = ColliderType.player.rawValue
            
            cloud2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cloud2.size.width - 10, height: cloud2.size.height - 23))
            cloud2.physicsBody?.restitution = 0
            cloud2.physicsBody?.affectedByGravity = false
            cloud2.physicsBody?.categoryBitMask = ColliderType.cloud.rawValue
            cloud2.physicsBody?.collisionBitMask = ColliderType.player.rawValue
            
            cloud3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cloud3.size.width - 10, height: cloud3.size.height - 20))
            cloud3.physicsBody?.restitution = 0
            cloud3.physicsBody?.affectedByGravity = false
            cloud3.physicsBody?.categoryBitMask = ColliderType.cloud.rawValue
            cloud3.physicsBody?.collisionBitMask = ColliderType.player.rawValue
            
            darkCloud.physicsBody = SKPhysicsBody(rectangleOf: darkCloud.size)
            darkCloud.physicsBody?.affectedByGravity = false
            darkCloud.physicsBody?.categoryBitMask = ColliderType.darkCloudAndCollectables.rawValue
            darkCloud.physicsBody?.collisionBitMask = ColliderType.player.rawValue
            
            clouds.append(cloud1)
            clouds.append(cloud2)
            clouds.append(cloud3)
            clouds.append(darkCloud)
        }
        
        // Prevent player die right at the beginning and two dark cloud next to each other
        repeat {
            clouds = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: clouds) as! [SKSpriteNode]
        } while clouds[0].name == "Dark Cloud" || self.twoDarkCloud(clouds)

        return clouds
    }
    
    func twoDarkCloud(_ clouds: [SKSpriteNode]) -> Bool {
        for i in 0..<clouds.count - 1 {
            if clouds[i].name == "Dark Cloud" && clouds[i].name == clouds[i + 1].name {
                return true
            }
        }
        return false
    }
    
    func arrangeCloudsAndCollectableInScene(scene: SKScene, distanceBetweenClouds: CGFloat, center: CGFloat, minX: CGFloat, maxX: CGFloat, initialClouds: Bool) {
        var clouds = createRandomClouds()
        
        if initialClouds {
            self.lastCloudPositionY = center - 100;
        }
        
        for i in 0..<clouds.count {
            let positionX = initialClouds && i == 0 ? 0 : randomX(min: minX, max: maxX)
            clouds[i].position = CGPoint(x: positionX, y: lastCloudPositionY)
            clouds[i].zPosition = 2
            
            scene.addChild(clouds[i])
            lastCloudPositionY -= distanceBetweenClouds
            
            if !initialClouds && clouds[i].name != "Dark Cloud" && arc4random_uniform(7) >= 3 {
                let collectable = collectablesController.getCollectable()
                collectable.position = CGPoint(x: clouds[i].position.x, y: clouds[i].position.y + 50)
                scene.addChild(collectable)
            }
        }
    }
    
    func randomX(min: CGFloat, max: CGFloat) -> CGFloat {
        return min + CGFloat(arc4random_uniform(UInt32(max - min + 1)))
    }
}




















