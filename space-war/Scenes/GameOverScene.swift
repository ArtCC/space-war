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

  private var win = false

  // MARK: - Init
  
  init(size: CGSize, win: Bool) {
    super.init(size: size)

    self.win = win
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle's functions

  override func didMove(to view: SKView) {
    createBackground()
    createTitleLabel()

    routeToMainMenuScene()
  }

  // MARK: - Private
  
  private func createBackground() {
    guard let image = UIImage(named: "img_menu_background"),
          let scene else {
      return
    }
    let texture = SKTexture(image: image)
    let background = Background(texture: texture,
                                size: scene.frame.size,
                                position: CGPoint(x: scene.frame.midX, y: scene.frame.midY),
                                alpha: 0.4)

    addChild(background)
  }

  private func createTitleLabel() {
    let text = win ? "game.over.win".localized() : "game.over.lose".localized()
    let label = SKLabelNode(fontNamed: Constants.robotoRegularFont)
    label.text = text
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
