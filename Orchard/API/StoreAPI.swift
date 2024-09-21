//
//  StoreModel.swift
//  Orchard
//
//  Created by John Behnke on 3/11/22.
//

import Foundation

@MainActor
class StoreAPI: ObservableObject {
  @Published var stores: [Store] = []
  @Published var isSearching: Bool = true
  @Published var isEligableForPurchase: Bool = false
  @Published var timeLastSearched: Date = Date()
  init() {
    stores =  []
    isSearching = true
  }
  func getProductAvailability(for modelIdentifiers: [String], near postalCode: String) async -> [StoreInfo] {
    var escapedModelIdentifiers: [String] = []
    for (index, modelIdentifier) in modelIdentifiers.enumerated() {
      let escapedModelIdentifier = modelIdentifier.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
      escapedModelIdentifiers.append("parts.\(index)=\(escapedModelIdentifier)")
    }
    let orderNumberQueryParam: String = escapedModelIdentifiers.joined(separator: "&")
    let baseUrl: String = "https://www.apple.com/shop/fulfillment-messages"
    let searchQueryParams = "searchNearby=true&location=\(postalCode)"
    let lookupUrl: String = "\(baseUrl)?\(orderNumberQueryParam)&\(searchQueryParams)"
    guard let url = URL(string: lookupUrl) else {
      fatalError()
    }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let result = try JSONDecoder().decode(FulfillmentMessagesAPIResponse.self, from: data)
      return result.body.content.pickupMessage.stores
    } catch {
      self.isSearching = false
      return []
    }
  }
  func getAdditionalStoreInformation(for storeName: String) async -> StoreDetailAPIResponse? {
    let storeSlug: String = storeName.components(separatedBy: .alphanumerics.inverted).joined().lowercased()
    let lookupUrl: String = "https://www.apple.com/rsp-web/store-detail?locale=en_US&storeSlug=\(storeSlug)"
    guard let url = URL(string: lookupUrl) else {
      fatalError()
    }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      return try JSONDecoder().decode(StoreDetailAPIResponse.self, from: data)
    } catch {
      return nil
    }
  }
  func performSearch(for modelIdentifers: [String], near postalCode: String) async {
    self.isSearching = true
    self.isEligableForPurchase = false
    var newStores: [Store] = [Store]()
    let productAvailabilityResponse = await self.getProductAvailability(for: modelIdentifers, near: postalCode)
    for store in productAvailabilityResponse {
      var newStore = await build(store)
      for product in store.partsAvailability.values {
        let modelIdentifer = product.partNumber
        let productAvailability: ProductAvailability = ProductAvailability(
          pickable: product.storePickEligible ?? false,
          searchable: product.storeSearchEnabled ?? false,
          selectable: product.storeSelectionEnabled ?? false,
          pickupSearchQuote: product.pickupSearchQuote
        )
        newStore.productAvailability[modelIdentifer] = productAvailability
      }
      newStores.append(
        newStore
      )
      if newStores.count == productAvailabilityResponse.count {
        if !self.stores.elementsEqual(newStores) {
          self.stores = newStores
        }
        self.isSearching = false
        self.timeLastSearched = Date()
      }
    }
  }
  private func build(_ store: StoreInfo) async -> Store {
    guard let additionalStoreInformation = await getAdditionalStoreInformation(for: store.storeName) else {
      fatalError()
    }
    let storeInformation: Information = Information(
      name: store.storeName,
      image: store.retailStore.secureStoreImageUrl,
      phoneNumber: additionalStoreInformation.telephone,
      number: store.storeNumber,
      message: additionalStoreInformation.message,
      messageTitle: additionalStoreInformation.messageTitle
    )
    let storeAddress: Address = Address(
      lineOne: store.address.address,
      lineTwo: store.address.address2,
      city: store.city,
      stateCode: store.state,
      country: store.country,
      postal: store.address.postalCode,
      longitude: store.storelongitude,
      latitude: store.storelongitude
    )
    var days: [Day] = [Day]()
    for day in additionalStoreInformation.hours.days {
      days.append(
        Day(
          shortName: day.shortName,
          formattedDate: day.formattedDate,
          formattedTime: day.formattedTime,
          isSpecialHours: day.specialHours
        )
      )
    }
    let storeSchedule: Schedule =  Schedule(
      currentStatus: additionalStoreInformation.hours.currentStatus,
      days: days
    )
    return Store(
      information: storeInformation,
      address: storeAddress,
      productAvailability: [:],
      schedule: storeSchedule
    )
  }
}
