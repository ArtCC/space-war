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
    let explosion = Explosion(size: enemy.size)

    switch enemy.name {
    case GameSceneNodes.asteroid.rawValue:
      explosion.explosion(texture: "Explosion", music: "enemy-explosion.wav", in: enemy.position)
    case GameSceneNodes.enemy.rawValue:
      explosion.explosion(texture: "EnemyExplosion", music: "enemy-explosion.wav", in: enemy.position)
    default:
      break
    }

    addChild(explosion)

    projectile.removeFromParent()
    enemy.removeFromParent()

    enemiesDestroyed += 1

    if enemiesDestroyed > SceneTraits.scoreForBoss {
      bossIsActive = true

#warning("Aquí sacamos al jefe final.")

      endGame(isWin: true)
    }
  }

  func playerDidCollideWithEnemy(_ player: SKSpriteNode, _ enemy: SKSpriteNode) {
    let enemyExplosion = Explosion(size: enemy.size)
    enemyExplosion.explosion(texture: "EnemyExplosion", music: "enemy-explosion.wav", in: enemy.position)

    let playerExplosion = Explosion(size: player.size)
    playerExplosion.explosion(texture: "PlayerExplosion", music: "player-explosion.wav", in: player.position) {
      self.endGame(isWin: false)
    }

    addChild(enemyExplosion)
    addChild(playerExplosion)
    
    player.removeFromParent()
    enemy.removeFromParent()
  }

  func enemyProjectileDidCollideWithEnemy(_ enemyProjectile: SKSpriteNode, _ player: SKSpriteNode) {
    let explosion = Explosion(size: enemyProjectile.size)
    explosion.explosion(texture: "PlayerExplosion", music: "player-explosion.wav", in: enemyProjectile.position) {
      self.endGame(isWin: false)
    }

    addChild(explosion)

    enemyProjectile.removeFromParent()
    player.removeFromParent()
  }
}
