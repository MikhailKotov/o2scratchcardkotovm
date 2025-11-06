//
//  ActivationViewModel.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import CoreDomain
import Foundation

@MainActor
public final class ActivationViewModel: ObservableObject {
  @Published public private(set) var isActivating = false
  @Published public var showError = false
  private let activateCardUseCase: ActivateCodeScratchCardUseCase

  public init(activateCardUseCase: ActivateCodeScratchCardUseCase) {
    self.activateCardUseCase = activateCardUseCase
  }

  public func activate() {
    guard !isActivating else { return }
    isActivating = true
    Task {
      let result = await activateCardUseCase.execute()
      isActivating = false
      if case .fail = result { showError = true }
    }
  }
}
