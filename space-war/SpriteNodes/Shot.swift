//
//  Shot.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 14/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

enum MovementType {
  case rightToLeft
  case leftToRight
}

class Shot: SKSpriteNode {

  // MARK: - Properties

  private var type: MovementType = .leftToRight

  // MARK: - Init

  init(texture: SKTexture, position: CGPoint, type: MovementType) {
    super.init(texture: texture, color: .clear, size: texture.size())

    setup(texture, position, type)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Public

  func movement() {
    let direction = CGVector(dx: type == .leftToRight ? 1.0 : -1.0, dy: 0.0)
    let distance: CGFloat = 750.0
    let action = SKAction.move(by: CGVector(dx: direction.dx * distance, dy: direction.dy * distance), duration: 1.0)
    let remove = SKAction.removeFromParent()

    run(SKAction.sequence([action, remove]))
  }

  // MARK: - Private

  private func setup(_ texture: SKTexture, _ position: CGPoint, _ type: MovementType) {
    self.position = position
    self.texture = texture
    self.type = type

    zPosition = 1.0

    setScale(2.0)

    physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    physicsBody?.isDynamic = true
    physicsBody?.usesPreciseCollisionDetection = true

    run(SKAction.playSoundFileNamed(Music.shot, waitForCompletion: false))
  }
}
