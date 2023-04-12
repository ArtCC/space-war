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

  private struct SceneTraits {
    // Duration
    static let wait: CGFloat = 2
    static let animation: CGFloat = 0.3

    // Size
    static let fontSize: CGFloat = 40
  }

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

    createTitleLabel()

    routeToMainMenuScene()
  }

  // MARK: - Private

  private func createTitleLabel() {
    let message = won ? "game.over.won".localized() : "game.over.lose".localized()

    let label = SKLabelNode(fontNamed: Constants.robotoRegularFont)
    label.text = message
    label.fontSize = SceneTraits.fontSize
    label.fontColor = SKColor.white
    label.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)

    addChild(label)
  }

  private func routeToMainMenuScene() {
    run(SKAction.sequence([
      SKAction.wait(forDuration: SceneTraits.wait),
      SKAction.run() { [weak self] in
        guard let self else {
          return
        }
        let reveal = SKTransition.crossFade(withDuration: SceneTraits.animation)
        let scene = MainMenuScene(size: size)

        self.view?.presentScene(scene, transition:reveal)
      }
    ]))
  }
}
