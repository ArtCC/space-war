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

  func projectileDidCollideWithEnemy(_ projectile: SKSpriteNode, _ enemy: SKSpriteNode) {
    switch enemy.name {
    case GameSceneNodes.asteroid.rawValue:
      createDefaultExplosion(in: enemy.position)
    case GameSceneNodes.enemy.rawValue:
      createEnemyExplosion(in: enemy.position)
    default:
      break
    }

    projectile.removeFromParent()
    enemy.removeFromParent()

    enemiesDestroyed += 1

    if enemiesDestroyed > SceneTraits.scoreForBoss {
      bossIsActive = true

#warning("Aquí sacamos al jefe final.")
    }
  }

  func playerDidCollideWithEnemy(_ player: SKSpriteNode, _ enemy: SKSpriteNode) {
    createPlayerExplosion(in: player.position) {
      let reveal = SKTransition.crossFade(withDuration: 0.5)
      let gameOverScene = GameOverScene(size: self.size, won: false)

      self.view?.presentScene(gameOverScene, transition: reveal)
    }

    player.removeFromParent()
    enemy.removeFromParent()
  }

  func enemyProjectileDidCollideWithEnemy(_ enemyProjectile: SKSpriteNode, _ player: SKSpriteNode) {
    createPlayerExplosion(in: enemyProjectile.position) {
      let reveal = SKTransition.crossFade(withDuration: 0.5)
      let gameOverScene = GameOverScene(size: self.size, won: false)

      self.view?.presentScene(gameOverScene, transition: reveal)
    }

    enemyProjectile.removeFromParent()
    player.removeFromParent()
  }
}
