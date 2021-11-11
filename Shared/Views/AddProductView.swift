//
//  AddProductView.swift
//  Orchard
//
//  Created by John Behnke on 11/10/21.
//

import SwiftUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var productName = ""

    @State var sendNotification = false
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
                TextField("", text: $productName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Divider()
            HStack {
                Text("Zip Code:")
                TextField("", text: $productName).frame(width: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Text("Send Notification")
                Toggle(isOn: $sendNotification, label: {})
            }
            
            Divider()
            HStack {
                Spacer()
                Button("Cancel", role: .cancel,  action: {
                    presentationMode.wrappedValue.dismiss()
                }).keyboardShortcut(.cancelAction)
                Button("OK", action: {}).disabled(true).keyboardShortcut(.defaultAction)
            }
            
            
            
            
        }
        .padding(20)
        .frame(width: 300, height: 250, alignment: .topLeading)
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}
