//
//  GeneralPreferencesView.swift
//  Orchard
//
//  Created by John Behnke on 3/13/22.
//

import SwiftUI
import AppKit
import UserNotifications

struct GeneralPreferencesView: View {
  @AppStorage("selectedAppearence") var selectedAppearence: Int = 0
  @ObservedObject var appSettings = AppSettings.shared
  @State var increment = 0
  @State var themeSelection: Int = 0
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    HStack {
      Spacer()
      VStack(alignment: .leading) {
#if DEBUG
        HStack {
          Text("Appearence: ")
          VStack {
            Image("Light Theme Selection", bundle: .main, label: Text("Light"))
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 67, height: 44)
              .clipShape(RoundedRectangle(cornerRadius: 5))
              .if(themeSelection == 0) { view in
                view
                  .overlay(RoundedRectangle(cornerRadius: 5).stroke(.tint, lineWidth: 2))
              }

              .onTapGesture {
                themeSelection = 0
//                Appearances.applyAppearance(Appearances.light)
//                appSettings.currentTheme = 0
                NSApp.appearance = .init(named: .aqua)
//                Appearances.applyAppearance(Appearances.light)
              }
            Text("Light")
          }
          VStack {
            Image("Dark Theme Selection", bundle: .main, label: Text("Dark"))
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 67, height: 44)
              .clipShape(RoundedRectangle(cornerRadius: 5))
              .if(themeSelection == 1) { view in
                view
                  .overlay(RoundedRectangle(cornerRadius: 5).stroke(.tint, lineWidth: 2))
              }

              .onTapGesture {
               themeSelection = 1
                NSApp.appearance = .init(named: .darkAqua)
              }
            Text("Dark")
          }
          VStack {
            Image("System Theme Selection", bundle: .main, label: Text("System"))
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 67, height: 44)
              .clipShape(RoundedRectangle(cornerRadius: 5))
              .if(themeSelection == 2) { view in
                view
                  .overlay(RoundedRectangle(cornerRadius: 5).stroke(.tint, lineWidth: 2))
              }

              .onTapGesture {
//                appSettings.currentTheme = 2
                themeSelection = 2
                NSApp.appearance = nil
              }
            Text("Auto")
          }

        }
#endif
        Divider()

        HStack {
          Picker(selection: $increment) {
            Text("5 minutes").tag(0)
            Text("20 minutes").tag(1)
            Text("30 minutes").tag(2)
            Text("1 hour").tag(3)
          } label: {
            Text("Search Interval: ")
          } .frame(width: 220)
        }
        Button("Request Permission") {
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
              print("All set!")
            } else if let error = error {
              print(error.localizedDescription)
            }
          }
        }
        Button("Schedule Notification") {
          let content = UNMutableNotificationContent()
          content.title = "Product Found!"
          content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 50)

          // show this notification five seconds from now
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

          // choose a random identifier
          let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

          // add our notification request
          UNUserNotificationCenter.current().add(request)
        }
        Spacer()
      }.padding()
      Spacer()
    }.padding()
      .if(selectedAppearence != 2) { view in
        view.preferredColorScheme(selectedAppearence == 0 ? .light : selectedAppearence == 1 ? .dark : nil)
      }

  }
}

struct GeneralPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    GeneralPreferencesView()
      .frame(width: 500, height: 400)
      .preferredColorScheme(.light)
    GeneralPreferencesView()
      .frame(width: 500, height: 400)
      .preferredColorScheme(.dark
      )
  }
}

class AppSettings: ObservableObject {

  static let shared = AppSettings()

  @AppStorage("selectedAppearence") var currentTheme: Int = 0
}

//
// enum Theme: Int {
//    case light
//    case dark
//    case auto
//
//    var colorScheme: ColorScheme {
//        switch self {
//        case .light:
//            return .light
//        case .dark:
//            return .dark
//        case .auto:
//          return .nil
//        }
//    }
// }
