//
//  PrimaryButtonStyle.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
  public init() {}
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.vertical, 14).padding(.horizontal, 18)
      .frame(maxWidth: .infinity, minHeight: 44)
      .glassEffect(Glass.clear.interactive(), in: .rect(cornerRadius: 8.0))
      .contentShape(Rectangle())
    }
}
