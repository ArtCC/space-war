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
    let texture = SKTexture(imageNamed: "img_background_game")

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
    player.name = GameSceneNodes.player.rawValue
    player.zPosition = 3.0
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
    projectile.zPosition = 3.0
    projectile.setScale(2.0)
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
    firePad.zPosition = 2.0
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

  // MARK: - Enemies

  func createEnemy() {
    let enemy = SKSpriteNode(imageNamed: "img_enemy")
    enemy.name = GameSceneNodes.enemy.rawValue

    let randomY = CGFloat.random(in: enemy.size.height / 2...size.height - enemy.size.height / 2)

    enemy.position = CGPoint(x: size.width + enemy.frame.width, y: randomY)
    enemy.zPosition = 3.0
    enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.frame.size)
    enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
    enemy.physicsBody?.contactTestBitMask = PhysicsCategory.player
    enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
    enemy.physicsBody?.usesPreciseCollisionDetection = true

    createTurboEnemyShip(for: enemy)

    addChild(enemy)

    let actualDuration = CGFloat.random(in: 1...5)
    let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width / 2, y: randomY),
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
    projectile.zPosition = 3.0
    projectile.setScale(1.5)
    projectile.name = GameSceneNodes.enemyProjectile.rawValue
    projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.enemyProjectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    projectile.physicsBody?.usesPreciseCollisionDetection = true

    addChild(projectile)

    let direction = CGVector(dx: -1.0, dy: 0.0)
    let distance: CGFloat = 750.0
    let action = SKAction.move(by: CGVector(dx: direction.dx * distance, dy: direction.dy * distance),
                               duration: 1.0)
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

  func createAsteroid() {
    guard let image = UIImage(named: "img_asteroids") else {
      return
    }
    let texture = SKTexture(image: image)
    let actualY = CGFloat.random(in: texture.size().height / 2...size.height - texture.size().height / 2)
    let position = CGPoint(x: size.width + texture.size().width / 2, y: actualY)
    let asteroid = Asteroid(texture: texture, position: position)
    asteroid.name = GameSceneNodes.asteroid.rawValue

    addChild(asteroid)
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

  // MARK: - Music

  func createMusicGame() {
    let music = SKAudioNode(fileNamed: "space-game.wav")
    music.autoplayLooped = true
    music.isPositional = false

    addChild(music)

    music.run(SKAction.play())
  }
}
