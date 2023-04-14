//
//  GameScene+UITouch.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 12/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

// MARK: - UITouch

extension GameScene {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let touchLocation = touch.location(in: self)

      if let node = atPoint(touchLocation) as? SKSpriteNode {
        if node.name == Nodes.joystick.rawValue {
          if (CGRectContainsPoint(joystick.frame, touchLocation)) {
            joystickIsActive = true
          } else {
            joystickIsActive = false
          }
          selectedNodes[touch] = node
        } else if node.name == Nodes.firePad.rawValue {
          playerShot()
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

          playerVelocityX = xDist / 49.0
          playerVelocityY = yDist / 49.0
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

          playerVelocityX = 0
          playerVelocityY = 0
        }

        selectedNodes[touch] = nil
      }
    }
  }
}
