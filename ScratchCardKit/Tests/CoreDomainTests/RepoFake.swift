//
//  RepoFake.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 07/11/2025.
//

@testable import CoreDomain

final class RepoFake: ScratchCardRepository, @unchecked Sendable {
    var _state: ScratchCardState
    init(state: ScratchCardState) { _state = state }
    var state: ScratchCardState { get async { _state } }
    func observe() -> AsyncStream<ScratchCardState> { AsyncStream { $0.yield(_state) } }
    func setScratched(code: String) async { _state = .scratched(code: code) }
    func setActivated(code: String) async { _state = .activated(code: code) }
    func reset() async { _state = .unscratched }
}
