//
//  GameScene.swift
//  SubmarineGame
//
//  Created by Jenneke Choe on 18/06/2018.
//  Copyright © 2018 Jenneke Choe. All rights reserved.
//
import GameplayKit
import SpriteKit

let music = SKAudioNode(fileNamed: "cyborg-ninja")

@objcMembers
class GameScene: SKScene, SKPhysicsContactDelegate {
  
  let player = SKSpriteNode(imageNamed: "player-submarine")
//  let player = SKSpriteNode(imageNamed: "shit-jolie")
  var touchingPlayer = false
  var gameTimer: Timer?
  let scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
  var score = 0 {
    didSet {
      scoreLabel.text = "SCORE: \(score)"
    }
  }
  
  
  override func didMove(to view: SKView) {
    // this method is called when your game scene is ready to run
    let background = SKSpriteNode(imageNamed: "water-bg")
    let xPos = view.frame.width / 2
    let yPos = view.frame.height / 2
    background.position = CGPoint(x: xPos, y: yPos)
    background.zPosition = -1
    addChild(background)
    addChild(music)
    
//    player.size = CGSize(width: 50, height: 50)
    player.position = CGPoint(x: 100, y: 200)
    player.zPosition = 1
    player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
    player.physicsBody?.affectedByGravity = false
    player.physicsBody?.categoryBitMask = 1
    addChild(player)
    
    scoreLabel.zPosition = 2
    scoreLabel.position = CGPoint(x: 100, y: 320)
    addChild(scoreLabel)
    
    score = 0
    
    if let particles = SKEmitterNode(fileNamed: "Bubbles") {
      particles.advanceSimulationTime(10)
      particles.position.x = 612
      addChild(particles)
    }
    gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    
    physicsWorld.contactDelegate = self
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // this method is called when the user touches the screen
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    if tappedNodes.contains(player) {
      touchingPlayer = true
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touchingPlayer else { return }
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    player.position = location
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // this method is called when the user stops touching the screen
    touchingPlayer = false
  }
  
  override func update(_ currentTime: TimeInterval) {
    // this method is called before each frame is rendered
//     guard let view = view else { return }
    
    if player.position.x < -600 {
      player.position.x = -600
    } else if player.position.x > 600  {
      player.position.x = 600
    }
    
    if player.position.y < -375 {
      player.position.y = -375
    } else if player.position.y > 375 {
      player.position.y = 375
    }
    
    for node in children {
      if node.position.x < -700 {
        node.removeFromParent()
      }
    }
  }
  
  func createEnemy() {
    createBonus()
    
//    let randomDistribution = GKRandomDistribution(lowestValue: -350, highestValue: 350)
//    let sprite = SKSpriteNode(imageNamed: "fish")
//    sprite.position = CGPoint(x: 700, y: randomDistribution.nextInt())
//    sprite.name = "enemy"
//    sprite.zPosition = 1
//    addChild(sprite)
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody?.affectedByGravity = false
    sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
    sprite.physicsBody?.linearDamping = 0
    sprite.physicsBody?.contactTestBitMask = 1
    sprite.physicsBody?.categoryBitMask = 0
  }
  
  func createBonus() {
    let randomDistribution = GKRandomDistribution(lowestValue: -350, highestValue: 350)
    let sprite = SKSpriteNode(imageNamed: "coin")
    sprite.position = CGPoint(x: 700, y: randomDistribution.nextInt())
    sprite.name = "bonus"
    sprite.zPosition = 1
    addChild(sprite)
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody?.affectedByGravity = false
    sprite.physicsBody?.velocity = CGVector(dx: -300, dy: 0)
    sprite.physicsBody?.linearDamping = 0
    sprite.physicsBody?.contactTestBitMask = 1
    sprite.physicsBody?.categoryBitMask = 0
    sprite.physicsBody?.collisionBitMask = 0
  }
  
  func createSprite(image: String, name: String) {
    let randomDistribution = GKRandomDistribution(lowestValue: -350, highestValue: 350)
    let sprite = SKSpriteNode(imageNamed: image)
    sprite.position = CGPoint(x: 700, y: randomDistribution.nextInt())
    sprite.name = name
    sprite.zPosition = 1
    addChild(sprite)
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }
    
    if nodeA == player {
      playerHit(nodeB)
    } else {
      playerHit(nodeA)
    }
  }
  
  func playerHit(_ node: SKNode) {
    if node.name == "bonus" {
      score += 1
      node.removeFromParent()
      return
    }
    if let particles = SKEmitterNode(fileNamed: "Explosion") {
      particles.position = player.position
      particles.zPosition = 3
      addChild(particles)
    }

    player.removeFromParent()
    music.removeFromParent()
    let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    run(sound)
    let gameOver = SKSpriteNode(imageNamed: "gameOver-3")
    guard let view = view else { return }
    gameOver.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
    gameOver.zPosition = 10
    addChild(gameOver)
    
    // wait for two seconds then run some code
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      // create a new scene from GameScene.sks
      if let scene = GameScene(fileNamed: "GameScene") {
        // make it stretch to fill all available space
        scene.scaleMode = .aspectFill
        
        // present it immediately
        self.view?.presentScene(scene)
      }
    }

  }
}
