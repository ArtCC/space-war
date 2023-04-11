//
//  MainMenuScene.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

enum MainMenuOption: String {
  case game
}

class MainMenuScene: SKScene {

  // MARK: - Properties

  private struct SceneTraits {
    // Font
    static let titleFontSize: CGFloat = 40
    static let defaultFontSize: CGFloat = 30

    // Animation
    static let duration: CGFloat = 0.25
  }

  // MARK: - Lifecycle's functions

  override func didMove(to view: SKView) {
    addChild(Components.getDefaultBackground(for: self))

    createTitleLabel()
    createPlayLabel()
    createMenuMusic()
  }

  // MARK: - UITouch

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      let node = self.atPoint(location)

      if node.name == MainMenuOption.game.rawValue {
        routeToGameScene()
      }
    }
  }

  // MARK: - Private

  private func createTitleLabel() {
    let titleLabel = SKLabelNode(fontNamed: Constants.robotoRegularFont)
    titleLabel.text = "main.menu.title".localized()
    titleLabel.fontSize = SceneTraits.titleFontSize
    titleLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 75)

    addChild(titleLabel)
  }

  private func createPlayLabel() {
    let playLabel = SKLabelNode(fontNamed: Constants.robotoThinFont)
    playLabel.text = "main.menu.play.option.title".localized()
    playLabel.fontSize = SceneTraits.defaultFontSize
    playLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
    playLabel.name = MainMenuOption.game.rawValue

    addChild(playLabel)
  }

  private func createMenuMusic() {
    let music = SKAudioNode(fileNamed: "menu.wav")
    music.autoplayLooped = true
    music.isPositional = false

    addChild(music)

    music.run(SKAction.play())
  }

  private func routeToGameScene() {
    run(SKAction.playSoundFileNamed("start-level.wav", waitForCompletion: false))

    let reveal = SKTransition.crossFade(withDuration: SceneTraits.duration)
    let gameScene = GameScene(size: self.size)

    view?.presentScene(gameScene, transition: reveal)
  }
}
