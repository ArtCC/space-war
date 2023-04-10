//
//  ScoreScene.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class ScoreScene: SKScene {

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
  }
}
