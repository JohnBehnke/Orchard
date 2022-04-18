//
//  Configuration.swift
//  Orchard
//
//  Created by John Behnke on 4/17/22.
//

import Foundation


struct Product: Codable {
  let name: String
  let type: ProductType
  let options: Options
  let carriedConfigurations: [CarriedConfiguration]
}

struct Options: Codable {
  let colors: [String]
  let processors: [String]
  let memorySizes: [String]
  let storageSizes: [String]
  let graphicCards: [String]?
}

struct CarriedConfiguration: Codable {
  let color: String
  let processor: String
  let memory: String
  let storage: String
  let id: String
}

enum ProductType: Codable {
  case laptop
  case macmini
  case imac
  case macstudio
  case macpro
  case ipad
  case ipadpro
  case iphone
  case iphoneSE
  case homepodmini
  case watch
  case display
  case airpod
  case airpod3
  case airpodpro
  case airpodmax
  case appletv
}

/*
 
 */
