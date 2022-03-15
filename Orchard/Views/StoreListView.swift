//
//  StoreListView.swift
//  Orchard
//
//  Created by John Behnke on 3/11/22.
//

import SwiftUI

struct StoreListView: View {
  
  @Environment(\.openURL) var openURL
  @ObservedObject var storeModel: StoreModel
  @State private var selectedStore: Store?
  var product: Product
  init(product: Product)  {
    self.product = product
    storeModel =  StoreModel()
  }
  var body: some View {
    Group {
      switch self.storeModel.isSearching {
      case false:
        List(storeModel.stores) { store in
          NavigationLink {
            StoreDetailView(store: store, purchaseUrl: product.purchaseURL)
          } label: {
            HStack {
              Image(systemName: "circle.fill").foregroundColor(store.partsAvailability.model.storeSelectionEnabled ? Color.green : Color.red)
              VStack(alignment: .leading) {
                Text(store.address.address)
              }
              
            }.padding()
          }
        }
      default:
        ProgressView()
      }
    }
    .task {
      await storeModel.getStores(postalCode: product.searchPostalCode, modelNumber: product.modelNumber)
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
        Button(action: {openURL(product.purchaseURL)}, label: {Image(systemName: "bag")}).disabled(!storeModel.stores.contains(where: {$0.partsAvailability.model.storeSelectionEnabled}))
      }
    }
  }
}

struct StoreListView_Previews: PreviewProvider {
  static var previews: some View {
    StoreListView(product: Product(name: "Demo Machine", modelNumber: "Demo Model Number", purchaseURL: URL(string: "https://apple.com")!, searchPostalCode: "12345", shouldSendNotification: false, timeLastChecked: Date()))
  }
}
