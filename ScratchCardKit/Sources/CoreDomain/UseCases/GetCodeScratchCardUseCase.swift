//
//  GetCodeScratchCardUseCase.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import Foundation

public struct GetCodeScratchCardUseCase: Sendable {
  private let repo: ScratchCardRepository
  public init(repo: ScratchCardRepository) {
    self.repo = repo
  }
  public func execute(generate: () -> String = { UUID().uuidString }) async {
    await repo.setScratched(code: generate())
  }
}
