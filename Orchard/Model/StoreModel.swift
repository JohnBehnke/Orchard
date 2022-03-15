//
//  StoreModel.swift
//  Orchard
//
//  Created by John Behnke on 3/11/22.
//

import Foundation

@MainActor
class StoreModel: ObservableObject {
  @Published var stores = [Store]()
  @Published var isSearching = true
  init() {
    stores =  [Store.demoStore]
    isSearching = true
  }
  
  
  
  func getStores(postalCode: String, modelNumber: String) async {
    
    self.isSearching = true
    let lookupUrl: String = "https://www.apple.com/shop/fulfillment-messages?parts.0=\(modelNumber.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&searchNearby=true&location=\(postalCode)"
    guard let url = URL(string: lookupUrl) else {
      fatalError()
    }
    do {
      let (data, _) = try await URLSession.shared.data(from: url);
      let result = try JSONDecoder().decode(AppleStoreAPIResponse.self, from: data)
      self.isSearching = false
      self.stores.removeAll()
      for store in result.body.content.pickupMessage.stores {
        self.stores.append(store)
      }
    } catch {
      print(url)
      print("Request failed with error: \(error)")
    }
  }
}
