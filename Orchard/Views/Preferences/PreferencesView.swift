//
//  PreferencesView.swift
//  Orchard
//
//  Created by John Behnke on 11/10/21.
//

import SwiftUI

struct PreferencesView: View {
  var body: some View {
    TabView {
      GeneralPreferencesView()
        .tabItem {
          Label("General", systemImage: "gear")
        }.frame(width: 400, height: 300)
      TwilioPreferencesView()
        .tabItem {
          Label("Notifications", systemImage: "message")
        }.frame(width: 400, height: 200)
      UpdatesPreferencesView()
        .tabItem {
          Label("Updates", systemImage: "arrow.triangle.2.circlepath.circle")
        }.frame(width: 400, height: 200)
#if DEBUG
      DebugPreferencesView()
        .tabItem {
          Label("Debug", systemImage: "ladybug")
        }.frame(width: 400, height: 300)
#endif
    }
  }
}

struct PreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    PreferencesView()
      .preferredColorScheme(.light)
    PreferencesView()
      .preferredColorScheme(.light)
  }
}
