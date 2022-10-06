//
//  Configuration.swift
//  Orchard
//
//  Created by John Behnke on 4/17/22.
//

import Foundation

struct Product: Codable {
  let id = UUID()
  let name: String
  let type: String
  let options: [Option]
}

struct Option: Codable, Hashable {
  let colorDisplayName: String?
  let primaryColorIdentifier: String?
  let secondaryColorIdentidier: String?
  let processor: String?
  let memory: String?
  let storage: String?
  let glass: String?
  let stand: String?
  let identifier: String
}
