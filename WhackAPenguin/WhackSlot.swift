//
//  WhackSlot.swift
//  WhackAPenguin
//
//  Created by Shah Md Imran Hossain on 24/10/22.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }
}
