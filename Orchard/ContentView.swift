//
//  ContentView.swift
//  Shared
//
//  Created by John Behnke on 11/10/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
  
//  @Environment(\.managedObjectContext) private var viewContext
//  @FetchRequest(
//    sortDescriptors: [NSSortDescriptor(keyPath: \Product.timeAdded, ascending: true)],
//    animation: .default)
//
//  private var products: FetchedResults<Product>
//  @State private var isPopover = false
//  @State private var showEditView = false
//  @State private var stores: [Store] = []
//  @State private var selectedDisplayStyle = 0
//  @State private var selected: Set<Product> = Set<Product>()
  
  var body: some View {
    NavigationView {
      SideBarView()
      EmptyView()
      Text("Select a product")
    }
//    NavigationView {
//      List(selection: $selected) {
//        ForEach(products) { product in
//          NavigationLink {
//            List(0..<stores.count) { index in
//              CompactStoreStatusCellView(store: $stores[index], purchaseUrl: product.purchaseUrl ?? "https://www.apple.com/shop")
//            }.listStyle(.inset(alternatesRowBackgrounds: true))
//              .navigationTitle("Store Results")
//
//              .toolbar {
//                HStack {
//                  Button(action: {}, label: {Image(systemName: "bag.fill")})
//                  Button(action: {}, label: {Image(systemName: "phone.fill")})
//                  Button(action: {}, label: {Image(systemName: "map.fill")})
//                  Button(action: {}, label: {Image(systemName: "info.circle.fill")})
//                }.padding()
//                Picker("", selection: $selectedDisplayStyle, content: {
//                  Image(systemName: "list.dash").tag(0)
//                  Image(systemName: "text.below.photo").tag(1)
//                }).pickerStyle(SegmentedPickerStyle())
//              }
//
//          } label: {
//            Text(product.productName!)
//
//          }
//
//          .contextMenu(ContextMenu(menuItems: {
//            Button(action: {
//              self.showEditView.toggle()
//            }, label: {
//              Text("Edit")
//            })
//            Divider()
//            Button(action: {
//              print("Pressed delete in context menu")
//            }, label: {
//              Text("Delete")
//            })
//
//          }))
//
//        }
//
////        .sheet(item: self.$selected) { product in
////          if self.showEditView {
////            EditProductView(product: product)
////          }
////        }
//      }
//      .task {
//        self.stores = await AppleStoreAPI().performSearch()
//      }
//
////      .keyboardShortcut(.delete, modifiers: [])
//      .onDeleteCommand(perform: {
//        print("Pressed backspace")
//      })
//      .toolbar {
//        ToolbarItem {
//          Button(action: {self.isPopover.toggle()}) {
//            Label("Add Item", systemImage: "plus")
//          }
//          .keyboardShortcut("n", modifiers: .command)
//          .sheet(isPresented: self.$isPopover) {AddProductView()}
//
//
//        }
//        ToolbarItem {
//          Spacer()
//        }
//        ToolbarItem {
//          Button(action: {
//            print("Pressed delete button in toolbar")
//          }) {
//            Label("Delete Item", systemImage: "trash.fill")
//          }
//          .keyboardShortcut(.delete, modifiers: [.command])
//
//
//
//        }
//      }
//      Text("Select an item")
//    }
  }

  
//  private func deleteItems(offsets: IndexSet) {
//    withAnimation {
//      offsets.map { products[$0] }.forEach(viewContext.delete)
//
//      do {
//        try viewContext.save()
//      } catch {
//        // Replace this implementation with code to handle the error appropriately.
//        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        let nsError = error as NSError
//        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//      }
//    }
//  }
}

 let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
   formatter.dateStyle = .short
   formatter.timeStyle = .short
  return formatter
}()
//
//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//  }
//}


