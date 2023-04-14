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
    // Margin
    static let titleLabelTop: CGFloat = 15
    static let titleLabelLeading: CGFloat = 50
    static let scoreLabelMargin: CGFloat = 35

    // Size
    static let titleFontSize: CGFloat = 60
    static let defaultFontSize: CGFloat = 45
    static let scoreFontSize: CGFloat = 20

    // Animation
    static let duration: CGFloat = 0.25
  }

  // MARK: - Lifecycle's functions

  override func didMove(to view: SKView) {
    createBackground()
    createTitleLabel()
    createPlayLabel()
    createScoreLabel()
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
    let titleLabel = SKLabelNode(fontNamed: Constants.robotoThinFont)
    titleLabel.text = "main.menu.title".localized()
    titleLabel.fontSize = SceneTraits.titleFontSize
    titleLabel.horizontalAlignmentMode = .left
    titleLabel.verticalAlignmentMode = .top
    titleLabel.position = CGPoint(x: SceneTraits.titleLabelLeading,
                                  y: size.height - SceneTraits.titleLabelTop - titleLabel.frame.size.height / 2.0)

    addChild(titleLabel)
  }

  private func createPlayLabel() {
    let playLabel = SKLabelNode(fontNamed: Constants.robotoRegularFont)
    playLabel.text = "main.menu.play.option.title".localized()
    playLabel.fontSize = SceneTraits.defaultFontSize
    playLabel.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
    playLabel.name = MainMenuOption.game.rawValue

    addChild(playLabel)
  }

  private func createScoreLabel() {
    let score = String(ScoreManager.getScore())
    let scoreLabel = SKLabelNode(fontNamed: Constants.robotoRegularFont)
    scoreLabel.text = String(format: "main.menu.score.title".localized(), score)
    scoreLabel.fontSize = SceneTraits.scoreFontSize
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.verticalAlignmentMode = .top
    scoreLabel.position = CGPoint(x: size.width - SceneTraits.scoreLabelMargin,
                                  y: size.height - SceneTraits.scoreLabelMargin)

    addChild(scoreLabel)
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
