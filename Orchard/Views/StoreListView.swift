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
  @State private var selectedStore: Store?
  var product: Product
  init(product: Product)  {
    self.product = product
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
              Image(systemName: "circle.fill").foregroundColor(store.productAvailability[product.modelNumber]?.selectable ?? false ? Color.green : Color.red)
              VStack(alignment: .leading) {
                Text(store.information.name)
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
      await storeAPI.performSearch(for: product.modelNumber, near: product.searchPostalCode)
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
            ToolbarItem {
              Button(action: {openURL(product.purchaseURL)}, label: {Image(systemName: storeAPI.isEligableForPurchase ? "bag.badge.plus" : "bag")}).disabled(!storeAPI.isEligableForPurchase)
              //
            }
    }
  }
}

struct StoreListView_Previews: PreviewProvider {
  static var previews: some View {
    StoreListView(product: Product(name: "Demo Machine", modelNumber: "Demo Model Number", purchaseURL: URL(string: "https://apple.com")!, searchPostalCode: "12345", shouldSendNotification: false, timeLastChecked: Date()))
  }
}
