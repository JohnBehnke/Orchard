//
//  DebugSettingsView.swift
//  Orchard
//
//  Created by John Behnke on 3/13/22.
//

import SwiftUI

struct DebugSettingsView: View {
  var body: some View {
    VStack {
      Button(action:{
        do {
          let url = try ProductModel.fileURL()
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
      
      Button(action:{}, label: {
        Text("Clear all data")
      })
      
      Button(action:{}, label: {
        Text("Load Sample Data")
      })
      
      Button(action:{}, label: {
        Text("Force Store Check")
      })
    }
  }
}

struct DebugSettingsView_Previews: PreviewProvider {
    static var previews: some View {
      DebugSettingsView()
    }
}
