//
//  GameScene.swift
//  WhackAPenguin
//
//  Created by Shah Md Imran Hossain on 18/10/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    
    var popUpTime = 0.85
    var gameRounds = 0
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    // same as viewDidLoad or loadView in UIKit
    override func didMove(to view: SKView) {
        // setting background
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        score = 0
        
        // slots position
        placeTheSlots()
        
        // start the game
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    func placeTheSlots() {
        for i in 0..<5 {
            createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))
        }
        
        for i in 0..<4 {
            createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))
        }
        
        for i in 0..<5 {
            createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))
        }
        
        for i in 0..<4 {
            createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            print("no touch began")
            return
        }
        
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else {
                print("whackSlot casting failed")
                continue
            }
            
            if !whackSlot.isVisible {
                continue
            }
            
            if whackSlot.isHit {
                continue
            }
            
            whackSlot.hit()
            
            if node.name == "charFriend" {
                score -= 5
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        //gameRounds += 1
        
        if gameRounds > 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            return
        }
        
        popUpTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popUpTime)
        
        if Int.random(in: 0...12) > 4 {
            slots[1].show(hideTime: popUpTime)
        }
        
        if Int.random(in: 0...12) > 8 {
            slots[2].show(hideTime: popUpTime)
        }
        
        if Int.random(in: 0...12) > 10 {
            slots[3].show(hideTime: popUpTime)
        }
        
        if Int.random(in: 0...12) > 11 {
            slots[4].show(hideTime: popUpTime)
        }
        
        let minDelay = popUpTime / 2.0
        let maxDelay = popUpTime * 2
        
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
}
