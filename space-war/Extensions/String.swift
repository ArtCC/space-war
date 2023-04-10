//
//  String.swift
//  space-war
//
//  Created by Arturo Carretero Calvo on 10/4/23.
//  Copyright © 2023 Arturo Carretero Calvo. All rights reserved.
//

import Foundation

extension String {

  func localized() -> String {
    NSLocalizedString(self, comment: "")
  }
}
