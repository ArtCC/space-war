//
//  GameScene+Create.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 12/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

// MARK: - Create functions

extension GameScene {

  // MARK: - Background

  func createParallaxBackground() {
    let texture = SKTexture(imageNamed: Images.gameBackground)

    for i in 0...1 {
      let position = CGPoint(x: (texture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 0.0)
      let background = Background(texture: texture, size: texture.size(), position: position, alpha: 1.0)
      background.anchorPoint = CGPoint.zero

      addChild(background)

      background.movement()
    }
  }

  // MARK: - Score

  func createScoreLabel() {
    scoreLabel.text = String(format: "main.menu.score.title".localized(), String(enemiesDestroyed))
    scoreLabel.fontSize = SceneTraits.scoreFontSize
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.verticalAlignmentMode = .top
    scoreLabel.position = CGPoint(x: size.width - 35.0, y: size.height - 35.0)

    addChild(scoreLabel)
  }

  // MARK: - Player

  func createPlayer() {
    guard let image = UIImage(named: Images.player) else {
      return
    }
    let texture = SKTexture(image: image)
    let position = CGPoint(x: size.width * 0.15, y: size.height * 0.5)
    
    player = Player(texture: texture, size: texture.size(), position: position)
    player.name = GameSceneNodes.player.rawValue

    addChild(player)

    player.normalEngineFireIsHidden(false)
    player.turboEngineFireIsHidden(true)
  }

  func createPlayerControls() {
    joystickBase.name = GameSceneNodes.joystickBase.rawValue
    joystickBase.position = CGPoint(x: joystickBase.size.width / 4 + 50.0, y: joystickBase.size.height / 4)
    joystickBase.zPosition = 5.0
    joystickBase.alpha = 0.2
    joystickBase.setScale(0.3)

    joystick.name = GameSceneNodes.joystick.rawValue
    joystick.position = joystickBase.position
    joystick.zPosition = 6.0
    joystick.alpha = 0.3
    joystick.setScale(0.15)

    firePad.anchorPoint = CGPoint(x: 1.0, y: 0.0)
    firePad.name = GameSceneNodes.firePad.rawValue
    firePad.position = CGPoint(x: size.width - 75.0, y: size.height / 8)
    firePad.zPosition = 6.0
    firePad.alpha = 0.3
    firePad.setScale(0.25)

    addChild(joystickBase)
    addChild(joystick)
    addChild(firePad)
  }

  // MARK: - Enemies

  func createAsteroid() {
    guard let image = UIImage(named: Images.asteroids) else {
      return
    }
    let texture = SKTexture(image: image)
    let actualY = CGFloat.random(in: texture.size().height / 2...size.height - texture.size().height / 2)
    let position = CGPoint(x: size.width + texture.size().width / 2, y: actualY)
    let asteroid = Asteroid(texture: texture, position: position)
    asteroid.name = GameSceneNodes.asteroid.rawValue

    addChild(asteroid)
  }
  
  func createEnemy() {
    guard let image = UIImage(named: Images.enemy) else {
      return
    }
    let texture = SKTexture(image: image)
    let enemy = Enemy(texture: texture)
    let randomY = CGFloat.random(in: enemy.size.height / 2...size.height - enemy.size.height / 2)

    enemy.name = GameSceneNodes.enemy.rawValue
    enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: randomY)

    enemy.fire()

    addChild(enemy)
  }

  // MARK: - Music

  func createMusicGame() {
    let music = SKAudioNode(fileNamed: Music.game)
    music.autoplayLooped = true
    music.isPositional = false

    addChild(music)

    music.run(SKAction.play())
  }
}
