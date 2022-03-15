//
//  StoreDetailView.swift
//  Orchard (macOS)
//
//  Created by John Behnke on 3/11/22.
//

import SwiftUI

struct StoreDetailView: View {
  @Environment(\.openURL) var openURL
  var store: Store
  var purchaseUrl: URL
  var body: some View {
    VStack {
      AsyncImage(
        url: URL(string: store.retailStore.secureStoreImageUrl)!,
        content: { image in
          image.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: 500, maxHeight: 300)
        },
        placeholder: {
          ProgressView()
        }
      ).clipShape(RoundedRectangle(cornerRadius: 5))
      Text(store.address.address)
      Text(String(format: "%.2f miles away", store.storedistance))
      HStack {
        HStack {
          Button(action: {
            let url = URL(string: "tel://\(store.phoneNumber)")
            openURL(url ?? URL(string: "tel://980-3331708")!)
          }, label: {Image(systemName: "phone")})
          Button(action: {
            let address = "\(store.address.address2), \(store.city), \(store.state) \(store.address.postalCode), \(store.country)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let url = URL(string: "maps://?address=\(address!)")
            openURL(url!)
          }, label: {Image(systemName: "map")})
          Button(action: {openURL((URL(string: store.reservationUrl) ?? URL(string: "https://apple.com/retail"))!)}, label: {Image(systemName: "info.circle")})
        }
      }
    }
  }
}

struct StoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
      StoreDetailView(store: Store.demoStore, purchaseUrl: URL(string: "https://apple.com")!)
        .frame(width: 500.0, height: 500.0)
    }
}
