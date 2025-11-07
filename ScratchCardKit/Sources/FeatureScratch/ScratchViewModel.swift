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

  @Published public private(set) var state: ScratchStatus = .notScratched
  private var task: Task<Void, Never>?
  private let getCodeUseCase: GetCodeScratchCardUseCase

  public init(getCodeUseCase: GetCodeScratchCardUseCase) {
    self.getCodeUseCase = getCodeUseCase
  }

  public func scratch() {
    guard state == .notScratched else { return }
    state = .scratching

    task = Task {
      do {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        await getCodeUseCase.execute()
        state = .scratched
      } catch {
        /* cancelled */
        state = .notScratched
      }
    }
  }

  public func onDisappear() {
    task?.cancel()
    task = nil
  } // MUST cancel per spec

}

public enum ScratchStatus: Equatable {
  case scratching
  case scratched
  case notScratched

  var toText: String {
    switch self {
    case .scratching: return "Scratching…"
    case .scratched: return "Scratched!"
    case .notScratched: return "Ready to scratch"
    }
  }

  var toButton: String {
    switch self {
    case .scratching: return "Working…"
    case .scratched: return "Done"
    case .notScratched: return "Scratch now"
    }
  }

  var toButtonEnable: Bool {
    return self == .notScratched
  }

  var toButtonDone: Bool {
    return self == .scratched
  }
}
