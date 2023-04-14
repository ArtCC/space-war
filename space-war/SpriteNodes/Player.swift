//
//  Player.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 14/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {

  // MARK: - Init

  init(texture: SKTexture, size: CGSize, position: CGPoint, alpha: CGFloat) {
    super.init(texture: texture, color: .clear, size: size)

    setup(with: position, and: alpha)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Private

  private func setup(with position: CGPoint, and alpha: CGFloat) {
    zPosition = 1.0

    self.position = position
    self.alpha = alpha
  }
}
