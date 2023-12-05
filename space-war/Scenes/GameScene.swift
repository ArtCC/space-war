//
//  GameScene.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import GameController
import SpriteKit

class GameScene: SKScene {
    // MARK: - Properties

    struct SceneTraits {
        // Size
        static let scoreFontSize: CGFloat = 26

        // Score
        static let scoreForBoss: Int = 15
    }

    var scoreLabel = SKLabelNode(fontNamed: Fonts.robotoRegularFont)
    var player = Player()
    var playerVelocityX: CGFloat = 0
    var playerVelocityY: CGFloat = 0
    var selectedNodes: [UITouch: SKSpriteNode] = [:]
    var joystickIsActive = false
    var enemiesDestroyed = 0 {
        didSet {
            ScoreManager.saveScore(enemiesDestroyed)

            scoreLabel.text = String(format: "main.menu.score.title".localized(), String(enemiesDestroyed))

            if enemiesDestroyed > SceneTraits.scoreForBoss {
                createFinalBoss()

                bossIsActive = true
            }
        }
    }
    var bossIsActive = false {
        didSet {
            removeAction(forKey: Keys.addAsteroidActionKey)
            removeAction(forKey: Keys.addEnemyActionKey)
        }
    }
    var gameControllerConnected = false
    var gamepadDirection = CGPoint.zero
    var fireTimer: Timer?
    var isButtonAPressed = false

    let joystickBase = SKSpriteNode(imageNamed: Images.joystickBase)
    let joystick = SKSpriteNode(imageNamed: Images.joystick)
    let firePad = SKSpriteNode(imageNamed: Images.joystick)

    // MARK: - Init

    override init(size: CGSize) {
        super.init(size: size)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle's functions

    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controllerDidConnect),
                                               name: .GCControllerDidConnect,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controllerDidDisconnect),
                                               name: .GCControllerDidDisconnect,
                                               object: nil)

        setupPhysics()

        createParallaxBackground()
        createScoreLabel()
        createMusicGame()
        createPlayer()
        createPlayerControls()

        addAsteroids()
        addEnemies()
    }

    override func update(_ currentTime: TimeInterval) {
        if gameControllerConnected {
            movePlayerWithGamepad()

            joystickBase.isHidden = true
            joystick.isHidden = true
            firePad.isHidden = true
        } else {
            joystickBase.isHidden = false
            joystick.isHidden = false
            firePad.isHidden = false

            if joystickIsActive == true {
                player.position = CGPointMake(player.position.x - (playerVelocityX * 3),
                                              player.position.y + (playerVelocityY * 3))
            }

            player.normalEngineFireIsHidden(joystickIsActive)
            player.turboEngineFireIsHidden(!joystickIsActive)
        }
    }

    // MARK: - Game controllers

    @objc func controllerDidConnect(notification: Notification) {
        gameControllerConnected = true

        guard let controller = notification.object as? GCController,
              let gamepad = controller.extendedGamepad else {
            return
        }

        gamepad.valueChangedHandler = { [weak self] (gamepad, element) in
            self?.updateControls(gamepad: gamepad)
        }
    }

    @objc func controllerDidDisconnect(notification: Notification) {
        gameControllerConnected = false
        gamepadDirection = CGPoint.zero
    }

    func updateControls(gamepad: GCExtendedGamepad) {
        let x = CGFloat(gamepad.leftThumbstick.xAxis.value)
        let y = CGFloat(gamepad.leftThumbstick.yAxis.value)

        gamepadDirection = CGPoint(x: x, y: y)

        player.normalEngineFireIsHidden(x != 0 || y != 0)
        player.turboEngineFireIsHidden(x == 0 || y == 0)

        if gamepad.buttonA.isPressed && !isButtonAPressed {
            isButtonAPressed = true
            startFiring()
        } else if !gamepad.buttonA.isPressed && isButtonAPressed {
            isButtonAPressed = false
            stopFiring()
        }
    }

    func movePlayerWithGamepad() {
        let newX = player.position.x + gamepadDirection.x * 3
        let newY = player.position.y + gamepadDirection.y * 3

        player.position = CGPoint(x: newX, y: newY)
    }

    func startFiring() {
        fireTimer?.invalidate()
        playerShot()
        fireTimer = Timer.scheduledTimer(timeInterval: 3.0,
                                         target: self,
                                         selector: #selector(playerShot),
                                         userInfo: nil,
                                         repeats: true)
    }

    func stopFiring() {
        fireTimer?.invalidate()
        fireTimer = nil
    }

    // MARK: - Public

    func endGame(isWin: Bool) {
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, win: isWin)

        view?.presentScene(gameOverScene, transition: reveal)
    }

    // MARK: - Private

    private func setupPhysics() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRectMake(CGRectGetMinX(frame),
                                                             CGRectGetMinY(frame),
                                                             frame.size.width,
                                                             frame.size.height))
    }

    private func addAsteroids() {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(createAsteroid),
                SKAction.wait(forDuration: 5.0)
            ])
        ), withKey: Keys.addAsteroidActionKey)
    }

    private func addEnemies() {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(createEnemy),
                SKAction.wait(forDuration: 2.5)
            ])
        ), withKey: Keys.addEnemyActionKey)
    }
}
