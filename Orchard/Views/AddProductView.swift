//
//  AddProductView.swift
//  Orchard
//
//  Created by John Behnke on 11/10/21.
//

import SwiftUI

struct AddProductView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var products: ProductStore
  @State var productName = ""
  @State var modelNumber = ""
  @State var purchaseUrl = ""
  @State var zipCode = ""
  @State var shouldSendNotification = false

  var body: some View {
    VStack(alignment: .leading) {
      Text("New Product")
        .fontWeight(.bold)
      HStack {
        Text("Name:")
        Spacer()
        TextField("", text: $productName)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      HStack {
        Text("Model Number:")
        Spacer()
        TextField("", text: $modelNumber)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      HStack {
        Text("Store URL:")
        Spacer()
        TextField("", text: $purchaseUrl)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      Divider()
      HStack {
        Text("Zip Code:")
        TextField("", text: $zipCode).frame(width: 80)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      HStack {
        Text("Send Notification")
        Toggle(isOn: $shouldSendNotification, label: {})
      }
      Divider()
      HStack {
        Spacer()
        Button("Cancel", role: .cancel, action: {
          presentationMode.wrappedValue.dismiss()
        }).keyboardShortcut(.cancelAction)
        Button("OK", action: {addItem()}).disabled(false).keyboardShortcut(.defaultAction)
      }
    }
    .padding(20)
    .frame(width: 300, height: 250, alignment: .topLeading)
  }

  private func addItem() {
    let newProduct: Product = Product(
      name: productName,
      modelNumber: modelNumber,
      purchaseURL: purchaseUrl,
      searchPostalCode: zipCode,
      shouldSendNotification: shouldSendNotification,
      timeLastChecked: Date()
    )
    products.addProduct(product: newProduct)
      presentationMode.wrappedValue.dismiss()
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    AddProductView()
      .frame(width: 300, height: 400)
      .preferredColorScheme(.light)
    AddProductView()
      .frame(width: 300, height: 400)
      .preferredColorScheme(.dark)
  }
}
