//
//  MainView.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import SwiftUI
import DesignSystem

public struct MainView: View {
  @StateObject var viewModel: MainViewModel

  private let onScratch: () -> Void
  private let onActivate: () -> Void

  public init(
    viewModel: MainViewModel,
    onScratch: @escaping () -> Void,
    onActivate: @escaping () -> Void
  ) {
    self._viewModel = StateObject(wrappedValue: viewModel)
    self.onScratch = onScratch
    self.onActivate = onActivate
  }

  public var body: some View {
    GlassCard {
      VStack(spacing: 16) {
        Text(viewModel.statusText).font(.title2).multilineTextAlignment(.center)
        Button("Scratch card", action: onScratch)
          .buttonStyle(PrimaryButtonStyle())
          .accessibilityLabel("Scratch the card. Takes about two seconds.")
        Button("Activate card", action: onActivate)
          .buttonStyle(PrimaryButtonStyle())
          .accessibilityLabel("Activate the card using network request.")
      }
    }
    .padding()
    .task {
      viewModel.start()
    }
  }
}
