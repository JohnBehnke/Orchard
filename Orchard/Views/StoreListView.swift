//
//  StoreListView.swift
//  Orchard
//
//  Created by John Behnke on 3/11/22.
//

import SwiftUI

struct StoreListView: View {
  @Environment(\.openURL) var openURL
  @EnvironmentObject var storeAPI: StoreAPI
  @EnvironmentObject var productStore: ProductStore
  @State private var selectedStore: Store?
  @State var lastSearchTime: Date?

  var product: TrackedProduct
  init(product: TrackedProduct) {
    self.product = product
  }
  var body: some View {
    Group {
      switch self.storeAPI.stores.count > 0 {
      case true:
        List(storeAPI.stores, id: \.self) { store in
          NavigationLink {
            StoreDetailView(store: store)
          } label: {
            HStack {
              Image(systemName: "circle.fill")
                .foregroundColor(getAvailabilityColor(store))
              VStack(alignment: .leading) {
                Text(store.information.name)
                Text(store.productAvailability[product.identifier]?.pickupQuote ?? "")
                  .font(.subheadline)
              }
            }.padding()
          }
        }
      default:
        ProgressView()
      }
    }
    .listStyle(.inset(alternatesRowBackgrounds: true))
    .navigationTitle("")
    .toolbar {
      ToolbarItem(placement: ToolbarItemPlacement.navigation) {
        Button {
          NSApp.keyWindow?.firstResponder?.tryToPerform(
            #selector(NSSplitViewController.toggleSidebar(_:)), with: nil
          )
        } label: {
          Label("Toggle sidebar", systemImage: "sidebar.left")
        }
      }
      ToolbarItem(placement: ToolbarItemPlacement.navigation) {
        HStack {
          VStack(alignment: .leading) {
            Text(product.name).font(.title3).bold()
            Text("Last checked \(itemFormatter.string(from: self.storeAPI.timeLastSearched ))")
              .font(Font.caption2)
              .italic()
          }
        }
      }
    }
  }

  fileprivate func getAvailabilityColor(_ store: Store) -> Color {
    return store.productAvailability[product.identifier]?.pickable ?? true
    ? store.productAvailability[product.identifier]?.pickupQuote == "Available Today"
      || store.productAvailability[product.identifier]?.pickupQuote == "Available Tomorrow"
    ? Color.green
    : Color.yellow
    : Color.red
  }
}

// struct StoreListView_Previews: PreviewProvider {
//  static var previews: some View {
// swiftlint:disable all
//    StoreListView(product: Product(name: "Demo Machine", modelNumber: "Demo Model Number", purchaseURL: "https://apple.com", searchPostalCode: "12345", shouldSendNotification: false, timeLastChecked: Date()))
//  }
//}
