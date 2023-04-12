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

  var enemy = SKSpriteNode(imageNamed: "img_enemy")
  var scoreLabel = SKLabelNode(fontNamed: Constants.robotoRegularFont)
  var normalPlayer = SKSpriteNode()
  var normalPlayerFrames: [SKTexture] = []
  var turboPlayer = SKSpriteNode()
  var turboPlayerFrames: [SKTexture] = []
  var selectedNodes: [UITouch: SKSpriteNode] = [:]
  var velocityX: CGFloat = 0
  var velocityY: CGFloat = 0
  var joystickIsActive = false
  var enemiesDestroyed = 0

  let player = SKSpriteNode(imageNamed: "img_ship")
  let joystickBase = SKSpriteNode(imageNamed: "img_base_joystick")
  let joystick = SKSpriteNode(imageNamed: "img_joystick")
  let firePad = SKSpriteNode(imageNamed: "img_joystick")
  let scoreFontSize: CGFloat = 20

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

    setupPhysics()

    addAsteroidToScene()
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

  // MARK: - Public

  func updateScore() {
    ScoreManager.saveScore(enemiesDestroyed)

    scoreLabel.text = String(format: "main.menu.score.title".localized(), String(enemiesDestroyed))
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

  private func addAsteroidToScene() {
    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run(createAsteroid),
        SKAction.wait(forDuration: 3.0)
      ])
    ))
  }
}
