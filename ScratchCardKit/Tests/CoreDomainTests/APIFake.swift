//
//  APIFake.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 07/11/2025.
//

@testable import CoreDomain

final class APIFake: API, @unchecked Sendable {
    let version: String?
    let error: Error?
    private(set) var callCount = 0

    init(version: String) { self.version = version; self.error = nil }
    init(error: Error) { self.version = nil; self.error = error }

    func fetchIOSVersion(for code: String) async throws -> String {
        callCount += 1
        if let e = error { throw e }
        return version ?? ""
    }
}
