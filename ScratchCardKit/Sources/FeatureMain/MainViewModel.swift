//
//  MainViewModel.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import CoreDomain
import Foundation

@MainActor
public class MainViewModel: ObservableObject {

  @Published public private(set) var statusText = "Not scratched"
  private let observe: GetStateScratchCardUseCase
  public init(observe: GetStateScratchCardUseCase) {
    self.observe = observe
  }

  public func start() {
      Task { for await state in observe.stream() { map(state) } }
  }

  private func map(_ state: ScratchCardState) {
      switch state {
      case .unscratched: statusText = "Not scratched"
      case .scratched(let code): statusText = "Scratched • \(code)"
      case .activated(let code): statusText = "Activated • \(code)"
      }
  }
}
