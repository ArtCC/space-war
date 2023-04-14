//
//  Asteroid.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 14/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode {

  // MARK: - Init

  init(texture: SKTexture, position: CGPoint) {
    super.init(texture: texture, color: .clear, size: texture.size())

    setup(with: position)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Private

  private func setup(with position: CGPoint) {
    zPosition = 3.0

    physicsBody = SKPhysicsBody(rectangleOf: size)
    physicsBody?.isDynamic = true
    physicsBody?.categoryBitMask = PhysicsCategory.enemy
    physicsBody?.collisionBitMask = PhysicsCategory.none
    physicsBody?.usesPreciseCollisionDetection = true

    self.position = position

    rotate()
  }

  private func rotate() {
    let rotateAction = SKAction.rotate(byAngle: CGFloat.pi, duration: 2.0)
    let repeatRotateAction = SKAction.repeatForever(rotateAction)
    run(repeatRotateAction)

    let actualDuration = CGFloat.random(in: CGFloat(1.0)...CGFloat(2.5))
    let actionMove = SKAction.move(to: CGPoint(x: -size.width / 2, y: position.y),
                                   duration: TimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()

    run(SKAction.sequence([actionMove, actionMoveDone]))
  }
}
