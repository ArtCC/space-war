//
//  Boss.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 14/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import SpriteKit

class Boss: Enemy {
    // MARK: - Override functions

    override func movement() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let startingX = screenWidth + size.width / 2
        let startingY = 0.0 + frame.size.height
        let endingX = screenWidth - 250.0
        let endingY = screenHeight - frame.size.height
        let duration = CGFloat.random(in: 3...6)
        
        position = CGPoint(x: startingX, y: startingY)

        let moveAction = SKAction.moveTo(x: endingX, duration: duration / 2)
        let moveUpAction = SKAction.moveTo(y: endingY, duration: duration / 2)
        let moveDownAction = SKAction.moveTo(y: startingY, duration: duration / 2)
        let sequence = SKAction.sequence([moveAction])

        run(sequence) {
            self.run(SKAction.repeatForever(SKAction.sequence([moveUpAction, moveDownAction])))
        }
    }
}
