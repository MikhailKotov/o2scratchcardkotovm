//
//  APIFake.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 07/11/2025.
//

@testable import CoreDomain

struct APIFake: API {
  let version: String
  func fetchIOSVersion(for code: String) async throws -> String {
    version
  }
}
