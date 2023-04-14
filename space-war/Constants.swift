//
//  Constants.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 12/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import Foundation

struct Fonts {
  static let robotoRegularFont = "Roboto-Regular"
  static let robotoThinFont = "Roboto-Thin"
}

struct Images {
  static let asteroids = "img_asteroids"
  static let boss = "img_boss"
  static let bossShot = "img_boss_shot"
  static let enemy = "img_enemy"
  static let enemyShot = "img_enemy_shot"
  static let gameBackground = "img_background_game"
  static let joystick = "img_joystick"
  static let joystickBase = "img_base_joystick"
  static let menuBackground = "img_menu_background"
  static let player = "img_ship"
  static let playerShot = "img_shot"
}

struct Keys {
  static let addAsteroidActionKey = "add.asteroid.action.key"
  static let addEnemyActionKey = "add.enemy.action.key"
  static let scoreKey = "score.key"
}

struct Music {
  static let enemyExplosion = "enemy-explosion.wav"
  static let game = "space-game.wav"
  static let menu = "menu.wav"
  static let playerExplosion = "player-explosion.wav"
  static let shot = "short-laser-gun-shot.wav"
  static let startGame = "start-level.wav"
}

struct Textures {
  static let bossExplosion = "BossExplosion"
  static let bossTurboEngine = "BossTurbo"
  static let enemyTurboEngine = "EnemyTurbo"
  static let explosion = "Explosion"
  static let enemyExplosion = "EnemyExplosion"
  static let image = "texture_%d"
  static let playerExplosion = "PlayerExplosion"
  static let playerNormalEngine = "PlayerNormal"
  static let playerTurboEngine = "PlayerTurbo"
}
