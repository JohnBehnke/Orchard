//
//  AnyShape.swift
//  Orchard
//
//  Created by John Behnke on 4/17/22.
//

import Foundation
import SwiftUI

public struct AnyShape: Shape {
  public var make: (CGRect, inout Path) -> Void

  public init<S: Shape>(_ shape: S) {
    self.make = { rect, path in
      path = shape.path(in: rect)
    }
  }

  public func path(in rect: CGRect) -> Path {
    return Path { [make] in make(rect, &$0) }
  }
}
