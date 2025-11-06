//
//  ScratchViewModel.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import Foundation
import CoreDomain

@MainActor
public class ScratchViewModel: ObservableObject {
  @Published public private(set) var isScratching = false
  private var task: Task<Void, Never>?
  private let getCodeUseCase: GetCodeScratchCardUseCase

  public init(getCodeUseCase: GetCodeScratchCardUseCase) {
    self.getCodeUseCase = getCodeUseCase
  }

  public func scratch() {
    guard !isScratching else { return }
    isScratching = true
    task = Task {
      do {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        await getCodeUseCase.execute()
      } catch { /* cancelled */ }
      isScratching = false
    }
  }

  public func onDisappear() {
    task?.cancel()
    task = nil
  } // MUST cancel per spec

}
