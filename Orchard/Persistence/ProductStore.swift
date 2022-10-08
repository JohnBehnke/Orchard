//
//  ProductStore.swift
//  Orchard
//
//  Created by John Behnke on 4/20/22.
//

import Foundation
@MainActor
class ProductStore: ObservableObject {
  @Published var products: [Product] = []
  //  func updateProduct(product: TrackedProduct) {
  //    if let row =  products.firstIndex(where: {$0.id == product.id}) {
  //      products[row] = product
  //    }
  //  }
  //
  //  func addProduct(product: TrackedProduct) {
  //    products.append(product)
  //    TrackedProductStore.save(products: products) { result in
  //      if case .failure(let error) = result {
  //        fatalError(error.localizedDescription)
  //      }
  //    }
  //  }
  //
  func getProductDetails(_ trackedProduct: TrackedProduct) -> Product? {

    for product in products {
      for option in product.options where option.identifier == trackedProduct.identifier {
        return product
      }
    }
    return nil
  }
  func findOptionFor(trackedProduct: TrackedProduct) -> (Int, Int) {
    for (productIndex, product) in products.enumerated() {
      for (optionIndex, option) in product.options.enumerated() where option.identifier == trackedProduct.identifier {
        return (productIndex, optionIndex)

      }
    }
    return (0, 0)
  }
  static func load(completion: @escaping (Result<[Product], Error>) -> Void) {
    if let url = Bundle.main.url(forResource: "Products", withExtension: "json") {
      do {
        let data = try Data(contentsOf: url)
        let products = try JSONDecoder().decode([Product].self, from: data)
        DispatchQueue.main.async {
          completion(.success(products))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    } else {
      DispatchQueue.main.async {
        completion(.success([]))
      }
    }
  }
}
