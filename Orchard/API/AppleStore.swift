//
//  AppleStore.swift
//  Orchard
//
//  Created by John Behnke on 3/9/22.
//

import Foundation

struct AppleStoreAPI {
  func performSearch() async -> [Store] {
    var stores: [Store] = []
    let lookupUrl: String = "https://www.apple.com/shop/fulfillment-messages?parts.0=MJMW3LL%2fA&searchNearby=d&mt=regular&store=R093"
    guard let url = URL(string: lookupUrl) else {
      fatalError()
    }
    do {
      let (data, _) = try! await URLSession.shared.data(from: url);
      
      let result = try JSONDecoder().decode(AppleStoreAPIResponse.self, from: data)
      for store in result.body.content.pickupMessage.stores {
        if store.partsAvailability.model.storeSelectionEnabled  {
          stores.append(store)
        }
      }
      return stores
    } catch {
      print("Request failed with error: \(error)")
      return []
    }
  }
}

protocol URLQueryParameterStringConvertible {
  var queryParameters: String {get}
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}


extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

