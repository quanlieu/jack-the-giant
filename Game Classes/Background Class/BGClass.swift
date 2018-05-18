//
//  BGClass.swift
//  Jack the Giant
//
//  Created by Quan Lieu on 5/15/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import SpriteKit

class BGClass: SKSpriteNode {
    func moveBG(camera: SKCameraNode) {
        if self.position.y - self.size.height - 10 > camera.position.y {
            self.position.y -= self.size.height * 3
        }
    }
}
