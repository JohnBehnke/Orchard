//
//  TwilioPreferencesView.swift
//  Orchard
//
//  Created by John Behnke on 11/10/21.
//

import SwiftUI

struct TwilioPreferencesView: View {
  @State var username = ""
  @State var apiKey = ""
  // swiftlint:disable:next identifier_name
  @State var to = ""
  @State var from = ""
  @State var showSecureFieldInput: Bool = true
  var body: some View {
    VStack(alignment: .leading) {
      Text("Twilio Settings")
        .fontWeight(.bold)
      HStack {
        Text("Username: ")
        Spacer()
        TextField("", text: $username)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      HStack {
        Text("API Key:")
        Spacer()
        ZStack(alignment: .trailing) {
          if self.showSecureFieldInput {
            SecureField("", text: $apiKey)
              .textFieldStyle(RoundedBorderTextFieldStyle())
          } else {
            TextField("", text: $apiKey)
              .textFieldStyle(RoundedBorderTextFieldStyle())
          }
          Button(action: {self.showSecureFieldInput.toggle()}, label: {
            Image(systemName: self.showSecureFieldInput ? "eye.slash" : "eye")
          }).buttonStyle(.borderless).padding(.trailing)
        }

      }
      Divider()
      HStack {
        Text("To:")
        Spacer()
        TextField("", text: $to)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }

      HStack {
        Text("From:")
        Spacer()
        TextField("", text: $from)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }

    }
    .padding(20)
    .frame(minWidth: 400, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
  }
}

struct TwilioPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    TwilioPreferencesView()
      .preferredColorScheme(.light)
    TwilioPreferencesView()
      .preferredColorScheme(.dark)
  }
}
