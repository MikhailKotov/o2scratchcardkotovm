//
//  ScratchCardRepository.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

public protocol ScratchCardRepository: AnyObject, Sendable {
    var state: ScratchCardState { get async }
    func observe() -> AsyncStream<ScratchCardState>
    func setScratched(code: String) async
    func setActivated(code: String) async
    func reset() async
}
