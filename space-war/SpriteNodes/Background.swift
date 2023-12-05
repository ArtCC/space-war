//
//  Background.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 14/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    // MARK: - Init

    init(texture: SKTexture, size: CGSize, position: CGPoint, alpha: CGFloat) {
        super.init(texture: texture, color: .clear, size: size)

        setup(with: position, and: alpha)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Public
    
    func movement() {
        guard let texture else {
            return
        }
        let moveLeft = SKAction.moveBy(x: -texture.size().width, y: 0.0, duration: 10.0)
        let moveReset = SKAction.moveBy(x: texture.size().width, y: 0.0, duration: 0.0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        run(moveForever)
    }

    // MARK: - Private

    private func setup(with position: CGPoint, and alpha: CGFloat) {
        self.zPosition = -1
        self.position = position
        self.alpha = alpha
    }
}
