//
//  Components.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

struct Components {

  // MARK: - Public

  static func getDefaultBackground(for scene: SKScene) -> SKSpriteNode {
    let background = SKSpriteNode(imageNamed: "img_menu_background")
    background.alpha = 0.4
    background.zPosition = -1
    background.size = scene.frame.size
    background.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
    return background
  }
}
