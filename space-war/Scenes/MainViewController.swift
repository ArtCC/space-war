//
//  MainViewController.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//

import SpriteKit

class MainViewController: UIViewController {

  // MARK: - Lifecycle's functions

  override func viewDidLoad() {
    super.viewDidLoad()

    createMainScene()
  }

  // MARK: - Setup functions

  override var prefersStatusBarHidden: Bool {
    return true
  }

  // MARK: - Private

  private func createMainScene() {
    let scene = MainMenuScene(size: view.bounds.size)

    let skView = view as! SKView
    skView.ignoresSiblingOrder = true
    skView.showsFPS = false
    skView.showsNodeCount = false
    skView.isMultipleTouchEnabled = true
    skView.presentScene(scene)
  }
}
