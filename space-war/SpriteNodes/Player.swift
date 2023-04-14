//
//  Player.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 14/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {

  // MARK: - Properties

  private var normalEngineNode = SKSpriteNode()
  private var normalEngineFrames: [SKTexture] = []
  private var turboEngineNode = SKSpriteNode()
  private var turboEngineFrames: [SKTexture] = []

  // MARK: - Init

  init() {
    super.init(texture: nil, color: .clear, size: CGSize.zero)
  }

  init(texture: SKTexture, size: CGSize, position: CGPoint) {
    super.init(texture: texture, color: .clear, size: size)

    setup(with: position)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Public

  func normalEngineFireIsHidden(_ isHidden: Bool) {
    normalEngineNode.isHidden = isHidden
  }

  func turboEngineFireIsHidden(_ isHidden: Bool) {
    turboEngineNode.isHidden = isHidden
  }

  func shot() {
    guard let image = UIImage(named: "img_shot") else {
      return
    }
    let texture = SKTexture(image: image)
    let projectile = SKSpriteNode(texture: texture)
    projectile.name = GameSceneNodes.playerProjectile.rawValue
    projectile.position = convert(CGPoint(x: 55.0, y: 0.0), to: self)
    projectile.zPosition = 1.0
    projectile.setScale(2.0)
    projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
    projectile.physicsBody?.isDynamic = true
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    projectile.physicsBody?.usesPreciseCollisionDetection = true

    addChild(projectile)

    let angle = zRotation - CGFloat.pi * 2
    let direction = CGVector(dx: cos(angle), dy: sin(angle))
    let speed: CGFloat = 500.0
    let distance: CGFloat = 750.0
    let move = SKAction.move(by: CGVector(dx: direction.dx * distance, dy: direction.dy * distance),
                             duration: distance / speed)
    let remove = SKAction.removeFromParent()
    let action = SKAction.sequence([move, remove])

    projectile.run(action)

    run(SKAction.playSoundFileNamed("short-laser-gun-shot.wav", waitForCompletion: false))
  }

  // MARK: - Private

  private func setup(with position: CGPoint) {
    zPosition = 1.0

    self.position = position

    physicsBody = SKPhysicsBody(rectangleOf: size)
    physicsBody?.isDynamic = true
    physicsBody?.categoryBitMask = PhysicsCategory.player
    physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    physicsBody?.collisionBitMask = PhysicsCategory.all
    physicsBody?.usesPreciseCollisionDetection = true

    if let physicsBody {
      physicsBody.applyImpulse(CGVectorMake(10, 10))
    }

    addNormalEngineFire()
    addTurboEngineFire()
  }

  private func addNormalEngineFire() {
    let animatedAtlas = SKTextureAtlas(named: "PlayerNormal")
    let numImages = animatedAtlas.textureNames.count

    var frames: [SKTexture] = []

    for i in 1...numImages {
      let textureName = "texture_\(i)"
      frames.append(animatedAtlas.textureNamed(textureName))
    }
    normalEngineFrames = frames

    let firstFrameTexture = normalEngineFrames[0]
    normalEngineNode = SKSpriteNode(texture: firstFrameTexture)
    normalEngineNode.position = CGPoint(x: -size.width / 2.0, y: 0.0)

    addChild(normalEngineNode)

    normalEngineNode.run(SKAction.repeatForever(
      SKAction.animate(with: normalEngineFrames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: true)),
                         withKey: "normalPlayer")

    normalEngineNode.isHidden = true
  }

  private func addTurboEngineFire() {
    let animatedAtlas = SKTextureAtlas(named: "PlayerTurbo")
    let numImages = animatedAtlas.textureNames.count

    var frames: [SKTexture] = []

    for i in 1...numImages {
      let textureName = "texture_\(i)"
      frames.append(animatedAtlas.textureNamed(textureName))
    }
    turboEngineFrames = frames

    let firstFrameTexture = turboEngineFrames[0]
    turboEngineNode = SKSpriteNode(texture: firstFrameTexture)
    turboEngineNode.position = CGPoint(x: -size.width / 2.0, y: 0.0)

    addChild(turboEngineNode)

    turboEngineNode.run(SKAction.repeatForever(
      SKAction.animate(with: turboEngineFrames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: true)),
                        withKey: "playerTurbo")

    turboEngineNode.isHidden = true
  }
}
