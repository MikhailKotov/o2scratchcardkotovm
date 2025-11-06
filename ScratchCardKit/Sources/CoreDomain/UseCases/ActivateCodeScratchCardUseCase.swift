//
//  ActivateCodeScratchCardUseCase.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

public struct ActivateCodeScratchCardUseCase: Sendable {
  private let repository: ScratchCardRepository
  private let api: API

  public init(repository: ScratchCardRepository, api: API) {
    self.repository = repository
    self.api = api
  }

  public func execute() async -> ActivationResult {
    let current = await repository.state
    guard case let .scratched(code) = current else { return .fail }
    do {
      let receivedVersion = try await api.fetchIOSVersion(for: code)
      if receivedVersion.isGreaterVersionThan("6.1") {
        await repository.setActivated(code: code)
        return .success
      } else {
        return .fail
      }
    } catch { return .fail }
  }
}

private extension String {
  func isGreaterVersionThan(_ versionB: String) -> Bool {
    func parse(_ str: String) -> (Int, Int) {
      let parts = str.split(separator: ".").map { Int($0) ?? 0 }
      return (parts.first ?? 0, parts.dropFirst().first ?? 0)
    }
    let (amaj, amin) = parse(self)
    let (bmaj, bmin) = parse(versionB)
    return (amaj, amin) > (bmaj, bmin)
  }
}
