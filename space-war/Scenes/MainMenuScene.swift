//
//  MainMenuScene.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import AVFoundation
import SpriteKit

enum MainMenuOption: String {
  case game
  case scores
}

class MainMenuScene: SKScene {

  // MARK: - Properties

  private struct SceneTraits {
    // Font
    static let titleFontSize: CGFloat = 40
    static let defaultFontSize: CGFloat = 30

    // Animation
    static let duration: CGFloat = 0.5
  }

  // MARK: - Lifecycle's functions

  override func didMove(to view: SKView) {
    let titleLabel = SKLabelNode(fontNamed: Constants.robotoRegularFont)
    titleLabel.text = "main.menu.title".localized()
    titleLabel.fontSize = SceneTraits.titleFontSize
    titleLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 75)

    let playLabel = SKLabelNode(fontNamed: Constants.robotoThinFont)
    playLabel.text = "main.menu.play.option.title".localized()
    playLabel.fontSize = SceneTraits.defaultFontSize
    playLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
    playLabel.name = MainMenuOption.game.rawValue

    let scoresLabel = SKLabelNode(fontNamed: Constants.robotoThinFont)
    scoresLabel.text = "main.menu.scores.option.title".localized()
    scoresLabel.fontSize = SceneTraits.defaultFontSize
    scoresLabel.position = CGPoint(x: size.width / 2, y: playLabel.frame.minY - 50)
    scoresLabel.name = MainMenuOption.scores.rawValue

    addChild(SetupScenes.getBackground(for: self))
    addChild(titleLabel)
    addChild(playLabel)
    addChild(scoresLabel)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      let node = self.atPoint(location)

      if node.name == MainMenuOption.game.rawValue {
        routeToGameScene()
      } else if node.name == MainMenuOption.scores.rawValue {
        routeToScoresScene()
      }
    }
  }

  // MARK: - Private

  func routeToGameScene() {
    let reveal = SKTransition.crossFade(withDuration: SceneTraits.duration)
    let gameScene = GameScene(size: self.size)

    self.view?.presentScene(gameScene, transition: reveal)
  }

  func routeToScoresScene() {
    let reveal = SKTransition.crossFade(withDuration: SceneTraits.duration)
    let scoreScene = ScoreScene(size: self.size)

    self.view?.presentScene(scoreScene, transition: reveal)
  }
}
