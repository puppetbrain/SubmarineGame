//
//  GameOverScene.swift
//  SubmarineGame
//
//  Created by Jenneke Choe on 21/06/2018.
//  Copyright © 2018 Jenneke Choe. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameOverScene: SKScene {
  
  var label: SKLabelNode!
  
  override func didMove(to view: SKView) {
    label = SKLabelNode()
    label.fontSize = 40
    label.text = "Game over"
    addChild(label)
  }
}
