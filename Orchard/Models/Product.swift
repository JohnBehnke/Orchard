//
//  Product.swift
//  Orchard (macOS)
//
//  Created by John Behnke on 3/11/22.
//

import Foundation

struct Product: Identifiable, Hashable, Codable {
  internal init(name: String, modelNumber: String, purchaseURL: URL, searchPostalCode: String, shouldSendNotification: Bool, timeLastChecked: Date) {
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
    self.purchaseURL = URL(string: "https://apple.com")!
    self.searchPostalCode = "searchPostalCode"
    self.shouldSendNotification = false
    self.timeLastChecked = Date()
  }
  
  var id: UUID = UUID()
  var name: String
  var modelNumber: String
  var purchaseURL: URL
  var searchPostalCode: String
  var shouldSendNotification: Bool
  var timeLastChecked: Date
  

}
