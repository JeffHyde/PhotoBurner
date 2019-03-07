//
//  FireScene.swift
//  PhotoBurner
//
//  Created by Jeff  Hyde on 3/6/19.
//  Copyright © 2019 Jeff  Hyde. All rights reserved.
//

import UIKit
import SpriteKit

class FireScene: SKScene {
 override func didMove(to view: SKView) {
    if let node = self.childNode(withName: "RedNode") as? SKSpriteNode {
        print("Node: \(node.position.y)")
    }
    
    }
}
