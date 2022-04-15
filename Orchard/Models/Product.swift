//
//  Product.swift
//  Orchard (macOS)
//
//  Created by John Behnke on 3/11/22.
//

import Foundation

struct Product: Identifiable, Hashable, Codable {
  internal init
  (
    name: String,
    modelNumber: String,
    purchaseURL: String,
    searchPostalCode: String,
    shouldSendNotification: Bool,
    timeLastChecked: Date
  ) {
    self.name = name
    self.modelNumber = modelNumber
    self.purchaseURL = purchaseURL
    self.searchPostalCode = searchPostalCode
    self.shouldSendNotification = shouldSendNotification
    self.timeLastChecked = timeLastChecked
  }

  init() {
    self.name = "name"
    self.modelNumber = "modelNumber"
    self.purchaseURL = "https://apple.com"
    self.searchPostalCode = "searchPostalCode"
    self.shouldSendNotification = false
    self.timeLastChecked = Date()
  }

  var id: UUID = UUID()
  var name: String
  var modelNumber: String
  var purchaseURL: String
  var searchPostalCode: String
  var shouldSendNotification: Bool
  var timeLastChecked: Date

}
