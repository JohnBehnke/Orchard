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
  var product: TrackedProduct
  init(product: TrackedProduct) {
    self.product = product
  }
  fileprivate func getAvailabilityColor(_ store: Store) -> Color {
    return store.productAvailability[product.identifier]?.selectable ?? false
    ? store.productAvailability[product.identifier]?.pickupQuote == "Available Today"
      || store.productAvailability[product.identifier]?.pickupQuote == "Available Tomorrow"
    ? Color.green
    : Color.yellow
    : Color.red
  }
  var body: some View {
    Group {
      switch self.storeAPI.isSearching {
      case false:
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
    .task {
      storeAPI.isSearching = true
      await storeAPI.performSearch(for: product.identifier, near: "06877")
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
        VStack(alignment: .leading) {
          Text(product.name).font(.title3).bold()
          Text("Last checked \(itemFormatter.string(from: product.timeLastChecked))").font(Font.caption2).italic()
        }
      }
//      ToolbarItem {
//        Button(action: {
//          let url: URL = URL(string: product.purchaseURL)!
//          openURL(url)
//        }, label: {Image(systemName: storeAPI.isEligableForPurchase ? "bag.badge.plus" : "bag")})
//        .disabled(!storeAPI.isEligableForPurchase)
//      }
    }
  }
}

// struct StoreListView_Previews: PreviewProvider {
//  static var previews: some View {
// swiftlint:disable all
//    StoreListView(product: Product(name: "Demo Machine", modelNumber: "Demo Model Number", purchaseURL: "https://apple.com", searchPostalCode: "12345", shouldSendNotification: false, timeLastChecked: Date()))
//  }
//}
