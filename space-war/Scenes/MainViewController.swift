//
//  MainViewController.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//

import UIKit
import SpriteKit
import GameplayKit

class MainViewController: UIViewController {

  // MARK: - Lifecycle's functions

  override func viewDidLoad() {
    super.viewDidLoad()

    let scene = MainMenuScene(size: view.bounds.size)

    let skView = self.view as! SKView
    skView.presentScene(scene)
    skView.ignoresSiblingOrder = true
    skView.showsFPS = false
    skView.showsNodeCount = false
  }

  // MARK: - Setup functions

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
