//
//  ScratchCardState.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

public protocol API: Sendable {
  func fetchIOSVersion(for code: String) async throws -> String
}
