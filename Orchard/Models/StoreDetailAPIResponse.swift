//
//  StoreDetailAPI.swift
//  Orchard
//
//  Created by John Behnke on 3/17/22.
//

import Foundation


struct StoreDetailAPIResponse: Decodable {
  let messageTitle: String
  let message: String
  let hours: Hours
  let telephone: String
}


struct Hours: Decodable {
  let currentStatus: String
  let days: [Days]
}

struct Days: Decodable {
  let shortName: String
  let formattedDate: String
  let formattedTime: String
  let specialHours: Bool
}
