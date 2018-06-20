//
//  GameScene.swift
//  SubmarineGame
//
//  Created by Jenneke Choe on 18/06/2018.
//  Copyright © 2018 Jenneke Choe. All rights reserved.
//
import GameplayKit
import SpriteKit

extension CollScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    guard let bodyA = contact.bodyA.node else { return }
    guard let bodyB = contact.bodyB.node else { return }
    
    if bodyA == playerS && bodyB == groundS {
      print("Ground")
    }
    if bodyA == playerS && bodyB == enemyS {
      print("DEAD")
    }
  }
}

class CollScene: SKScene {
  
  var playerS: SKSpriteNode!
  var groundS: SKSpriteNode!
  var enemyS: SKSpriteNode!
  var collectibleS: SKSpriteNode!
  
  var touchingPlayer = false
  
  enum CollisionTypes: UInt32 {
    case player = 1
    case enemy = 2
    case ground = 4
    case collectible = 8
  }
  
  override func didMove(to view: SKView) {
    physicsWorld.contactDelegate = self
    
    playerS = SKSpriteNode(color: .blue, size: CGSize(width: 80, height: 80))
    playerS.position = CGPoint(x: 100, y: (view.frame.height / 2) + 100)
    playerS.physicsBody = SKPhysicsBody(rectangleOf: playerS.frame.size)
    playerS.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
    playerS.physicsBody?.collisionBitMask = CollisionTypes.ground.rawValue | CollisionTypes.enemy.rawValue
    playerS.physicsBody?.contactTestBitMask = CollisionTypes.ground.rawValue | CollisionTypes.enemy.rawValue
//    playerS.physicsBody?.isDynamic = false
    playerS.physicsBody?.affectedByGravity = false
    addChild(playerS)
    
    groundS = SKSpriteNode(color: .red, size: CGSize(width: view.frame.width, height: 50))
    groundS.position = CGPoint(x: (view.frame.width / 2), y: 25)
    groundS.physicsBody = SKPhysicsBody(rectangleOf: groundS.frame.size)
    groundS.physicsBody?.categoryBitMask = CollisionTypes.ground.rawValue
//    groundS.physicsBody?.collisionBitMask = CollisionTypes.player.rawValue
    groundS.physicsBody?.isDynamic = false
    groundS.physicsBody?.affectedByGravity = false
    addChild(groundS)
    
    enemyS = SKSpriteNode(imageNamed: "shit-jolie")
    enemyS.position = CGPoint(x: 400, y: view.frame.height / 2)
    enemyS.physicsBody = SKPhysicsBody(rectangleOf: enemyS.frame.size)
    enemyS.physicsBody?.categoryBitMask = CollisionTypes.enemy.rawValue
    enemyS.physicsBody?.collisionBitMask = 0
    enemyS.physicsBody?.affectedByGravity = false
    addChild(enemyS)
    
//    collectibleS = SKSpriteNode(imageNamed: "coin")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // this method is called when the user touches the screen
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    if tappedNodes.contains(playerS) {
      touchingPlayer = true
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touchingPlayer else { return }
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    playerS.position = location
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // this method is called when the user stops touching the screen
    touchingPlayer = false
  }
  
  
}
