//
//  RootView.swift
//  o2scratchcardkotovm
//
//  Created by Mykhailo Kotov on 04/11/2025.
//

import SwiftUI
import CoreDomain
import DataLayer
import DesignSystem
import FeatureActivation
import FeatureMain
import FeatureScratch

struct RootView: View {

  private enum Route: Hashable {
    case main
    case scratch
    case activate
  }

  @Namespace private var ns
  @State private var route: Route = .main
  private let container = AppContainer()

  var body: some View {
    ZStack {
      switch route {
      case .main:
        MainView (
          viewModel: MainViewModel(observe: container.observe),
          onScratch: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
              route = .scratch
            }
          },
          onActivate: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            route = .activate
          }}
        )
        .zIndex(1)

      case .scratch:
        ScratchView(
          viewModel: ScratchViewModel(getCodeUseCase: container.generate),
          onBack: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
              route = .main
            }
          })
          .zIndex(2)

      case .activate:
        ActivationView(
          viewModel: ActivationViewModel(activateCardUseCase: container.activate),
          onBack: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
              route = .main
            }
          })
        .zIndex(2)
      }
    }
  }
}


#Preview {
  RootView()
    .appGradientBackground()
}
