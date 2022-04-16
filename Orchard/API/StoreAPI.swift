//
//  StoreModel.swift
//  Orchard
//
//  Created by John Behnke on 3/11/22.
//

import Foundation

@MainActor
class StoreAPI: ObservableObject {
  @Published var stores = [Store]()
  @Published var isSearching: Bool = true
  @Published var isEligableForPurchase: Bool = false
  init() {
    stores =  []
    isSearching = true
  }
  func getProductAvailability(for modelIdentifier: String, near postalCode: String) async -> [StoreInfo] {
    let escapedModelIdentifier = modelIdentifier.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let lookupUrl: String = "https://www.apple.com/shop/fulfillment-messages?parts.0=\(escapedModelIdentifier)&searchNearby=true&location=\(postalCode)"
    guard let url = URL(string: lookupUrl) else {
      fatalError()
    }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let result = try JSONDecoder().decode(FulfillmentMessagesAPIResponse.self, from: data)
      //      return result.body.content.pickupMessage.stores
      return result.body.content.pickupMessage.stores
    }
    //      self.isEligableForPurchase =  self.stores.contains(where: {$0.partsAvailability.model.storeSelectionEnabled})
    catch {
      self.isSearching = false
      print(url)
      print("Request failed with error: \(error)")
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
      // swiftlint:disable all
      let (data, _) = try await URLSession.shared.data(from: url);
      return try JSONDecoder().decode(StoreDetailAPIResponse.self, from: data)
      
    } catch {
      print("Request failed with error: \(error)")
      return nil
    }
  }
  
  func performSearch(for modelIdentifer: String, near postalCode: String) async {
    self.isSearching = true
    self.isEligableForPurchase = false
    var newStores: [Store] = [Store]()
    let productAvailabilityResponse = await self.getProductAvailability(for: modelIdentifer, near: postalCode)
    for store in productAvailabilityResponse {
      let productAvailability: ProductAvailability = ProductAvailability(
        pickable: store.partsAvailability.model.storePickEligible,
        searchable: store.partsAvailability.model.storeSearchEnabled,
        selectable: store.partsAvailability.model.storeSelectionEnabled,
        pickupSearchQuote: store.partsAvailability.model.pickupSearchQuote
      )
      if productAvailability.selectable { self.isEligableForPurchase = true }
      if let index =  self.stores.firstIndex(where: {$0.information.number == store.storeNumber}) {
        self.isSearching = false
        self.stores[index].productAvailability[modelIdentifer] = productAvailability
      } else {
        guard let additionalStoreInformation: StoreDetailAPIResponse = await getAdditionalStoreInformation(for: store.storeName) else {
          return
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
        newStores.append(Store(information: storeInformation, address: storeAddress, productAvailability: [modelIdentifer: productAvailability], schedule: storeSchedule))
        
        
      }
      if newStores.count == productAvailabilityResponse.count {
        self.stores = newStores
        self.isSearching = false
      }
    }
  }
}
