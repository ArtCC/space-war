//
//  Boss.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 14/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class Boss: SKSpriteNode {

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
    zPosition = 1.0

    self.position = position
  }
}
