//
//  GeneralPreferencesView.swift
//  Orchard
//
//  Created by John Behnke on 3/13/22.
//

import SwiftUI
import UserNotifications

struct GeneralPreferencesView: View {
  @State var increment = 0
  var body: some View {
    VStack {
      HStack {
        Text("Search Interval:")
        Stepper("\(increment == 0 ? 1 : increment) \(increment == 0 ? "minute" : "minutes")", value: $increment, in: 0...60, step: 5)
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
      
    }
  }
}

struct GeneralPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
      GeneralPreferencesView().frame(width: 300, height: 400)
    }
}
