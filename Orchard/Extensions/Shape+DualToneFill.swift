//
//  Shape+DualToneFill.swift
//  Orchard
//
//  Created by John Behnke on 4/17/22.
//

import Foundation
import SwiftUI

extension Circle {
  public func dualToneFill(left: Color, right: Color) -> some View {
    HStack(spacing: 0) {
      Rectangle().fill(left)
      Rectangle().fill(right)
    }.clipShape(Circle()).frame(width: 25, height: 25)
  }
}
