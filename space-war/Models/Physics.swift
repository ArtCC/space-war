//
//  Physics.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 14/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import Foundation

struct PhysicsCategory {
  static let all: UInt32 = UInt32.max
  static let none: UInt32 = 0
  static let enemy: UInt32 = 0b1
  static let projectile: UInt32 = 0b10
  static let player: UInt32 = 0b11
  static let enemyProjectile: UInt32 = 0b100
}
