//
//  ProductStore.swift
//  Orchard
//
//  Created by John Behnke on 3/11/22.
//

import Foundation
@MainActor
class ProductStore: ObservableObject {
  @Published var products: [Product] = []
  func updateProduct(product: Product) {
    if let row =  products.firstIndex(where: {$0.id == product.id}) {
      products[row] = product
    }
  }

  func addProduct(product: Product) {
    products.append(product)
    ProductStore.save(products: products) { result in
      if case .failure(let error) = result {
        fatalError(error.localizedDescription)
      }
    }
  }

  func deleteProduct(product: Product) {
    if let row =  products.firstIndex(where: {$0.id == product.id}) {
      products.remove(at: row)
      ProductStore.save(products: products) { result in
        if case .failure(let error) = result {
          fatalError(error.localizedDescription)
        }
      }
    }
  }

  static func fileURL() throws -> URL {
    try FileManager.default.url(for: .documentDirectory,
                                   in: .userDomainMask,
                                   appropriateFor: nil,
                                   create: false)
      .appendingPathComponent("products.data")
  }

  static func load(completion: @escaping (Result<[Product], Error>) -> Void) {

    do {
      let fileURL = try fileURL()
      guard let file = try? FileHandle(forReadingFrom: fileURL) else {
        DispatchQueue.main.async {
          completion(.success([]))
        }
        return
      }
      let products = try JSONDecoder().decode([Product].self, from: file.availableData)
      DispatchQueue.main.async {
        completion(.success(products))
      }
    } catch {
      DispatchQueue.main.async {
        completion(.failure(error))
      }
    }
  }

  static func save(products: [Product], completion: @escaping (Result<Int, Error>) -> Void) {

    do {
      let data = try JSONEncoder().encode(products)
      let outfile = try fileURL()
      try data.write(to: outfile)
      DispatchQueue.main.async {
        completion(.success(products.count))
      }
    } catch {
      DispatchQueue.main.async {
        completion(.failure(error))
      }
    }
  }
}
