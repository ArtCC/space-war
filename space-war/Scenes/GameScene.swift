//
//  GameScene.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

  // MARK: - Properties

  private let player = SKSpriteNode(imageNamed: "img_ship")
  private let joystickBase = SKSpriteNode(imageNamed: "img_base_joystick")
  private let joystick = SKSpriteNode(imageNamed: "img_joystick")

  private var velocityX: CGFloat = 0
  private var velocityY: CGFloat = 0
  private var joystickIsActive = false

  // MARK: - Init

  override init(size: CGSize) {
    super.init(size: size)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle's functions

  override func didMove(to view: SKView) {
    addChild(SetupScenes.getBackground(for: self))

    player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)

    if let physicsBody = player.physicsBody {
      physicsBody.applyImpulse(CGVectorMake(10, 10))
    }

    physicsWorld.gravity = .zero
    physicsBody = SKPhysicsBody(edgeLoopFrom: CGRectMake(CGRectGetMinX(self.frame),
                                                         CGRectGetMinY(self.frame),
                                                         self.frame.size.width,
                                                         self.frame.size.height))

    joystickBase.position = CGPoint(x: joystickBase.size.width / 4 + 50.0, y: joystickBase.size.height / 4)
    joystickBase.zPosition = 1.0
    joystickBase.alpha = 0.2
    joystickBase.setScale(0.3)

    joystick.position = joystickBase.position
    joystick.zPosition = 2.0
    joystick.alpha = 0.2
    joystick.setScale(0.15)

    addChild(player)
    addChild(joystickBase)
    addChild(joystick)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      if (CGRectContainsPoint(joystick.frame, location)) {
        joystickIsActive = true
      } else {
        joystickIsActive = false
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      if joystickIsActive == true {
        let vector = CGVector(dx: location.x - joystickBase.position.x, dy: location.y - joystickBase.position.y)
        let angle = atan2(vector.dy, vector.dx)
        let radio: CGFloat = joystickBase.frame.size.height / 2
        let xDist: CGFloat = sin(angle - 1.57079633) * radio
        let yDist: CGFloat = cos(angle - 1.57079633) * radio

        if (CGRectContainsPoint(joystickBase.frame, location)) {
          joystick.position = location
        } else {
          joystick.position = CGPointMake(joystickBase.position.x - xDist, joystickBase.position.y + yDist)
        }

        player.zRotation = angle

        velocityX = xDist / 49.0
        velocityY = yDist / 49.0
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if joystickIsActive == true {
      let defaultPosition: SKAction = SKAction.move(to: joystickBase.position, duration: 0.05)
      defaultPosition.timingMode = SKActionTimingMode.easeOut

      joystick.run(defaultPosition)

      joystickIsActive = false

      velocityX = 0
      velocityY = 0
    }
  }

  override func update(_ currentTime: TimeInterval) {
    if joystickIsActive == true {
      player.position = CGPointMake(player.position.x - (velocityX * 3), player.position.y + (velocityY * 3))
    }
  }
}
