//
//  GameScene.swift
//  Toothy knock 2
//
//  Created by yuma@duck on 28/10/16.
//  Copyright © 2016 Yuma@duck. All rights reserved.
//

import SpriteKit
import GameplayKit

struct CatergoryMasks {
    static var rockMask: UInt32 = 0x1
    static var tooth1: UInt32 = 0x1 << 1
    static var tooth2: UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var rock: SKSpriteNode!
    var tooth1: SKSpriteNode!
    var tooth2: SKSpriteNode!
    
    var isDropping = false
    
    override func didMove(to view: SKView) {
        rock = childNode(withName: "rock") as! SKSpriteNode
        tooth1 = childNode(withName: "tooth1") as! SKSpriteNode
        tooth2 = childNode(withName: "tooth2") as! SKSpriteNode
        
        rock.physicsBody?.categoryBitMask = CatergoryMasks.rockMask
        tooth1.physicsBody?.categoryBitMask = CatergoryMasks.tooth1
        tooth2.physicsBody?.categoryBitMask = CatergoryMasks.tooth2
        
        rock.physicsBody?.contactTestBitMask = CatergoryMasks.tooth1 | CatergoryMasks.tooth2
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDropping {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let whereTouched = nodes(at: touchLocation)
                
                rock.position.x = touchLocation.x
                
                if !whereTouched.isEmpty {
                    if whereTouched[0] as! SKSpriteNode == rock {
                        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
                        isDropping = true
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDropping {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                
                rock.position.x = touchLocation.x
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if rock.position.y <= -640 {
            physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            
            rock.position.y = 578
            rock.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            rock.physicsBody?.angularVelocity = 0
            rock.zRotation = 0
            
            
            isDropping = false
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1Id: UInt32
        var body2Id: UInt32
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1Id = contact.bodyA.categoryBitMask
            body2Id = contact.bodyB.categoryBitMask
        } else {
            body1Id = contact.bodyB.categoryBitMask
            body2Id = contact.bodyA.categoryBitMask
        }
        
        if body1Id == CatergoryMasks.rockMask {
            if body2Id == CatergoryMasks.tooth1 {
                tooth1.removeFromParent()
            } else if body2Id == CatergoryMasks.tooth2 {
                tooth2.removeFromParent()
            }
        }
    }
}
