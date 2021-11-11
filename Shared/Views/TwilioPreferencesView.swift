//
//  TwilioPreferencesView.swift
//  Orchard
//
//  Created by John Behnke on 11/10/21.
//

import SwiftUI

struct TwilioPreferencesView: View {
    @State var productName = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("Twilio Settings")
                .fontWeight(.bold)
            HStack {
                Text("Username: ")
                Spacer()
                TextField("", text: $productName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("API Key:")
                Spacer()
                SecureField("", text: $productName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Divider()
            HStack {
                Text("To:")
                Spacer()
                TextField("", text: $productName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Text("From:")
                Spacer()
                TextField("", text: $productName)
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
    }
}
