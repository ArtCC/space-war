//
//  ScoreManager.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 11/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import Foundation

struct ScoreManager {

  // MARK: - Properties

  private static let defaults = UserDefaults.standard

  // MARK: - Public

  static func getScore() -> Int {
    defaults.integer(forKey: Keys.scoreKey)
  }

  static func saveScore(_ score: Int) {
    score > getScore() ? defaults.setValue(score, forKey: Keys.scoreKey) : nil
  }
}
