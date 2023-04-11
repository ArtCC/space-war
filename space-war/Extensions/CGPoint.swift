//
//  CGPoint.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 11/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import Foundation

extension CGPoint {

  func lerp(_ destination: CGPoint, t: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + (destination.x - self.x) * t, y: self.y + (destination.y - self.y) * t)
  }

  func normalized() -> CGPoint {
    let length = sqrt(x * x + y * y)
    if length != 0 {
      return CGPoint(x: x / length, y: y / length)
    }
    return CGPoint.zero
  }
}
