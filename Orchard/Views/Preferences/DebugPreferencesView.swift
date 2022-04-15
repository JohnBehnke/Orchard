//
//  DebugPreferencesView.swift
//  Orchard
//
//  Created by John Behnke on 3/13/22.
//

import SwiftUI
import ContactsUI
import AddressBook
import Contacts

struct DebugPreferencesView: View {
  @EnvironmentObject var storeAPI: StoreAPI
  @EnvironmentObject var productStore: ProductStore
  var body: some View {
    VStack {
      Button(action: {
        do {
          let url = try ProductStore.fileURL()
          if url.hasDirectoryPath {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
          } else {
            NSWorkspace.shared.activateFileViewerSelecting([url])
          }
        } catch {
          return
        }
      }, label: {
        Text("Open Finder to Data File")
      })

      Button(action: {}, label: {
        Text("Clear all data")
      })

      Button(action: {}, label: {
        Text("Load Sample Data")
      })

      Button(action: {
        Task {
          for product in self.productStore.products {
            await self.storeAPI.performSearch(for: product.modelNumber, near: product.searchPostalCode)
          }
        }
      }, label: {
        Text("Force Store Check")
      })

      Button(action: {

        do {
          let contact = CNMutableContact()

          let tiff = NSImage(named: NSImage.Name("OrchardContactImage"))?
            .cgImage(forProposedRect: nil, context: nil, hints: nil)
          let foo = NSBitmapImageRep(cgImage: tiff!)
          let fileData = foo.representation(using: .jpeg, properties: [:])

          contact.givenName = "Orchard Test"

          contact.imageData = fileData
          contact.phoneNumbers = [CNLabeledValue(
            label: CNLabelPhoneNumberiPhone,
            value: CNPhoneNumber(stringValue: "(980) 333-1708"))]

          let data = try CNContactVCardSerialization.data(jpegPhotoContacts: [contact])

          //

          let savePanel = NSSavePanel()
          //              savePanel.allowedFileTypes = ["vcf"]
          savePanel.allowedContentTypes = [.vCard]
          savePanel.canCreateDirectories = true
          savePanel.isExtensionHidden = false
          savePanel.allowsOtherFileTypes = false
          savePanel.title = "Save your text"
          savePanel.message = "Choose a folder and a name to store your text."
          savePanel.nameFieldLabel = "File name:"
          _ = savePanel.runModal()

          try data.write(to: savePanel.url!, options: [.atomicWrite])
        } catch {
          print(error)
        }

        // Saving the newly created contact

      }, label: {
        Text("Create Contact vCard")
      })
    }
  }
}

struct DebugPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    DebugPreferencesView()
      .frame(width: 400, height: 400)
      .preferredColorScheme(.light)
    DebugPreferencesView()
      .frame(width: 400, height: 400)
      .preferredColorScheme(.dark)
  }
}

extension CNContactVCardSerialization {
  internal class func vcardDataAppendingPhoto(vcard: Data, photoAsBase64String photo: String) -> Data? {
    let vcardAsString = String(data: vcard, encoding: .utf8)
    let vcardPhoto = "PHOTO;TYPE=JPEG;ENCODING=BASE64:".appending(photo)
    let vcardPhotoThenEnd = vcardPhoto.appending("\nEND:VCARD")
    if let vcardPhotoAppended = vcardAsString?.replacingOccurrences(of: "END:VCARD", with: vcardPhotoThenEnd) {
      return vcardPhotoAppended.data(using: .utf8)
    }
    return nil

  }
  class func data(jpegPhotoContacts: [CNContact]) throws -> Data {
    var overallData = Data()
    for contact in jpegPhotoContacts {
      let data = try CNContactVCardSerialization.data(with: [contact])
      if contact.imageDataAvailable {
        if let base64imageString = contact.imageData?.base64EncodedString(),
           let updatedData = vcardDataAppendingPhoto(vcard: data, photoAsBase64String: base64imageString) {
          overallData.append(updatedData)
        }
      } else {
        overallData.append(data)
      }
    }
    return overallData
  }
}
