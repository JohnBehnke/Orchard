//
//  Product.swift
//  Orchard (macOS)
//
//  Created by John Behnke on 3/11/22.
//

import Foundation

struct TrackedProduct: Identifiable, Hashable, Codable {
  internal init
  (
    name: String,
    identifier: String,
    shouldSendNotification: Bool,
    timeLastChecked: Date
  ) {
    self.name = name
    self.identifier = identifier
    self.shouldSendNotification = shouldSendNotification
    self.timeLastChecked = timeLastChecked
  }

  init() {
    self.name = ""
    self.identifier = ""
    self.shouldSendNotification = false
    self.timeLastChecked = Date()
  }

  var id: UUID = UUID()
  var name: String
  var identifier: String
  var shouldSendNotification: Bool
  var timeLastChecked: Date

}
