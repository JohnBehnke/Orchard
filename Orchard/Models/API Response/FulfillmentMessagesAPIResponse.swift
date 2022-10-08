//
//  AppleStoreAPI.swift
//  Orchard
//
//  Created by John Behnke on 11/6/21.
//

import Foundation

struct FulfillmentMessagesAPIResponse: Decodable {
  let head: Head
  let body: Body
}

// MARK: - Body
struct Body: Decodable {
  let content: Content
}

// MARK: - Content
struct Content: Decodable {
  let pickupMessage: PickupMessage
  //    let deliveryMessage: DeliveryMessage
}

// MARK: - PickupMessage
struct PickupMessage: Decodable {
  let stores: [StoreInfo]
}
struct DataClass: Codable {
}

// MARK: - Store
struct StoreInfo: Decodable {

  let storeName: String
  let city, storeNumber, reservationUrl, state, country: String
  var partsAvailability: [String: PartsAvailability]
  let phoneNumber: String
  let address: StoreAddress
  let storedistance, storelatitude, storelongitude: Double
  let retailStore: RetailStore
  let storeDetails: StoreDetailAPIResponse?

}

// MARK: - StoreAddress
struct StoreAddress: Codable {
  let address: String
  let address2, postalCode: String
}

// MARK: - PartsAvailability
struct ModelIdentifier: Decodable {
  var model: PartsAvailability
}

// MARK: - PartsAvailability
struct PartsAvailability: Decodable {
  let storePickEligible, storeSearchEnabled, storeSelectionEnabled: Bool?
  let partNumber, pickupSearchQuote: String
}

// MARK: - RetailStore
struct RetailStore: Decodable {
  let secureStoreImageUrl: String
}

// MARK: - Head
struct Head: Decodable {
  let status: String
  let data: DataClass
}

// extension Store {
//  static let demoStore = loadPreviewData("Preview Content/demoStore")
//
//  static private func loadPreviewData(_ name: String) -> Store {
//    guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
//      print("Couldn't find demo file")
//      fatalError("Couldn't find demo file")
//    }
//    let data = try? Data(contentsOf: url)
//    let stores = try? JSONDecoder().decode(Store.self, from: data!)
//    return stores!
//  }
// }

// extension Store: Hashable {
//  static func == (lhs: Store, rhs: Store) -> Bool {
//    return lhs.storeNumber >= rhs.storeNumber
//  }
//  func hash(into hasher: inout Hasher) {
//    hasher.combine(id)
//
//  }
// }
