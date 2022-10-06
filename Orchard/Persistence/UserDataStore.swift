//
//  TrackedProductStore.swift
//  Orchard
//
//  Created by John Behnke on 3/11/22.
//

import Foundation
@MainActor
class UserDataStore: ObservableObject {
  @Published var userData: UserData = UserData()
  func updateProduct(product: TrackedProduct) {
    if let row =  userData.trackedProducts.firstIndex(where: {$0.id == product.id}) {
      userData.trackedProducts[row] = product
    }
  }
  func addProduct(product: TrackedProduct) {
    userData.trackedProducts.append(product)
    UserDataStore.save(userData: userData) { result in
      if case .failure(let error) = result {
        fatalError(error.localizedDescription)
      }
    }
  }
  func deleteProduct(product: TrackedProduct) {
    if let row =  userData.trackedProducts.firstIndex(where: {$0.id == product.id}) {
      userData.trackedProducts.remove(at: row)
      UserDataStore.save(userData: userData) { result in
        if case .failure(let error) = result {
          fatalError(error.localizedDescription)
        }
      }
    }
  }
  func updateTimeSearched(time: Date) {
    userData.timeLastChecked = time
      UserDataStore.save(userData: userData) { result in
        if case .failure(let error) = result {
          fatalError(error.localizedDescription)
        }
      }
  }
  static func fileURL() throws -> URL {
    try FileManager.default.url(for: .documentDirectory,
                                in: .userDomainMask,
                                appropriateFor: nil,
                                create: false)
    .appendingPathComponent("userdata.json")
  }
  static func load(completion: @escaping (Result<UserData, Error>) -> Void) {
    do {
      let fileURL = try fileURL()
      guard let file = try? FileHandle(forReadingFrom: fileURL) else {
        DispatchQueue.main.async {
          completion(.success(UserData()))
        }
        return
      }
      let userData = try JSONDecoder().decode(UserData.self, from: file.availableData)
      DispatchQueue.main.async {
        completion(.success(userData))
      }
    } catch {
      DispatchQueue.main.async {
        completion(.failure(error))
      }
    }
  }
  static func save(userData: UserData, completion: @escaping (Result<Int, Error>) -> Void) {
    do {
      let data = try JSONEncoder().encode(userData)
      let outfile = try fileURL()
      try data.write(to: outfile)
      DispatchQueue.main.async {
        completion(.success(userData.trackedProducts.count))
      }
    } catch {
      DispatchQueue.main.async {
        completion(.failure(error))
      }
    }
  }
}
