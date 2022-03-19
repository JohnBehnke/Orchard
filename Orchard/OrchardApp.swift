//
//  OrchardApp.swift
//  Shared
//
//  Created by John Behnke on 11/10/21.
//

import SwiftUI

@main
struct OrchardApp: App {
  @StateObject var storeModel: StoreAPI
  @StateObject var productStore: ProductStore
  init() {
    self._storeModel = StateObject(wrappedValue: StoreAPI())
    self._productStore = StateObject(wrappedValue: ProductStore())
  }
  var body: some Scene {
    WindowGroup {
      ContentView()
        .frame(minWidth: 900, idealWidth: 900, maxWidth: 1100, minHeight: 300)
        .environmentObject(storeModel)
        .environmentObject(productStore)
    }
    Settings {
      SettingsView()
        .environmentObject(storeModel)
        .environmentObject(productStore)
    }
  }
}
