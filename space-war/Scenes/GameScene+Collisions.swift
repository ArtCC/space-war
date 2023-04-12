//
//  GameScene+Collisions.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 12/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

// MARK: - Collisions

extension GameScene {

  func projectileDidCollideWithEnemy(projectile: SKSpriteNode, enemy: SKSpriteNode) {
    if enemy.name == GameSceneNodes.asteroid.rawValue {
      createDefaultExplosion(in: enemy.position)
    } else if enemy.name == GameSceneNodes.enemy.rawValue {
      createEnemyExplosion(in: enemy.position)
    }

    projectile.removeFromParent()
    enemy.removeFromParent()

    enemiesDestroyed += 1

    updateScore()

    if enemiesDestroyed > 100 {
      let reveal = SKTransition.crossFade(withDuration: 0.5)
      let gameOverScene = GameOverScene(size: self.size, won: true)

      view?.presentScene(gameOverScene, transition: reveal)
    }
  }

  func playerDidCollideWithEnemy(player: SKSpriteNode, enemy: SKSpriteNode) {
    createPlayerExplosion(in: player.position) {
      let reveal = SKTransition.crossFade(withDuration: 0.5)
      let gameOverScene = GameOverScene(size: self.size, won: false)

      self.view?.presentScene(gameOverScene, transition: reveal)
    }

    player.removeFromParent()
    enemy.removeFromParent()
  }
}
