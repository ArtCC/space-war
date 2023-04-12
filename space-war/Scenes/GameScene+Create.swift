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
    let backgroundTexture = SKTexture(imageNamed: "img_background_game")

    for i in 0...1 {
      let background = SKSpriteNode(texture: backgroundTexture)
      background.zPosition = -30
      background.anchorPoint = CGPoint.zero
      background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 0.0)

      addChild(background)

      let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0.0, duration: 10.0)
      let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0.0, duration: 0.0)
      let moveLoop = SKAction.sequence([moveLeft, moveReset])
      let moveForever = SKAction.repeatForever(moveLoop)

      background.run(moveForever)
    }
  }

  // MARK: - Score

  func createScoreLabel() {
    scoreLabel.text = String(format: "main.menu.score.title".localized(), String(enemiesDestroyed))
    scoreLabel.fontSize = scoreFontSize
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.verticalAlignmentMode = .top
    scoreLabel.position = CGPoint(x: size.width - 35.0, y: size.height - 35.0)

    addChild(scoreLabel)
  }

  // MARK: - Music

  func createMusicGame() {
    let music = SKAudioNode(fileNamed: "space-game.wav")
    music.autoplayLooped = true
    music.isPositional = false

    addChild(music)

    music.run(SKAction.play())
  }

  // MARK: - Player

  func createPlayer() {
    player.name = GameSceneNodes.player.rawValue
    player.zPosition = 1.0
    player.position = CGPoint(x: size.width * 0.15, y: size.height * 0.5)
    player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
    player.physicsBody?.isDynamic = true
    player.physicsBody?.categoryBitMask = PhysicsCategory.player
    player.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    player.physicsBody?.collisionBitMask = PhysicsCategory.all
    player.physicsBody?.usesPreciseCollisionDetection = true

    if let physicsBody = player.physicsBody {
      physicsBody.applyImpulse(CGVectorMake(10, 10))
    }

    addChild(player)

    createNormalPlayerShip()
    createTurboPlayerShip()
  }

  func createPlayerShot(in touchLocation: CGPoint) {
    let projectile = SKSpriteNode(imageNamed: "img_shot")
    projectile.name = GameSceneNodes.playerProjectile.rawValue
    projectile.position = CGPoint(x: player.position.x + 55.0, y: player.position.y)
    projectile.zPosition = 1.0
    projectile.setScale(1.5)
    projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
    projectile.physicsBody?.isDynamic = true
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    projectile.physicsBody?.usesPreciseCollisionDetection = true

    addChild(projectile)

    let angle = player.zRotation - CGFloat.pi * 2
    let direction = CGVector(dx: cos(angle), dy: sin(angle))
    let speed: CGFloat = 500.0
    let distance: CGFloat = 750.0
    let move = SKAction.move(by: CGVector(dx: direction.dx * distance, dy: direction.dy * distance),
                             duration: distance / speed)
    let remove = SKAction.removeFromParent()
    let action = SKAction.sequence([move, remove])

    projectile.run(action)

    run(SKAction.playSoundFileNamed("short-laser-gun-shot.wav", waitForCompletion: false))
  }

  func createPlayerControls() {
    joystickBase.name = GameSceneNodes.joystickBase.rawValue
    joystickBase.position = CGPoint(x: joystickBase.size.width / 4 + 50.0, y: joystickBase.size.height / 4)
    joystickBase.zPosition = 1.0
    joystickBase.alpha = 0.2
    joystickBase.setScale(0.3)

    joystick.name = GameSceneNodes.joystick.rawValue
    joystick.position = joystickBase.position
    joystick.zPosition = 2.0
    joystick.alpha = 0.3
    joystick.setScale(0.15)

    firePad.anchorPoint = CGPoint(x: 1.0, y: 0.0)
    firePad.name = GameSceneNodes.firePad.rawValue
    firePad.position = CGPoint(x: size.width - 75.0, y: size.height / 8)
    firePad.zPosition = 1.0
    firePad.alpha = 0.3
    firePad.setScale(0.25)

    addChild(joystickBase)
    addChild(joystick)
    addChild(firePad)
  }

  func createNormalPlayerShip() {
    let animatedAtlas = SKTextureAtlas(named: "PlayerNormal")
    let numImages = animatedAtlas.textureNames.count

    var frames: [SKTexture] = []

    for i in 1...numImages {
      let textureName = "normal_\(i)"
      frames.append(animatedAtlas.textureNamed(textureName))
    }
    normalPlayerFrames = frames

    let firstFrameTexture = normalPlayerFrames[0]
    normalPlayer = SKSpriteNode(texture: firstFrameTexture)
    normalPlayer.position = CGPoint(x: -player.size.width / 2.0, y: 0.0)

    player.addChild(normalPlayer)

    normalPlayer.run(SKAction.repeatForever(
      SKAction.animate(with: normalPlayerFrames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: true)),
                     withKey: "normalPlayer")

    normalPlayer.isHidden = false
  }

  func createTurboPlayerShip() {
    let animatedAtlas = SKTextureAtlas(named: "PlayerTurbo")
    let numImages = animatedAtlas.textureNames.count

    var frames: [SKTexture] = []

    for i in 1...numImages {
      let textureName = "turbo_\(i)"
      frames.append(animatedAtlas.textureNamed(textureName))
    }
    turboPlayerFrames = frames

    let firstFrameTexture = turboPlayerFrames[0]
    turboPlayer = SKSpriteNode(texture: firstFrameTexture)
    turboPlayer.position = CGPoint(x: -player.size.width / 2.0, y: 0.0)

    player.addChild(turboPlayer)

    turboPlayer.run(SKAction.repeatForever(
      SKAction.animate(with: turboPlayerFrames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: true)),
                    withKey: "playerTurbo")

    turboPlayer.isHidden = true
  }

  func createPlayerExplosion(in position: CGPoint, completion: @escaping() -> Void) {
    let animatedAtlas = SKTextureAtlas(named: "PlayerExplosion")
    let numImages = animatedAtlas.textureNames.count

    var explosion = SKSpriteNode()
    var frames: [SKTexture] = []

    for i in 1...numImages {
      let textureName = "Ship6_Explosion_\(i)"
      frames.append(animatedAtlas.textureNamed(textureName))
    }

    let firstFrameTexture = frames[0]
    explosion = SKSpriteNode(texture: firstFrameTexture)
    explosion.position = position

    addChild(explosion)

    run(SKAction.playSoundFileNamed("player-explosion.wav", waitForCompletion: false))

    explosion.run(SKAction.animate(with: frames,
                                   timePerFrame: 0.1,
                                   resize: false,
                                   restore: true)) {
      explosion.removeFromParent()

      completion()
    }
  }

  // MARK: - Enemies

  func createEnemy() {
    let enemy = SKSpriteNode(imageNamed: "img_enemy")
    enemy.name = GameSceneNodes.enemy.rawValue

    let actualY = random(min: enemy.size.height / 2, max: size.height - enemy.size.height / 2)

    enemy.position = CGPoint(x: size.width + enemy.frame.width, y: actualY)
    enemy.zPosition = 1.0
    enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.frame.size)
    enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
    enemy.physicsBody?.contactTestBitMask = PhysicsCategory.player
    enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
    enemy.physicsBody?.usesPreciseCollisionDetection = true

    createTurboEnemyShip(for: enemy)

    addChild(enemy)

    let actualDuration = random(min: CGFloat(1.0), max: CGFloat(3.5))
    let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width / 2, y: actualY),
                                   duration: TimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()

    enemy.run(SKAction.sequence([actionMove, actionMoveDone]))

    createEnemyShot(for: enemy)

    let shotDelay = SKAction.wait(forDuration: 1.0)
    let shotAction = SKAction.run {
      self.createEnemyShot(for: enemy)
    }
    let shotSequence = SKAction.sequence([shotDelay, shotAction])
    let shotForever = SKAction.repeatForever(shotSequence)

    enemy.run(shotForever)
  }

  func createEnemyShot(for enemy: SKSpriteNode) {
    let projectile = SKSpriteNode(imageNamed: "img_enemy_shot")
    projectile.position = CGPoint(x: enemy.position.x - 55.0, y: enemy.position.y)
    projectile.zPosition = 1.0
    projectile.setScale(1.5)
    projectile.name = GameSceneNodes.enemyProjectile.rawValue
    projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.enemyProjectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    projectile.physicsBody?.usesPreciseCollisionDetection = true

    addChild(projectile)

    let direction = CGVector(dx: -1.0, dy: 0.0)
    let speed: CGFloat = 500.0
    let distance: CGFloat = 750.0
    let action = SKAction.move(by: CGVector(dx: direction.dx * distance, dy: direction.dy * distance),
                               duration: distance / speed)
    let remove = SKAction.removeFromParent()

    projectile.run(SKAction.sequence([action, remove]))

    run(SKAction.playSoundFileNamed("short-laser-gun-shot.wav", waitForCompletion: false))
  }

  func createTurboEnemyShip(for enemy: SKSpriteNode) {
    let animatedAtlas = SKTextureAtlas(named: "EnemyTurbo")
    let numImages = animatedAtlas.textureNames.count

    var frames: [SKTexture] = []

    for i in 1...numImages {
      let textureName = "turbo_\(i)"
      frames.append(animatedAtlas.textureNamed(textureName))
    }

    let firstFrameTexture = frames[0]
    let turboEnemy = SKSpriteNode(texture: firstFrameTexture)
    turboEnemy.position = CGPoint(x: (enemy.size.width / 2.0) - 10.0, y: 0.0)

    enemy.addChild(turboEnemy)

    turboEnemy.run(SKAction.repeatForever(
      SKAction.animate(with: frames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: true)),
                   withKey: "enemyTurbo")
  }

  func createEnemyExplosion(in position: CGPoint) {
    let animatedAtlas = SKTextureAtlas(named: "EnemyExplosion")
    let numImages = animatedAtlas.textureNames.count

    var explosion = SKSpriteNode()
    var frames: [SKTexture] = []

    for i in 1...numImages {
      let textureName = "Ship2_Explosion_\(i)"
      frames.append(animatedAtlas.textureNamed(textureName))
    }

    let firstFrameTexture = frames[0]
    explosion = SKSpriteNode(texture: firstFrameTexture)
    explosion.position = position

    addChild(explosion)

    run(SKAction.playSoundFileNamed("enemy-explosion.wav", waitForCompletion: false))

    explosion.run(SKAction.animate(with: frames,
                                   timePerFrame: 0.1,
                                   resize: false,
                                   restore: true)) {
      explosion.removeFromParent()
    }
  }

  func createAsteroid() {
    let asteroid = SKSpriteNode(imageNamed: "img_asteroids")
    asteroid.name = GameSceneNodes.asteroid.rawValue
    asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
    asteroid.physicsBody?.isDynamic = true
    asteroid.physicsBody?.categoryBitMask = PhysicsCategory.enemy
    asteroid.physicsBody?.collisionBitMask = PhysicsCategory.none
    asteroid.physicsBody?.usesPreciseCollisionDetection = true

    let actualY = random(min: asteroid.size.height / 2, max: size.height - asteroid.size.height / 2)

    asteroid.position = CGPoint(x: size.width + asteroid.size.width / 2, y: actualY)

    addChild(asteroid)

    let rotateAction = SKAction.rotate(byAngle: CGFloat.pi, duration: 2.0)
    let repeatRotateAction = SKAction.repeatForever(rotateAction)
    asteroid.run(repeatRotateAction)

    let actualDuration = random(min: CGFloat(1.0), max: CGFloat(2.5))
    let actionMove = SKAction.move(to: CGPoint(x: -asteroid.size.width / 2, y: actualY),
                                   duration: TimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()

    asteroid.run(SKAction.sequence([actionMove, actionMoveDone]))
  }

  func createDefaultExplosion(in position: CGPoint) {
    let animatedAtlas = SKTextureAtlas(named: "Explosion")
    let numImages = animatedAtlas.textureNames.count

    var explosion = SKSpriteNode()
    var frames: [SKTexture] = []

    for i in 1...numImages {
      let textureName = "Explosion1_\(i)"
      frames.append(animatedAtlas.textureNamed(textureName))
    }

    let firstFrameTexture = frames[0]
    explosion = SKSpriteNode(texture: firstFrameTexture)
    explosion.position = position

    addChild(explosion)

    run(SKAction.playSoundFileNamed("enemy-explosion.wav", waitForCompletion: false))

    explosion.run(SKAction.animate(with: frames,
                                   timePerFrame: 0.1,
                                   resize: false,
                                   restore: true)) {
      explosion.removeFromParent()
    }
  }
}
