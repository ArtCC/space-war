//
//  Enemy.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 14/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {

  // MARK: - Init

  init() {
    super.init(texture: nil, color: .clear, size: CGSize.zero)
  }

  init(texture: SKTexture) {
    super.init(texture: texture, color: .clear, size: texture.size())

    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Public

  func addTurboEngineFire(with texture: String) {
    let animatedAtlas = SKTextureAtlas(named: texture)
    let numImages = animatedAtlas.textureNames.count

    var frames: [SKTexture] = []

    for i in 1...numImages {
      let textureName = String(format: Textures.image, i)
      frames.append(animatedAtlas.textureNamed(textureName))
    }

    let firstFrameTexture = frames[0]
    let turboEnemy = SKSpriteNode(texture: firstFrameTexture)
    turboEnemy.position = CGPoint(x: size.width / 2.0, y: 0.0)

    addChild(turboEnemy)

    turboEnemy.run(SKAction.repeatForever(
      SKAction.animate(with: frames, timePerFrame: 0.1, resize: false, restore: true)),
                   withKey: Textures.enemyTurboEngine)
  }

  func movement() {
    let duration = CGFloat.random(in: 3...6)
    let moveAction = SKAction.moveTo(x: -size.width / 2, duration: duration)
    let removeAction = SKAction.removeFromParent()
    let sequence = SKAction.sequence([moveAction, removeAction])

    run(sequence)
  }

  func fire(with imageNamed: String) {
    shot(with: imageNamed)

    let shotDelay = SKAction.wait(forDuration: 1.5)
    let shotAction = SKAction.run {
      self.shot(with: imageNamed)
    }
    let shotSequence = SKAction.sequence([shotDelay, shotAction])
    let shotForever = SKAction.repeatForever(shotSequence)

    run(shotForever)
  }

  // MARK: - Private

  private func setup() {
    zPosition = 1.0

    physicsBody = SKPhysicsBody(rectangleOf: frame.size)
    physicsBody?.categoryBitMask = PhysicsCategory.enemy
    physicsBody?.contactTestBitMask = PhysicsCategory.player
    physicsBody?.collisionBitMask = PhysicsCategory.none
    physicsBody?.usesPreciseCollisionDetection = true
  }

  private func shot(with imageNamed: String) {
    guard let image = UIImage(named: imageNamed) else {
      return
    }
    let texture = SKTexture(image: image)
    let projectile = SKSpriteNode(texture: texture)
    projectile.position = convert(CGPoint(x: -(size.width / 2.0), y: 0.0), to: self)
    projectile.zPosition = 1.0
    projectile.setScale(1.5)
    projectile.name = GameSceneNodes.enemyProjectile.rawValue
    projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.enemyProjectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    projectile.physicsBody?.usesPreciseCollisionDetection = true

    addChild(projectile)

    let direction = CGVector(dx: -1.0, dy: 0.0)
    let distance: CGFloat = 750.0
    let action = SKAction.move(by: CGVector(dx: direction.dx * distance, dy: direction.dy * distance), duration: 1.0)
    let remove = SKAction.removeFromParent()

    projectile.run(SKAction.sequence([action, remove]))

    run(SKAction.playSoundFileNamed(Music.shot, waitForCompletion: false))
  }
}
