//
//  Explosion.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 14/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class Explosion: SKSpriteNode {
    // MARK: - Init

    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Public
    
    func explosion(texture: String, music: String, in position: CGPoint, completion: (() -> Void)? = nil) {
        zPosition = 1.0

        let animatedAtlas = SKTextureAtlas(named: texture)
        let numImages = animatedAtlas.textureNames.count

        var explosion = SKSpriteNode()
        var frames: [SKTexture] = []

        for i in 1...numImages {
            let textureName = String(format: Textures.image, i)
            frames.append(animatedAtlas.textureNamed(textureName))
        }

        let firstFrameTexture = frames[0]
        explosion = SKSpriteNode(texture: firstFrameTexture)
        explosion.position = position

        run(SKAction.playSoundFileNamed(music, waitForCompletion: false))

        addChild(explosion)

        explosion.run(SKAction.animate(with: frames, timePerFrame: 0.1, resize: false, restore: true)) {
            explosion.removeFromParent()

            completion?()
        }
    }
}
