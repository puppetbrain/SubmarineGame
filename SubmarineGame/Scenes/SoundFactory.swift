//
//  SoundFactory.swift
//  SubmarineGame
//
//  Created by Jenneke Choe on 21/06/2018.
//  Copyright © 2018 Jenneke Choe. All rights reserved.
//

import SpriteKit

class SoundFactory {
  
  static func finishSound() -> SKAction {
    let action = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    return action
  }
  
  static func bonusSound() -> SKAction {
    let action = SKAction.playSoundFileNamed("coin", waitForCompletion: true)
    return action
  }
  
}
