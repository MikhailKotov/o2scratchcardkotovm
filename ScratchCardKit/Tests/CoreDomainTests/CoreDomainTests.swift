//
//  ActivateTests.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 07/11/2025.
//

import XCTest
@testable import CoreDomain

final class ActivateScratchCardUseCaseTests: XCTestCase {

  // MARK: - Table-driven: разные форматы версии
  func test_activation_results_by_version_table() async {
    let cases: [(version: String, expectedSuccess: Bool)] = [
      ("6.24",  true),
      ("7",     true),
      ("6.2.0", true),
      ("6.1",   false),
      ("6.0",   false),
      ("6",     false),
      ("6.0.9", false),
      (" foo ", false),
    ]

    for (ver, shouldSucceed) in cases {
      let repo = RepoFake(state: .scratched(code: "X"))
      let api  = APIFake(version: ver)
      let sut  = ActivateCodeScratchCardUseCase(repository: repo, api: api)

      let result: ActivationResult = await sut.execute()

      if shouldSucceed {
        XCTAssertEqual(result, .success, "ver=\(ver)")
        await assertActivated(repo, code: "X", verDesc: ver)
      } else {
        XCTAssertEqual(result, .fail, "ver=\(ver)")
        await assertStillScratched(repo, code: "X", verDesc: ver)
      }
    }
  }

  // MARK: - Если карточка ещё не скретчнута — сразу fail, API не зовём
  func test_fails_without_scratched_code_and_does_not_call_api() async {
    let repo = RepoFake(state: .unscratched)
    let api  = APIFake(version: "999.0")
    let sut  = ActivateCodeScratchCardUseCase(repository: repo, api: api)

    let result = await sut.execute()

    XCTAssertEqual(result, .fail)
    XCTAssertEqual(api.callCount, 0, "API must be called with code")
    await assertState(repo, is: .unscratched)
  }

  // MARK: - Ошибка сети/парсинга -> fail, состояние не меняется
  func test_api_error_leads_to_fail_and_no_state_change() async {
    let repo = RepoFake(state: .scratched(code: "X"))
    let api  = APIFake(error: URLError(.badServerResponse))
    let sut  = ActivateCodeScratchCardUseCase(repository: repo, api: api)

    let result = await sut.execute()

    XCTAssertEqual(result, .fail)
    await assertStillScratched(repo, code: "X", verDesc: "api error")
  }

  // MARK: - Helpers

  private func assertActivated(_ repo: RepoFake, code: String, verDesc: String, line: UInt = #line) async {
    let s = await repo.state
    switch s {
    case .activated(let c): XCTAssertEqual(c, code, "ver=\(verDesc)", line: line)
    default: XCTFail("Expected .activated, got \(s)", line: line)
    }
  }

  private func assertStillScratched(_ repo: RepoFake, code: String, verDesc: String, line: UInt = #line) async {
    let s = await repo.state
    switch s {
    case .scratched(let c): XCTAssertEqual(c, code, "ver=\(verDesc)", line: line)
    default: XCTFail("Expected .scratched, got \(s)", line: line)
    }
  }

  private func assertState(_ repo: RepoFake, is expected: ScratchCardState, line: UInt = #line) async {
    let s = await repo.state
    XCTAssertEqual(s, expected, line: line)
  }
}
