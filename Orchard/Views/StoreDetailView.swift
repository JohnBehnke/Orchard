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
  fileprivate func formatStorePhoneNumber(_ phoneNumber: String) -> (String, URL) {
    if let regex = try? NSRegularExpression(pattern: "([^0-9])") {
      let range = NSRange(location: 0, length: phoneNumber.count)
      let formattedPhoneNumber = regex.stringByReplacingMatches(in: phoneNumber, range: range, withTemplate: "")
      let phoneNumberUrl = URL(string: "tel://\(formattedPhoneNumber)")!
      return (phoneNumber, phoneNumberUrl)
    }
    return ("(800) 692–7753", URL(string: "tel://8006927753")!)
  }
  fileprivate func formatStoreAddress(_ address: Address) -> URL {
    // swiftlint:disable:next line_length
    let formattedAddress = "\(address.lineTwo), \(address.city), \(address.stateCode) \(address.postal), \(address.country)"
      .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    return URL(string: "maps://?address=\(formattedAddress!)")!
  }

  var body: some View {
    Spacer()
    ScrollView(showsIndicators: true) {
      VStack {
        Spacer()
        Spacer()
        Spacer()
        Spacer()
      }

      VStack {
        Text(store.information.name).font(.largeTitle)

        VStack {
          AsyncImage(
            url: URL(string: store.information.image)!,
            transaction: Transaction(animation: .spring())
          ) { phase in
            switch phase {
            case .empty:
              ZStack {
                Rectangle().frame(width: 400, height: 250).foregroundColor(.secondary).opacity(0.1)
                ProgressView()
              }

            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 400, maxHeight: 250)

            case .failure:
              Image(systemName: "exclamationmark.icloud")
                .resizable()
                .scaledToFit()

            @unknown default:
              Image(systemName: "exclamationmark.icloud")
            }
          }.clipShape(RoundedRectangle(cornerRadius: 5))
          VStack {
            VStack(alignment: .center) {
              Link(destination: formatStoreAddress(store.address), label: {
                VStack {
                  Text(store.address.lineTwo)
                  Text("\(store.address.city), \(store.address.stateCode) \(store.address.postal)")
                }
              }).foregroundColor(.accentColor)
              Spacer()
              Link(
                formatStorePhoneNumber(store.information.phoneNumber).0,
                destination: formatStorePhoneNumber(store.information.phoneNumber).1
              ).foregroundColor(.accentColor)
            }
          }.padding()
          Divider()
          HStack(alignment: .top) {
            VStack(alignment: .center) {
              Text("Store Hours").font(.title).padding(.bottom, 5)
              Spacer()
              HStack {
                Spacer()
                VStack(alignment: .leading) {
                  ForEach(store.schedule.days, id: \.self) { day in
                    Text(day.shortName)
                      .if(day.shortName == "Today") { text in
                        text.bold()
                      }.padding(.bottom, 0.5)
                  }
                }
                Spacer().frame(width: 50)
                VStack(alignment: .leading) {
                  ForEach(store.schedule.days, id: \.self) { day in
                    Text(day.formattedDate)
                      .if(day.shortName == "Today") { text in
                        text.bold()
                      }.padding(.bottom, 0.5)
                  }
                }
                Spacer().frame(width: 50)
                VStack(alignment: .trailing) {
                  ForEach(store.schedule.days, id: \.self) { day in
                    Text(day.formattedTime)
                      .if(day.shortName == "Today") { text in
                        text.bold()
                      }.padding(.bottom, 0.5)

                  }
                }
                Spacer()
              }
              Spacer()

            }
          }.padding()

          HStack {
            Spacer()
            VStack {
              Text(store.information.messageTitle)
                .font(.headline).padding(.bottom, 5)
              Text(store.information.message).font(.subheadline)
            }.padding().background(RoundedRectangle(cornerRadius: 5).foregroundColor(.secondary).opacity(0.1))
            Spacer()
          }

        }.padding(25)
      }
      VStack {
        Spacer()
        Spacer()
        Spacer()
        Spacer()
      }
    }
    //    .task {
    //      storeDetails = await AppleStoreAPI().performSearch(storeName: store.storeName)
    //    }
  }
}

// struct StoreDetailView_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//      StoreDetailView(store: Store.demoStore, purchaseUrl: URL(string: "https://apple.com")!)
//        .preferredColorScheme(.light)
//        .frame(width: 450.0, height: 800)
//      StoreDetailView(store: Store.demoStore, purchaseUrl: URL(string: "https://apple.com")!)
//        .preferredColorScheme(.dark)
//        .frame(width: 500, height: 600)
//    }
//  }
// }

extension View {
  @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
