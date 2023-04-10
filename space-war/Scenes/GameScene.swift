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
}

class GameScene: SKScene {

  // MARK: - Properties

  private let player = SKSpriteNode(imageNamed: "img_ship")
  private let joystickBase = SKSpriteNode(imageNamed: "img_base_joystick")
  private let joystick = SKSpriteNode(imageNamed: "img_joystick")
  private let firePad = SKSpriteNode(imageNamed: "img_joystick")

  private var turbo = SKSpriteNode()
  private var selectedNodes: [UITouch: SKSpriteNode] = [:]
  private var velocityX: CGFloat = 0
  private var velocityY: CGFloat = 0
  private var joystickIsActive = false
  private var turboFrames: [SKTexture] = []

  // MARK: - Init

  override init(size: CGSize) {
    super.init(size: size)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle's functions

  override func didMove(to view: SKView) {
    createBackground()

    player.name = GameSceneNodes.player.rawValue
    player.zPosition = 1.0
    player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)

    if let physicsBody = player.physicsBody {
      physicsBody.applyImpulse(CGVectorMake(10, 10))
    }

    physicsWorld.gravity = .zero
    
    physicsBody = SKPhysicsBody(edgeLoopFrom: CGRectMake(CGRectGetMinX(frame),
                                                         CGRectGetMinY(frame),
                                                         frame.size.width,
                                                         frame.size.height))

    joystickBase.name = GameSceneNodes.joystickBase.rawValue
    joystickBase.position = CGPoint(x: joystickBase.size.width / 4 + 50.0, y: joystickBase.size.height / 4)
    joystickBase.zPosition = 1.0
    joystickBase.alpha = 0.2
    joystickBase.setScale(0.3)

    joystick.name = GameSceneNodes.joystick.rawValue
    joystick.position = joystickBase.position
    joystick.zPosition = 2.0
    joystick.alpha = 0.2
    joystick.setScale(0.15)

    firePad.anchorPoint = CGPoint(x: 1.0, y: 0.0)
    firePad.name = GameSceneNodes.firePad.rawValue
    firePad.position = CGPoint(x: size.width - 75.0, y: size.height / 8)
    firePad.zPosition = 2.0
    firePad.alpha = 0.2
    firePad.setScale(0.25)

    buildShipTurbo()

    addChild(player)
    addChild(joystickBase)
    addChild(joystick)
    addChild(firePad)
  }

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
          shoot(in: touchLocation)
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

  override func update(_ currentTime: TimeInterval) {
    if joystickIsActive == true {
      player.position = CGPointMake(player.position.x - (velocityX * 3), player.position.y + (velocityY * 3))
    }
  }
}

// MARK: - Private

private extension GameScene {

  func createBackground() {
    let backgroundTexture = SKTexture(imageNamed: "img_green_nebula")

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

  func buildShipTurbo() {
    let animatedAtlas = SKTextureAtlas(named: "Turbo")
    let numImages = animatedAtlas.textureNames.count

    var frames: [SKTexture] = []

    for i in 1...numImages {
      let textureName = "turbo_\(i)"
      frames.append(animatedAtlas.textureNamed(textureName))
    }
    turboFrames = frames

    let firstFrameTexture = turboFrames[0]
    turbo = SKSpriteNode(texture: firstFrameTexture)
    turbo.position = CGPoint(x: -50.0, y: 0.0)

    player.addChild(turbo)

    turbo.run(SKAction.repeatForever(
      SKAction.animate(with: turboFrames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: true)),
              withKey: "turbo")
  }

  func shoot(in touchLocation: CGPoint) {
    let playerFire = SKSpriteNode(imageNamed: "img_shot")
    playerFire.position = CGPoint(x: player.position.x + 45.0, y: player.position.y)
    playerFire.zPosition = 3
    playerFire.setScale(1.5)

    addChild(playerFire)

    let angle = player.zRotation - CGFloat.pi * 2
    let direction = CGVector(dx: cos(angle), dy: sin(angle))
    let bulletSpeed: CGFloat = 500.0
    let bulletDistance: CGFloat = 1000.0
    let bulletMove = SKAction.move(by: CGVector(dx: direction.dx * bulletDistance,
                                                dy: direction.dy * bulletDistance),
                                   duration: bulletDistance / bulletSpeed)
    let bulletRemove = SKAction.removeFromParent()
    let bulletAction = SKAction.sequence([bulletMove, bulletRemove])

    playerFire.run(bulletAction)
  }
}
