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
  @StateObject var productStore: ProductStore
  @ObservedObject var appSettings = AppSettings.shared

  init() {
    self._storeModel = StateObject(wrappedValue: StoreAPI())
    self._productStore = StateObject(wrappedValue: ProductStore())
  }
  var body: some Scene {
    WindowGroup {
      MainView()
//        .preferredColorScheme(appSettings.currentTheme == 0 ? .light : appSettings.currentTheme == 1 ? .dark : .none)
        .frame(minWidth: 900, idealWidth: 900, maxWidth: 1100, minHeight: 300)
        .environmentObject(storeModel)
        .environmentObject(productStore)
    }
    
    Settings {
      PreferencesView()
        .environmentObject(storeModel)
        .environmentObject(productStore)
//        .preferredColorScheme(appSettings.currentTheme == 0 ? .light : appSettings.currentTheme == 1 ? .dark : .none)
    }
  }
}

enum Appearances: String, CaseIterable, Hashable {
    case system
    case light
    case dark

  func applyAppearance(appearence: Appearances) {
        switch appearence {
        case .system:
            NSApp.appearance = nil

        case .dark:
            NSApp.appearance = .init(named: .darkAqua)

        case .light:
            NSApp.appearance = .init(named: .aqua)
        }
    }

    static let `default` = Appearances.system
    static let storageKey = "appearance"
}
