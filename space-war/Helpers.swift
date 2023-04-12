//
//  Helpers.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 12/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import Foundation

// MARK: - Helper functions

func random() -> CGFloat {
  return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
  return random() * (max - min) + min
}
