//
//  UpdatesPreferencesView.swift
//  Orchard
//
//  Created by John Behnke on 3/13/22.
//

import SwiftUI

struct UpdatesPreferencesView: View {
  @State var shouldCheckUpdatesAutomatically: Bool = false
  @State var timeLastChecked: Date = Date()
  @State var shouldSubscribeToBetaUpdates: Bool = false
  var body: some View {
    VStack {

      Toggle(isOn: self.$shouldCheckUpdatesAutomatically, label: { Text("Check for updates automatically")
      })

      VStack {
        Button(action: {}, label: {
          Text("Check for updates").font(.caption)
        })
        HStack {
          Text("Last Checked \(itemFormatter.string(from: timeLastChecked))").font(.caption)
        }
      }

      Picker(selection: $shouldSubscribeToBetaUpdates, label: Text("Update Channel: ")) {
        Text("Release").tag(false)
        Text("Beta").tag(true)
      }.pickerStyle(.radioGroup)

      Text("Beta updates might be unstable").foregroundColor(.secondary)
    }
  }
}

struct UpdatesPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    UpdatesPreferencesView()
      .frame(width: 300, height: 400)
      .preferredColorScheme(.light)
    UpdatesPreferencesView()
      .frame(width: 300, height: 400)
      .preferredColorScheme(.dark)
  }
}
