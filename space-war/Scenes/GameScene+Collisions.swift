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
        enemiesDestroyed += 1

        let explosion = Explosion(size: enemy.size)

        switch enemy.name {
        case Nodes.asteroid.rawValue:
            explosion.explosion(texture: Textures.explosion, music: Music.enemyExplosion, in: enemy.position)
        case Nodes.boss.rawValue:
            explosion.explosion(texture: Textures.bossExplosion, music: Music.enemyExplosion, in: enemy.position) {
                self.endGame(isWin: true)
            }
        case Nodes.enemy.rawValue:
            explosion.explosion(texture: Textures.enemyExplosion, music: Music.enemyExplosion, in: enemy.position)
        default:
            break
        }

        addChild(explosion)

        projectile.removeFromParent()
        enemy.removeFromParent()
    }

    func playerDidCollideWithEnemy(_ player: SKSpriteNode, _ enemy: SKSpriteNode) {
        let enemyExplosion = Explosion(size: enemy.size)

        switch enemy.name {
        case Nodes.boss.rawValue:
            enemyExplosion.explosion(texture: Textures.bossExplosion, music: Music.enemyExplosion, in: enemy.position)
        case Nodes.enemy.rawValue:
            enemyExplosion.explosion(texture: Textures.enemyExplosion, music: Music.enemyExplosion, in: enemy.position)
        default:
            break
        }

        let playerExplosion = Explosion(size: player.size)
        playerExplosion.explosion(texture: Textures.playerExplosion, music: Music.playerExplosion, in: player.position) {
            self.endGame(isWin: false)
        }

        addChild(enemyExplosion)
        addChild(playerExplosion)

        player.removeFromParent()
        enemy.removeFromParent()
    }

    func enemyProjectileDidCollideWithPlayer(_ enemyProjectile: SKSpriteNode, _ player: SKSpriteNode) {
        let explosion = Explosion(size: enemyProjectile.size)
        explosion.explosion(texture: Textures.playerExplosion, music: Music.playerExplosion, in: player.position) {
            self.endGame(isWin: false)
        }

        addChild(explosion)

        enemyProjectile.removeFromParent()
        player.removeFromParent()
    }
}
