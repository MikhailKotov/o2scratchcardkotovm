//
//  View+Ext.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import SwiftUI

public extension View {
  func announce(_ text: String) -> some View {
    accessibilityAddTraits(.isStaticText)
      .accessibilityHint(Text(text))
  }
}
