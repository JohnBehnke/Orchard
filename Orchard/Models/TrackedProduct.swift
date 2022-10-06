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
    identifier: String
  ) {
    self.name = name
    self.identifier = identifier
  }

  init() {
    self.name = ""
    self.identifier = ""
  }

  var id: UUID = UUID()
  var name: String
  var identifier: String
}
