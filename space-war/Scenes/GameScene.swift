//
//  GameScene.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

enum GameSceneNodes: String {
  case firePad
  case joystick
  case joystickBase
  case player
  case playerProjectile
  case asteroid
  case enemy
  case enemyProjectile
}

struct PhysicsCategory {
  static let none: UInt32 = 0
  static let all: UInt32 = UInt32.max
  static let enemy: UInt32 = 0b1
  static let projectile: UInt32 = 0b10
  static let player: UInt32 = 0b11
  static let enemyProjectile: UInt32 = 0b100
}

class GameScene: SKScene {

  // MARK: - Properties

  private struct SceneTraits {
    // Size
    static let scoreFontSize: CGFloat = 20
  }

  private let player = SKSpriteNode(imageNamed: "img_ship")
  private let joystickBase = SKSpriteNode(imageNamed: "img_base_joystick")
  private let joystick = SKSpriteNode(imageNamed: "img_joystick")
  private let firePad = SKSpriteNode(imageNamed: "img_joystick")

  private var enemy = SKSpriteNode(imageNamed: "img_enemy")
  private var scoreLabel = SKLabelNode(fontNamed: Constants.robotoRegularFont)
  private var normalPlayer = SKSpriteNode()
  private var normalPlayerFrames: [SKTexture] = []
  private var turboPlayer = SKSpriteNode()
  private var turboPlayerFrames: [SKTexture] = []
  private var selectedNodes: [UITouch: SKSpriteNode] = [:]
  private var velocityX: CGFloat = 0
  private var velocityY: CGFloat = 0
  private var joystickIsActive = false
  private var enemiesDestroyed = 0

  // MARK: - Init

  override init(size: CGSize) {
    super.init(size: size)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle's functions

  override func didMove(to view: SKView) {
    createParallaxBackground()
    createScoreLabel()
    createMenuMusic()
    createPlayer()
    createPlayerControls()

    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self

    physicsBody = SKPhysicsBody(edgeLoopFrom: CGRectMake(CGRectGetMinX(frame),
                                                         CGRectGetMinY(frame),
                                                         frame.size.width,
                                                         frame.size.height))

    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run(addAsteroids),
        SKAction.wait(forDuration: 5.0)
      ])
    ))
  }

  override func update(_ currentTime: TimeInterval) {
    if joystickIsActive == true {
      player.position = CGPointMake(player.position.x - (velocityX * 3), player.position.y + (velocityY * 3))

      normalPlayer.isHidden = true
      turboPlayer.isHidden = false
    } else {
      normalPlayer.isHidden = false
      turboPlayer.isHidden = true
    }
  }
}

// MARK: - UITouch

extension GameScene {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let touchLocation = touch.location(in: self)

      if let node = atPoint(touchLocation) as? SKSpriteNode {
        if node.name == GameSceneNodes.joystick.rawValue {
          if (CGRectContainsPoint(joystick.frame, touchLocation)) {
            joystickIsActive = true
          } else {
            joystickIsActive = false
          }
          selectedNodes[touch] = node
        } else if node.name == GameSceneNodes.firePad.rawValue {
          playerShot(in: touchLocation)
        }
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let touchLocation = touch.location(in: self)

      if let node = selectedNodes[touch] {
        if joystickIsActive == true {
          let vector = CGVector(dx: touchLocation.x - joystickBase.position.x,
                                dy: touchLocation.y - joystickBase.position.y)
          let angle = atan2(vector.dy, vector.dx)
          let radio: CGFloat = joystickBase.frame.size.height / 2
          let xDist: CGFloat = sin(angle - 1.57079633) * radio
          let yDist: CGFloat = cos(angle - 1.57079633) * radio

          if (CGRectContainsPoint(joystickBase.frame, touchLocation)) {
            joystick.position = touchLocation
          } else {
            joystick.position = CGPointMake(joystickBase.position.x - xDist, joystickBase.position.y + yDist)
          }

          velocityX = xDist / 49.0
          velocityY = yDist / 49.0
        }

        node.position = touchLocation
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if selectedNodes[touch] != nil {
        if joystickIsActive == true {
          let defaultPosition: SKAction = SKAction.move(to: joystickBase.position, duration: 0.05)
          defaultPosition.timingMode = SKActionTimingMode.easeOut

          joystick.run(defaultPosition)

          joystickIsActive = false

          velocityX = 0
          velocityY = 0
        }

        selectedNodes[touch] = nil
      }
    }
  }
}

