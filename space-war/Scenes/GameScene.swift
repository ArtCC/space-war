//
//  GameScene.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

enum GameSceneNodes: String {
  case asteroid
  case boss
  case enemy
  case enemyProjectile
  case firePad
  case joystick
  case joystickBase
  case player
  case playerProjectile
}

struct PhysicsCategory {
  static let all: UInt32 = UInt32.max
  static let none: UInt32 = 0
  static let enemy: UInt32 = 0b1
  static let projectile: UInt32 = 0b10
  static let player: UInt32 = 0b11
  static let enemyProjectile: UInt32 = 0b100
}

class GameScene: SKScene {

  // MARK: - Properties

  struct SceneTraits {
    // Size
    static let scoreFontSize: CGFloat = 26

    // Score
    static let scoreForBoss: Int = 0
  }

  var scoreLabel = SKLabelNode(fontNamed: Fonts.robotoRegularFont)
  var player = Player()
  var playerVelocityX: CGFloat = 0
  var playerVelocityY: CGFloat = 0
  var selectedNodes: [UITouch: SKSpriteNode] = [:]
  var joystickIsActive = false
  var enemiesDestroyed = 0 {
    didSet {
      ScoreManager.saveScore(enemiesDestroyed)

      scoreLabel.text = String(format: "main.menu.score.title".localized(), String(enemiesDestroyed))

      enemiesDestroyed > SceneTraits.scoreForBoss ? createFinalBoss() : nil

      bossIsActive = enemiesDestroyed > SceneTraits.scoreForBoss
    }
  }
  var bossIsActive = false {
    didSet {
      removeAction(forKey: Keys.addAsteroidActionKey)
      removeAction(forKey: Keys.addEnemyActionKey)
    }
  }

  let joystickBase = SKSpriteNode(imageNamed: Images.joystickBase)
  let joystick = SKSpriteNode(imageNamed: Images.joystick)
  let firePad = SKSpriteNode(imageNamed: Images.joystick)

  // MARK: - Init

  override init(size: CGSize) {
    super.init(size: size)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle's functions

  override func didMove(to view: SKView) {
    setupPhysics()

    createParallaxBackground()
    createScoreLabel()
    createMusicGame()
    createPlayer()
    createPlayerControls()

    addAsteroids()
    addEnemies()
  }

  override func update(_ currentTime: TimeInterval) {
    if joystickIsActive == true {
      player.position = CGPointMake(player.position.x - (playerVelocityX * 3),
                                    player.position.y + (playerVelocityY * 3))
    }

    player.normalEngineFireIsHidden(joystickIsActive)
    player.turboEngineFireIsHidden(!joystickIsActive)
  }

  // MARK: - Public

  func endGame(isWin: Bool) {
    let reveal = SKTransition.crossFade(withDuration: 0.5)
    let gameOverScene = GameOverScene(size: self.size, win: isWin)

    view?.presentScene(gameOverScene, transition: reveal)
  }

  // MARK: - Private

  private func setupPhysics() {
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self

    physicsBody = SKPhysicsBody(edgeLoopFrom: CGRectMake(CGRectGetMinX(frame),
                                                         CGRectGetMinY(frame),
                                                         frame.size.width,
                                                         frame.size.height))
  }

  private func addAsteroids() {
    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run(createAsteroid),
        SKAction.wait(forDuration: 5.0)
      ])
    ), withKey: Keys.addAsteroidActionKey)
  }

  private func addEnemies() {
    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run(createEnemy),
        SKAction.wait(forDuration: 2.5)
      ])
    ), withKey: Keys.addEnemyActionKey)
  }
}
