//
//  SideBarView.swift
//  Orchard (macOS)
//
//  Created by John Behnke on 3/11/22.
//

import SwiftUI

struct SideBarView: View {
  @EnvironmentObject var userDataStore: UserDataStore
  @EnvironmentObject var productStore: ProductStore
  @State private var selectedProduct: TrackedProduct? = TrackedProduct()
  @State private var shouldShowAddProductView: Bool = false
  @State private var shouldShowEditProductView: Bool = false
  @State private var isHover = false
  @State private var hoveringIndex = 0
  @State private var isDefaultItemActive = true
  var body: some View {
    List(selection: $selectedProduct, content: {
      Section("") {
        ForEach(userDataStore.userData.trackedProducts, id: \.self) { product in
          HStack {
            if userDataStore.userData.trackedProducts.firstIndex(of: product)! == 0 {
              NavigationLink(destination: StoreListView(product: product), isActive: $isDefaultItemActive) {
                Text(product.name)
              }
            } else {
              NavigationLink {
                StoreListView(product: product)
              } label: {
                Text(product.name)
              }
            }
          }
        }
      }
      .collapsible(false)})
    .listStyle(SidebarListStyle())
    .onAppear {
      UserDataStore.load { result in
        switch result {
        case .success(let userData):
          userDataStore.userData = userData
        case .failure(let error):
          userDataStore.userData = UserData()
        }
      }
      ProductStore.load { result in
        switch result {
        case .success(let loadedProducts):
          productStore.products = loadedProducts
        case .failure(let error):
          fatalError(error.localizedDescription)
        }
      }
    }
    .sheet(isPresented: self.$shouldShowEditProductView) {
      ProductConfiguratorView(
        productSelection: productStore.findOptionFor(trackedProduct: selectedProduct!).0,
        optionSelection: productStore.findOptionFor(trackedProduct: selectedProduct!).1
      )
//      EditProductView(product: $selectedProduct.toNonOptional()).environmentObject(trackedProductStore)
    }
    .contextMenu(ContextMenu(menuItems: {
      Button(action: {
        self.shouldShowEditProductView.toggle()
      }, label: {
        Text("Edit")
      })
      Divider()
      Button(action: {
        print("Pressed delete in context menu")
        if let productToDelete = selectedProduct {
          userDataStore.deleteProduct(product: productToDelete)
        }
      }, label: {
        Text("Delete")
      })
    }))
    .toolbar {
      ToolbarItem {
        Spacer()
      }
    }
    .listStyle(SidebarListStyle())
    .frame(minWidth: 200)
    HStack {
      Button(action: {
        self.shouldShowAddProductView.toggle()
      }, label: {
        HStack {
          Image(systemName: "plus.circle")
          Text("Add new product")
        }
      }).buttonStyle(.borderless).padding([.bottom, .leading], 7.5)
        .sheet(isPresented: self.$shouldShowAddProductView) {
//          AddProductView().environmentObject(products)
          ProductConfiguratorView()

        }
      Spacer()
    }
  }
}

struct SideBarView_Previews: PreviewProvider {
  static var previews: some View {
    SideBarView()
  }
}

extension Binding where Value == TrackedProduct? {
  func toNonOptional() -> Binding<TrackedProduct> {
    return Binding<TrackedProduct>(
      get: {
        return self.wrappedValue ?? TrackedProduct()
      },
      set: {
        self.wrappedValue = $0
      }
    )
  }
}
