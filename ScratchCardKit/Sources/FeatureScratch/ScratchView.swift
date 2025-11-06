//
//  ScratchView.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import DesignSystem
import SwiftUI

public struct ScratchView: View {
  @StateObject var viewModel: ScratchViewModel
  private let onBack: () -> Void

  public init(viewModel: ScratchViewModel, onBack: @escaping () -> Void) {
    self._viewModel = StateObject(wrappedValue: viewModel)
    self.onBack = onBack
  }

  public var body: some View {
    GlassCard {
      VStack(spacing: 16) {
        ZStack {
          Button(action: onBack) {
            Image(systemName: "chevron.left")
              .frame(width: 44, height: 44)
              .font(.title)
              .glassEffect()
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          Text(viewModel.isScratching ? "Scratching…" : "Ready to scratch")
        }
        Button(viewModel.isScratching ? "Working…" : "Scratch now") { viewModel.scratch() }
          .buttonStyle(PrimaryButtonStyle())
          .disabled(viewModel.isScratching)
          .accessibilityHint("Operation can be cancelled by leaving the screen.")
      }
//      .padding()
      .onDisappear { viewModel.onDisappear() }
      .sensoryFeedback(.success, trigger: !viewModel.isScratching)
    }
    .padding()
//    .appGradientBackground()
  }
}
