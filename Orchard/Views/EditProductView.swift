//
//  EditProductView.swift
//  Orchard (macOS)
//
//  Created by John Behnke on 3/10/22.
//

import SwiftUI

struct EditProductView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var products: ProductStore
  @Binding var product: TrackedProduct

  var body: some View {
    VStack(alignment: .leading) {
      Text("Edit Product")
        .fontWeight(.bold)
      HStack {
        Text("Name:")
        Spacer()
        TextField("", text: $product.name)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      HStack {
        Text("Model Number:")
        Spacer()
        TextField("", text: $product.modelNumber)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      HStack {
        Text("Store URL:")
        Spacer()
        TextField("", text: $product.purchaseURL)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      Divider()
      HStack {
        Text("Zip Code:")
        TextField("", text: $product.searchPostalCode).frame(width: 80)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      HStack {
        Text("Send Notification")
        Toggle(isOn: $product.shouldSendNotification, label: {})
      }
      Divider()
      HStack {
        Spacer()
        Button("Cancel", role: .cancel, action: {
          presentationMode.wrappedValue.dismiss()
        }).keyboardShortcut(.cancelAction)
        Button("OK", action: {
          products.updateProduct(product: product)
          presentationMode.wrappedValue.dismiss()

        }).disabled(false).keyboardShortcut(.defaultAction)
      }
    }
    .padding(20)
    .frame(width: 300, height: 250, alignment: .topLeading)
  }
}
//
// struct EditProductView_Previews: PreviewProvider {
//    static var previews: some View {
//      EditProductView(product: Product)
//    }
// }

func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
