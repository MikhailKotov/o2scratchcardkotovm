//
//  ScratchCardRepositoryImpl.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import Foundation
import CoreDomain

public final class ScratchCardRepositoryImpl: ScratchCardRepository, @unchecked Sendable {
  private let lock = NSLock()
  private var _state: ScratchCardState = .unscratched
  private var continuations: [AsyncStream<ScratchCardState>.Continuation] = []

  public init() {}

  public var state: ScratchCardState {
    get async { lock.with { _state } }
  }

  public func observe() -> AsyncStream<ScratchCardState> {
    AsyncStream { cont in
      lock.with {
        cont.yield(_state)
        continuations.append(cont)
      }
      cont.onTermination = { [weak self] _ in
        self?.lock.with {
          self?.continuations.removeAll { $0.id == cont.id }
        }
      }
    }
  }

  public func setScratched(code: String) async { update(.scratched(code: code)) }
  public func setActivated(code: String) async { update(.activated(code: code)) }
  public func reset() async { update(.unscratched) }

  private func update(_ new: ScratchCardState) {
    let listeners: [AsyncStream<ScratchCardState>.Continuation] = lock.with {
      _state = new
      return continuations
    }
    // вызывать yield вне lock — чтобы не держать мьютекс на пользовательском коде
    listeners.forEach { $0.yield(new) }
  }
}

private extension NSLock {
  func with<T>(_ body: () -> T) -> T { lock(); defer { unlock() }; return body() }
}
private extension AsyncStream.Continuation where Element == ScratchCardState {
  var id: ObjectIdentifier { ObjectIdentifier(self as AnyObject) }
}
