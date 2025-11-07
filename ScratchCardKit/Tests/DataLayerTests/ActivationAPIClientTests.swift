//
//  ActivationAPIClientTests.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 07/11/2025.
//

import XCTest
@testable import DataLayer

final class APIClientTests: XCTestCase {

  override func setUp() {
    URLProtocol.registerClass(MockURLProtocol.self)
  }
  override func tearDown() {
    URLProtocol.unregisterClass(MockURLProtocol.self)
    MockURLProtocol.handlers.removeAll()
  }

  func test_buildsURL_withCodeQuery() async throws {
    let exp = expectation(description: "request captured")
    MockURLProtocol.handlers[.any] = { request in
      let comps = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
      XCTAssertEqual(comps.path, "/version")
      XCTAssertEqual(comps.queryItems?.first(where: { $0.name == "code" })?.value, "ABC-123")
      exp.fulfill()
      return (.ok, #"{"ios":"6.42"}"#.data(using: .utf8)!)
    }

    let client = APIClient(session: .mocked)
    _ = try await client.fetchIOSVersion(for: "ABC-123")
    await fulfillment(of: [exp], timeout: 1.0)
  }

  func test_decodes_iosVersion_success() async throws {
    MockURLProtocol.handlers[.any] = { _ in (.ok, Data(#"{"ios":"6.42","android":"1"}"#.utf8)) }
    let client = APIClient(session: .mocked)
    let v = try await client.fetchIOSVersion(for: "X")
    XCTAssertEqual(v, "6.42")
  }

  func test_invalidJSON_throws() async {
    MockURLProtocol.handlers[.any] = { _ in (.ok, Data(#"{"iosX":"6.42"}"#.utf8)) }
    let client = APIClient(session: .mocked)
    await XCTAssertThrowsErrorAsync {
      _ = try await client.fetchIOSVersion(for: "X")
    }
  }

  func test_httpError_throws() async {
    MockURLProtocol.handlers[.any] = { _ in (.status(500), Data()) }
    let client = APIClient(session: .mocked)
    await XCTAssertThrowsErrorAsync {
      _ = try await client.fetchIOSVersion(for: "X")
    }
  }
}

// MARK: - Test infra

private extension URLSession {
  static let mocked: URLSession = {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
  }()
}

private final class MockURLProtocol: URLProtocol {
  enum Key: Hashable { case any }
  nonisolated(unsafe) static var handlers: [Key: (URLRequest) -> (Response, Data)] = [:]

  enum Response { case ok, status(Int) }

  override class func canInit(with request: URLRequest) -> Bool { true }
  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

  override func startLoading() {
    let handler = Self.handlers[.any] ?? { _ in (.ok, Data()) }
    let (resp, data) = handler(request)
    let url = request.url!
    let http: HTTPURLResponse
    switch resp {
    case .ok:
      http = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    case .status(let code):
      http = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    client?.urlProtocol(self, didReceive: http, cacheStoragePolicy: .notAllowed)
    client?.urlProtocol(self, didLoad: data)
    client?.urlProtocolDidFinishLoading(self)
  }
  override func stopLoading() {}
}

private func XCTAssertThrowsErrorAsync(_ body: @escaping () async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async {
  do {
    try await body()
    XCTFail("Expected throw", file: file, line: line)
  }
  catch { /* ok */ }
}
