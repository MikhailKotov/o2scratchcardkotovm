//
//  ActivationView.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import DesignSystem
import SwiftUI

public struct ActivationView: View {
  @StateObject var viewModel: ActivationViewModel
  private let onBack: () -> Void

  public init(viewModel: ActivationViewModel, onBack: @escaping () -> Void) {
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
          Text(viewModel.isActivating ? "Activating…" : "Activate your card")
        }
        Button(viewModel.isActivating ? "Working…" : "Activate", action: viewModel.activate)
          .buttonStyle(PrimaryButtonStyle())
          .disabled(viewModel.isActivating)
      }
//      .padding()
      .alert("Activation failed", isPresented: $viewModel.showError) {
        Button("OK", role: .cancel) {}
      } message: { Text("We couldn't activate your card. Please try again.") }
      //    .appGradientBackground()
    }
    .padding()
  }
}
