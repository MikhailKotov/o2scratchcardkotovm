//
//  GetStateScratchCardUseCase.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

public struct GetStateScratchCardUseCase: Sendable {
  let repository: ScratchCardRepository
  public init(repo: ScratchCardRepository) {
    self.repository = repo
  }
  public func stream() -> AsyncStream<ScratchCardState> {
    repository.observe()
  }
}
