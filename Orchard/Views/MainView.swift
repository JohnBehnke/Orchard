//
//  MainView.swift.swift
//
//  Created by John Behnke on 11/10/21.
//

import SwiftUI

struct MainView: View {
  var body: some View {
    NavigationView {
      SideBarView()
      EmptyView()
      Text("No Store Selected")
        .font(.title)
        .fontWeight(.light)
        .foregroundColor(.secondary)
    }

  }
}

 let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
   formatter.dateStyle = .short
   formatter.timeStyle = .short
   formatter.doesRelativeDateFormatting = true
  return formatter
}()

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MainView()
        .environmentObject(ProductStore())
        .environmentObject(StoreAPI())
      MainView()
        .environmentObject(ProductStore())
        .environmentObject(StoreAPI())
        .preferredColorScheme(.dark)
    }
  }
}
