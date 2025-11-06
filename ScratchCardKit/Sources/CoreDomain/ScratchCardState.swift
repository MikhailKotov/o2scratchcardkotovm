//
//  ScratchCardState.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

public enum ScratchCardState: Equatable, Sendable {
    case unscratched
    case scratched(code: String)
    case activated(code: String)
}
