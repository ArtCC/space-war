//
//  GameScene+Create.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 12/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

// MARK: - Create functions

extension GameScene {
    // MARK: - Background

    func createParallaxBackground() {
        let texture = SKTexture(imageNamed: Images.gameBackground)

        for i in 0...3 {
            let position = CGPoint(x: (texture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 0.0)
            let background = Background(texture: texture, size: texture.size(), position: position, alpha: 1.0)
            background.anchorPoint = CGPoint.zero

            addChild(background)

            background.movement()
        }
    }

    // MARK: - Score

    func createScoreLabel() {
        scoreLabel.zPosition = 6.0
        scoreLabel.text = String(format: "main.menu.score.title".localized(), String(enemiesDestroyed))
        scoreLabel.fontSize = SceneTraits.scoreFontSize
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: size.width - 35.0, y: size.height - 35.0)

        addChild(scoreLabel)
    }

    // MARK: - Player

    func createPlayer() {
        guard let image = UIImage(named: Images.player) else {
            return
        }
        let texture = SKTexture(image: image)
        let position = CGPoint(x: size.width * 0.15, y: size.height * 0.5)

        player = Player(texture: texture, size: texture.size(), position: position)
        player.name = Nodes.player.rawValue

        addChild(player)

        player.normalEngineFireIsHidden(false)
        player.turboEngineFireIsHidden(true)
    }

    func createPlayerControls() {
        joystickBase.name = Nodes.joystickBase.rawValue
        joystickBase.position = CGPoint(x: joystickBase.size.width / 4 + 50.0, y: joystickBase.size.height / 4)
        joystickBase.zPosition = 5.0
        joystickBase.alpha = 0.2
        joystickBase.setScale(0.3)

        joystick.name = Nodes.joystick.rawValue
        joystick.position = joystickBase.position
        joystick.zPosition = 6.0
        joystick.alpha = 0.5
        joystick.setScale(0.20)

        firePad.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        firePad.name = Nodes.firePad.rawValue
        firePad.position = CGPoint(x: size.width - 75.0, y: size.height / 8)
        firePad.zPosition = 6.0
        firePad.alpha = 0.5
        firePad.setScale(0.20)

        joystickBase.isHidden = true
        joystick.isHidden = true
        firePad.isHidden = true

        addChild(joystickBase)
        addChild(joystick)
        addChild(firePad)
    }

    // MARK: - Enemies

    func createAsteroid() {
        guard let image = UIImage(named: Images.asteroids) else {
            return
        }
        let texture = SKTexture(image: image)
        let actualY = CGFloat.random(in: texture.size().height / 2...size.height - texture.size().height / 2)
        let position = CGPoint(x: size.width + texture.size().width / 2, y: actualY)
        let asteroid = Asteroid(texture: texture, position: position)
        asteroid.name = Nodes.asteroid.rawValue

        addChild(asteroid)
    }

    func createEnemy() {
        guard let image = UIImage(named: Images.enemy) else {
            return
        }
        let texture = SKTexture(image: image)
        let enemy = Enemy(texture: texture)
        let randomY = CGFloat.random(in: enemy.size.height / 2...size.height - enemy.size.height / 2)

        enemy.name = Nodes.enemy.rawValue
        enemy.position = CGPoint(x: size.width + (enemy.size.width * 2), y: randomY)

        enemy.addTurboEngineFire(with: Textures.enemyTurboEngine)
        enemy.movement()

        let shotDelay = SKAction.wait(forDuration: 1.5)
        let shotAction = SKAction.run {
            guard let image = UIImage(named: Images.enemyShot) else {
                return
            }
            let texture = SKTexture(image: image)
            let projectile = Shot(texture: texture, position: CGPoint(x: -50.0, y: 0.0), type: .rightToLeft)
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.enemyProjectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none

            projectile.movement()

            enemy.addChild(projectile)
        }
        let shotSequence = SKAction.sequence([shotDelay, shotAction])
        let shotForever = SKAction.repeatForever(shotSequence)

        run(shotForever)

        addChild(enemy)
    }

    func createFinalBoss() {
        if !bossIsActive {
            guard let image = UIImage(named: Images.boss) else {
                return
            }
            let texture = SKTexture(image: image)
            let enemy = Boss(texture: texture)
            let randomY = CGFloat.random(in: enemy.size.height / 2...size.height - enemy.size.height / 2)

            enemy.name = Nodes.boss.rawValue
            enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: randomY)
            enemy.setScale(1.5)

            enemy.addTurboEngineFire(with: Textures.bossTurboEngine)
            enemy.movement()

            let shotDelay = SKAction.wait(forDuration: 1.0)
            let shotAction = SKAction.run {
                guard let image = UIImage(named: Images.bossShot) else {
                    return
                }
                let texture = SKTexture(image: image)
                let projectile = Shot(texture: texture,
                                      position: CGPoint(x: enemy.frame.origin.x - 20.0, y: enemy.position.y),
                                      type: .rightToLeft)
                projectile.physicsBody?.categoryBitMask = PhysicsCategory.enemyProjectile
                projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player
                projectile.physicsBody?.collisionBitMask = PhysicsCategory.none

                projectile.movement()

                self.addChild(projectile)
            }
            let shotSequence = SKAction.sequence([shotDelay, shotAction])
            let shotForever = SKAction.repeatForever(shotSequence)

            run(shotForever)

            addChild(enemy)
        }
    }

    // MARK: - Shots

    @objc
    func playerShot() {
        guard let image = UIImage(named: Images.playerShot) else {
            return
        }
        let texture = SKTexture(image: image)
        let projectile = Shot(texture: texture,
                              position: CGPoint(x: player.frame.maxX + 20.0, y: player.position.y),
                              type: .leftToRight)
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none

        projectile.movement()

        addChild(projectile)
    }

    // MARK: - Music

    func createMusicGame() {
        let music = SKAudioNode(fileNamed: Music.game)
        music.autoplayLooped = true
        music.isPositional = false

        addChild(music)

        music.run(SKAction.play())
    }
}
