//
//  GameScene.swift
//  SubmarineGame
//
//  Created by Jenneke Choe on 18/06/2018.
//  Copyright © 2018 Jenneke Choe. All rights reserved.
//
import GameplayKit
import SpriteKit

class GameScene: SKScene {
  // sprites
  private let playerSprite = SKSpriteNode(imageNamed: "player-submarine")
  private var bonusSprite: SKSpriteNode!
  
  // other assets
  let music = SKAudioNode(fileNamed: "cyborg-ninja")
  
  //variables
  var touchingPlayer = false
  var gameTimer: Timer?
  let scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
  var score = 0 {
    didSet { updateUI() }
  }
  var lives = 0 {
    didSet { updateUI() }
  }
  
  func updateUI() {
    scoreLabel.text = "SCORE: \(score)"
    // livelabel.text = lives
  }
  
  // MARK: Did move
  override func didMove(to view: SKView) {
    setupGameData()
    
    createBackground()
    createPlayer()
    
    createParticles()
    createMusic()
    
    createScoreUI()
  }
  
  // ----------------------------------------
  // MARK: Init
  // ----------------------------------------
  private func setupGameData() {
    score = 0
  }
  
  private func createBackground() {
    guard let view = view else { return }
    let background = SKSpriteNode(imageNamed: "water-bg")
    let xPos = view.frame.width / 2
    let yPos = view.frame.height / 2
    background.position = CGPoint(x: xPos, y: yPos)
    background.zPosition = -1
    addChild(background)
  }
  
  private func createMusic() {
    addChild(music)
  }
  
  private func createParticles() {
    if let particles = SKEmitterNode(fileNamed: "Bubbles") {
      particles.advanceSimulationTime(10)
      particles.position.x = 612
      addChild(particles)
    }
    gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    
    physicsWorld.contactDelegate = self
  }
  
  private func createPlayer() {
    playerSprite.position = CGPoint(x: 100, y: 200)
    playerSprite.zPosition = 1
    playerSprite.physicsBody = SKPhysicsBody(texture: playerSprite.texture!, size: playerSprite.size)
    playerSprite.physicsBody?.affectedByGravity = false
    playerSprite.physicsBody?.categoryBitMask = 1
    addChild(playerSprite)
  }
  
  private func createScoreUI() {
    scoreLabel.zPosition = 2
    scoreLabel.position = CGPoint(x: 100, y: 320)
    addChild(scoreLabel)
  }
  
  // ----------------------------------------
  // MARK: Creation
  // ----------------------------------------
  @objc private func handleTimer() {
    createEnemy()
    createBonus()
  }
  
  private func createEnemy() {
    let sprite = SKSpriteNode(imageNamed: "fish")
    setupSprite(sprite: sprite, name: "enemy")
    
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody?.affectedByGravity = false
    sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
    sprite.physicsBody?.linearDamping = 0
    sprite.physicsBody?.contactTestBitMask = 1
    sprite.physicsBody?.categoryBitMask = 0
  }
  
  private func createBonus() {
    bonusSprite = SKSpriteNode(imageNamed: "coin")
    setupSprite(sprite: bonusSprite, name: "bonus")
    
    bonusSprite.physicsBody = SKPhysicsBody(texture: bonusSprite.texture!, size: bonusSprite.size)
    bonusSprite.physicsBody?.affectedByGravity = false
    bonusSprite.physicsBody?.velocity = CGVector(dx: -300, dy: 0)
    bonusSprite.physicsBody?.linearDamping = 0
    bonusSprite.physicsBody?.contactTestBitMask = 1
    bonusSprite.physicsBody?.categoryBitMask = 0
    bonusSprite.physicsBody?.collisionBitMask = 0
  }
  
  private func setupSprite(sprite: SKSpriteNode, name: String) {
    let randomDistribution = GKRandomDistribution(lowestValue: -350, highestValue: 350)
    sprite.position = CGPoint(x: 700, y: randomDistribution.nextInt())
    sprite.name = name
    sprite.zPosition = 1
    addChild(sprite)
  }
  
  // ----------------------------------------
  // MARK: Touch
  // ----------------------------------------
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    if tappedNodes.contains(playerSprite) {
      touchingPlayer = true
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touchingPlayer else { return }
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    playerSprite.position = location
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // this method is called when the user stops touching the screen
    touchingPlayer = false
  }
  
  // ----------------------------------------
  // MARK: Update
  // ----------------------------------------
  override func update(_ currentTime: TimeInterval) {
    // this method is called before each frame is rendered
//     guard let view = view else { return }
    
    if playerSprite.position.x < -600 {
      playerSprite.position.x = -600
    } else if playerSprite.position.x > 600  {
      playerSprite.position.x = 600
    }
    
    if playerSprite.position.y < -375 {
      playerSprite.position.y = -375
    } else if playerSprite.position.y > 375 {
      playerSprite.position.y = 375
    }
    
    for node in children {
      if node.position.x < -700 {
        node.removeFromParent()
      }
    }
  }
  
}

// ----------------------------------------
// MARK: Collision
// ----------------------------------------
extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }
    
    if nodeA == playerSprite {
      playerHit(nodeB)
    } else {
      playerHit(nodeA)
    }
  }
  
  private func playerHit(_ node: SKNode) {
    if node.name == "bonus" {
      score += 1
      node.removeFromParent()
      return
    }
    if let particles = SKEmitterNode(fileNamed: "Explosion") {
      particles.position = playerSprite.position
      particles.zPosition = 3
      addChild(particles)
    }
    
    playerSprite.removeFromParent()
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