// MARK: - Private

private extension GameScene {

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

  func createScoreLabel() {
    scoreLabel.text = String(format: "main.menu.score.title".localized(), String(enemiesDestroyed))
    scoreLabel.fontSize = SceneTraits.scoreFontSize

    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.verticalAlignmentMode = .top
    scoreLabel.position = CGPoint(x: size.width - 35.0, y: size.height - 35.0)

    addChild(scoreLabel)
  }

  func createMenuMusic() {
    let music = SKAudioNode(fileNamed: "space-game.wav")
    music.autoplayLooped = true
    music.isPositional = false

    addChild(music)

    music.run(SKAction.play())
  }

  func createPlayer() {
    player.name = GameSceneNodes.player.rawValue
    player.zPosition = 1.0
    player.position = CGPoint(x: size.width * 0.15, y: size.height * 0.5)
    player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
    player.physicsBody?.isDynamic = true
    player.physicsBody?.categoryBitMask = PhysicsCategory.player
    player.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    player.physicsBody?.collisionBitMask = PhysicsCategory.enemy
    player.physicsBody?.usesPreciseCollisionDetection = true

    if let physicsBody = player.physicsBody {
      physicsBody.applyImpulse(CGVectorMake(10, 10))
    }

    addChild(player)

    buildNormalPlayerShip()
    buildTurboPlayerShip()
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

  func buildNormalPlayerShip() {
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
    normalPlayer.position = CGPoint(x: -55.0, y: 0.0)

    player.addChild(normalPlayer)

    normalPlayer.run(SKAction.repeatForever(
      SKAction.animate(with: normalPlayerFrames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: true)),
                     withKey: "normalPlayer")

    normalPlayer.isHidden = false
  }

  func buildTurboPlayerShip() {
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
    turboPlayer.position = CGPoint(x: -65.0, y: 0.0)

    player.addChild(turboPlayer)

    turboPlayer.run(SKAction.repeatForever(
      SKAction.animate(with: turboPlayerFrames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: true)),
                    withKey: "playerTurbo")

    turboPlayer.isHidden = true
  }

  func playerShot(in touchLocation: CGPoint) {
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
    let bulletSpeed: CGFloat = 500.0
    let bulletDistance: CGFloat = 1000.0
    let bulletMove = SKAction.move(by: CGVector(dx: direction.dx * bulletDistance,
                                                dy: direction.dy * bulletDistance),
                                   duration: bulletDistance / bulletSpeed)
    let bulletRemove = SKAction.removeFromParent()
    let bulletAction = SKAction.sequence([bulletMove, bulletRemove])

    projectile.run(bulletAction)

    run(SKAction.playSoundFileNamed("short-laser-gun-shot.wav", waitForCompletion: false))
  }

  func addEnemy() {
    enemy = SKSpriteNode(imageNamed: "img_enemy")
    enemy.name = GameSceneNodes.enemy.rawValue
    enemy.position = CGPoint(x: size.width - 75.0, y: size.height / 2)
    enemy.zPosition = 1
    enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
    enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
    enemy.physicsBody?.contactTestBitMask = PhysicsCategory.player
    enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
    enemy.physicsBody?.usesPreciseCollisionDetection = true

    addChild(enemy)
  }

  func addAsteroids() {
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

    let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
    let actionMove = SKAction.move(to: CGPoint(x: -asteroid.size.width / 2,
                                               y: actualY),
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
}

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

// MARK: - Private

private extension GameScene {

  func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
  }

  func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
  }

  func updateScore() {
    ScoreManager.saveScore(enemiesDestroyed)

    scoreLabel.text = String(format: "main.menu.score.title".localized(), String(enemiesDestroyed))
  }
}
