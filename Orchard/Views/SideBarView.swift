//
//  SideBarView.swift
//  Orchard (macOS)
//
//  Created by John Behnke on 3/11/22.
//

import SwiftUI

struct SideBarView: View {
  @ObservedObject var products = ProductModel()
  @State private var selectedProduct: Product? = Product()
  @State private var shouldShowAddProductView: Bool = false
  @State private var shouldShowEditProductView: Bool = false
  @State private var isHover = false
  @State private var hoveringIndex = 0
  @State private var isDefaultItemActive = true
  
  var body: some View {
    List(selection: $selectedProduct, content: {
      Section("Products") {
        ForEach(products.products, id:\.self) { product in
          
          HStack {
            if products.products.firstIndex(of: product)! == 0 {
              NavigationLink(destination: StoreListView(product: product), isActive: $isDefaultItemActive) {
                Text(product.name)
              }
            } else{
              NavigationLink{
                StoreListView(product: product)
              } label: {
                Text(product.name)
              }
            }
            
            
//            Spacer()
//            Spacer()
//            Menu {
//              Button(action: {
//                print("Pressed delete in context menu")
//                if let productToDelete = selectedProduct {
//                  products.deleteProduct(product: productToDelete)
//                }
//              }, label: {
//                Text("Delete")
//              })
//            }label: {
//              Image(systemName: "ellipsis.circle")
//            }.menuStyle(BorderlessButtonMenuStyle()).menuIndicator(.hidden).opacity(isHover && products.products.firstIndex(of: product)! == hoveringIndex ? 1:0)
            
            
            
          }
//          .onHover { hover in
//            isHover = hover
//            hoveringIndex = products.products.firstIndex(of: product) ?? 0
//          }
        }
        
      }.collapsible(false)})
      .onAppear{
        ProductModel.load { result in
          switch result {
          case .success(let loadedProducts):
            products.products = loadedProducts
          case .failure(let error):
            fatalError(error.localizedDescription)
          }
        }}
      .sheet(isPresented: self.$shouldShowEditProductView) {
        EditProductView(product: $selectedProduct.toNonOptional()).environmentObject(products)
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
            products.deleteProduct(product: productToDelete)
          }
        }, label: {
          Text("Delete")
        })
        
      }))
      .toolbar {
//        ToolbarItem {
//          Button(action: {
//            self.shouldShowAddProductView.toggle()
//          }) {
//            Label("Add Item", systemImage: "plus")
//          }
//          .keyboardShortcut("n", modifiers: .command)
//          .sheet(isPresented: self.$shouldShowAddProductView) {AddProductView().environmentObject(products)}
//        }
        ToolbarItem {
          Spacer()
        }
//        ToolbarItem {
//          Button(action: {
//            withAnimation{
//              print("Pressed delete button in toolbar")
//              print($selectedProduct)
//              if let productToDelete = selectedProduct {
//                products.deleteProduct(product: productToDelete)
//              }
//
//            }
//          }) {
//            Label("Delete Item", systemImage: "trash")
//          }
//        }
      }
      .listStyle(SidebarListStyle())
      .frame(minWidth: 200)
    HStack {
      Button(action: {}, label: {
        HStack {
          Image(systemName: "plus.circle")
          Text("Add new product")
        }
      }).buttonStyle(.borderless).padding([.bottom, .leading], 7.5)
      Spacer()
    }
  }
}

struct SideBarView_Previews: PreviewProvider {
  static var previews: some View {
    SideBarView()
  }
}

extension Binding where Value == Product? {
  func toNonOptional() -> Binding<Product> {
    return Binding<Product>(
      get: {
        return self.wrappedValue ?? Product()
      },
      set: {
        self.wrappedValue = $0
      }
    )
  }
}

