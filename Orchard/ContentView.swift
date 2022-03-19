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
      Text("No Store Selected").font(.title).foregroundColor(.secondary).fontWeight(.light)
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
//
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
      ContentView()
        .preferredColorScheme(.dark)
    }
  }
}


