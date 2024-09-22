//
//  View+Selectable.swift
//  Orchard
//
//  Created by John Behnke on 4/17/22.
//

import Foundation
import SwiftUI

extension View {
  @ViewBuilder func selectable(
    selection: Binding<Int>,
    tag: Int,
    shape: AnyShape,
    strokeTint: Color,
    stokeWidth: CGFloat,
    action: @escaping (() -> Void) = {}
  ) -> some View {
    self
      .if(selection.wrappedValue == tag) { view in
        view
          .overlay(shape.stroke(strokeTint, lineWidth: stokeWidth))
      }
      .onTapGesture {
        selection.wrappedValue = tag
        action()
      }
  }
}
