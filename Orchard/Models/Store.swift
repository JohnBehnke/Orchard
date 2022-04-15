//
//  Store.swift
//  Orchard
//
//  Created by John Behnke on 3/19/22.
//

import Foundation

struct Store: Encodable {

  init(
    information: Information,
    address: Address,
    productAvailability: [String: ProductAvailability],
    schedule: Schedule
  ) {
    self.information = information
    self.address = address
    self.productAvailability = productAvailability
    self.schedule = schedule
  }

  let id: UUID = UUID()
  var information: Information
  var address: Address
  var productAvailability: [String: ProductAvailability]
  var schedule: Schedule

}
struct Information: Encodable {
  init(name: String, image: String, phoneNumber: String, number: String, message: String, messageTitle: String) {
    self.name = name
    self.image = image
    self.phoneNumber = phoneNumber
    self.number = number
    self.message = message
    self.messageTitle = messageTitle
  }

  var name: String
  let image: String
  let phoneNumber: String
  let number: String
  let messageTitle: String
  let message: String
}
struct Address: Encodable {
  init(
    lineOne: String,
    lineTwo: String,
    city: String,
    stateCode: String,
    country: String,
    postal: String,
    longitude: Double,
    latitude: Double
  ) {
    self.lineOne = lineOne
    self.lineTwo = lineTwo
    self.city = city
    self.stateCode = stateCode
    self.country = country
    self.postal = postal
    self.longitude = longitude
    self.latitude = latitude
  }

  let lineOne: String
  let lineTwo: String
  let city: String
  let country: String
  let stateCode: String
  let postal: String
  let longitude: Double
  let latitude: Double
}
struct ProductAvailability: Encodable {
  init(pickable: Bool, searchable: Bool, selectable: Bool, pickupSearchQuote: String) {
    self.pickable = pickable
    self.searchable = searchable
    self.selectable = selectable
    self.pickupQuote = pickupSearchQuote
  }

  let pickable, searchable, selectable: Bool
  let pickupQuote: String
}

struct Schedule: Encodable {
  let currentStatus: String
  let days: [Day]
}

struct Day: Encodable {
  let id: UUID = UUID()
  let shortName: String
  let formattedDate: String
  let formattedTime: String
  let isSpecialHours: Bool
}

extension Store: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }

  static func == (lhs: Store, rhs: Store) -> Bool {
    lhs.id == rhs.id
  }
}

extension Day: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }

  static func == (lhs: Day, rhs: Day) -> Bool {
    lhs.id == rhs.id
  }
}
