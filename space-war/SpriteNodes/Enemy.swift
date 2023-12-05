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
        turboEnemy.position = CGPoint(x: (size.width / 2.0) + 5.0, y: 0.0)

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

    // MARK: - Private

    private func setup() {
        zPosition = 1.0

        physicsBody = SKPhysicsBody(rectangleOf: frame.size)
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        physicsBody?.contactTestBitMask = PhysicsCategory.player
        physicsBody?.collisionBitMask = PhysicsCategory.none
        physicsBody?.usesPreciseCollisionDetection = true
    }
}
