//
//  GameOverScene.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 11/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

  // MARK: - Properties

  private var won = false

  // MARK: - Init
  
  init(size: CGSize, won: Bool) {
    super.init(size: size)

    self.won = won
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle's functions

  override func didMove(to view: SKView) {
    addChild(Components.getDefaultBackground(for: self))

    let message = won ? "You Won!" : "You Lose :["

    let label = SKLabelNode(fontNamed: Constants.robotoRegularFont)
    label.text = message
    label.fontSize = 40
    label.fontColor = SKColor.white
    label.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)

    addChild(label)

    run(SKAction.sequence([
      SKAction.wait(forDuration: 3.0),
      SKAction.run() { [weak self] in
        guard let self else {
          return
        }
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = MainMenuScene(size: size)

        self.view?.presentScene(scene, transition:reveal)
      }
    ]))
  }
}
