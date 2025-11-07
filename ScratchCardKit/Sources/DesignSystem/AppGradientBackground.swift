//
//  AppGradientBackground.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 06/11/2025.
//
import SwiftUI

struct AppGradientBackground: ViewModifier {
  func body(content: Content) -> some View {
    ZStack {
      LinearGradient(
        colors: [O2Color.primaryBlue, O2Color.secondaryBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()
      content
    }
  }
}

public extension View {
  func appGradientBackground() -> some View {
    modifier(AppGradientBackground())
  }
}
