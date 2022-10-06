//
//  UserData.swift
//  Orchard
//
//  Created by John Behnke on 10/5/22.
//

import Foundation

struct UserData: Codable {
  internal init
  (
    trackedProducts: [TrackedProduct],
    timeLastChecked: Date
  ) {
    self.trackedProducts = [TrackedProduct]()
    self.timeLastChecked = timeLastChecked
  }
  
  init() {
    self.trackedProducts = [TrackedProduct]()
    self.timeLastChecked = Date()
  }
  var timeLastChecked: Date
  var trackedProducts: [TrackedProduct]

  
}
