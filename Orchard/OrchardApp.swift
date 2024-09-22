//
//  OrchardApp.swift
//  Shared
//
//  Created by John Behnke on 11/10/21.
//

import SwiftUI
import AppKit
@main
struct OrchardApp: App {
  @StateObject var storeModel: StoreAPI
  @StateObject var userDataStore: UserDataStore
  @StateObject var productStore: ProductStore
  @ObservedObject var appSettings = AppSettings.shared

  init() {
    self._storeModel = StateObject(wrappedValue: StoreAPI())
    self._userDataStore = StateObject(wrappedValue: UserDataStore())
    self._productStore = StateObject(wrappedValue: ProductStore())
  }
  var body: some Scene {
    WindowGroup {
      MainView()
        .frame(minWidth: 900, idealWidth: 900, maxWidth: 1100, minHeight: 300)
        .environmentObject(storeModel)
        .environmentObject(userDataStore)
        .environmentObject(productStore)
    }
    Settings {
      PreferencesView()
        .environmentObject(storeModel)
        .environmentObject(userDataStore)
    }
  }
}
