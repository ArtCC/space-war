//
//  GameScene+Delegates.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 12/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

// MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {

  func didBegin(_ contact: SKPhysicsContact) {
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody

    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }

    if (firstBody.categoryBitMask == PhysicsCategory.enemy && PhysicsCategory.enemy != 0) &&
        (secondBody.categoryBitMask == PhysicsCategory.projectile && PhysicsCategory.projectile != 0) {
      if let enemy = firstBody.node as? SKSpriteNode,
         let projectile = secondBody.node as? SKSpriteNode {
        projectileDidCollideWithEnemy(projectile: projectile, enemy: enemy)
      }
    } else if (firstBody.categoryBitMask == PhysicsCategory.enemy && PhysicsCategory.enemy != 0) &&
                (secondBody.categoryBitMask == PhysicsCategory.player && PhysicsCategory.player != 0) {
      if let enemy = firstBody.node as? SKSpriteNode,
         let player = secondBody.node as? SKSpriteNode {
        playerDidCollideWithEnemy(player: player, enemy: enemy)
      }
    }
  }
}
