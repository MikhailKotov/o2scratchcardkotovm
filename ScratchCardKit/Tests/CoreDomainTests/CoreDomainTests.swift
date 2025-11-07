//
//  ActivateTests.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 07/11/2025.
//

import XCTest
@testable import CoreDomain

final class CoreDomainTests: XCTestCase {
  func test_success_when_version_gt_6_1() async {
    let repo = RepoFake(state: .scratched(code: "X"))
    let api = APIFake(version: "6.24")
    let uc = ActivateCodeScratchCardUseCase(repository: repo, api: api)
    let r = await uc.execute()
    XCTAssertEqual(r, .success)
    let s = await repo.state
    if case .activated(let c) = s { XCTAssertEqual(c, "X") } else { XCTFail() }
  }

  func test_success_when_version_gt_6_1_and_version_short() async {
    let repo = RepoFake(state: .scratched(code: "X"))
    let api = APIFake(version: "7")
    let uc = ActivateCodeScratchCardUseCase(repository: repo, api: api)
    let r = await uc.execute()
    XCTAssertEqual(r, .success)
    let s = await repo.state
    if case .activated(let c) = s { XCTAssertEqual(c, "X") } else { XCTFail() }
  }

  func test_success_when_version_gt_6_1_and_version_long() async {
    let repo = RepoFake(state: .scratched(code: "X"))
    let api = APIFake(version: "6.2.0")
    let uc = ActivateCodeScratchCardUseCase(repository: repo, api: api)
    let r = await uc.execute()
    XCTAssertEqual(r, .success)
    let s = await repo.state
    if case .activated(let c) = s { XCTAssertEqual(c, "X") } else { XCTFail() }
  }

  func test_fail_when_version_lt_6_1() async {
    let repo = RepoFake(state: .scratched(code: "X"))
    let api = APIFake(version: "6.0")
    let uc = ActivateCodeScratchCardUseCase(repository: repo, api: api)
    let r = await uc.execute()
    XCTAssertEqual(r, .fail)
    let s = await repo.state
    if case .scratched(let c) = s { XCTAssertEqual(c, "X") } else { XCTFail() }
  }

  func test_fail_when_version_lt_6_1_and_version_short() async {
    let repo = RepoFake(state: .scratched(code: "X"))
    let api = APIFake(version: "6")
    let uc = ActivateCodeScratchCardUseCase(repository: repo, api: api)
    let r = await uc.execute()
    XCTAssertEqual(r, .fail)
    let s = await repo.state
    if case .scratched(let c) = s { XCTAssertEqual(c, "X") } else { XCTFail() }
  }

  func test_fail_when_version_lt_6_1_and_version_long() async {
    let repo = RepoFake(state: .scratched(code: "X"))
    let api = APIFake(version: "6.0.9")
    let uc = ActivateCodeScratchCardUseCase(repository: repo, api: api)
    let r = await uc.execute()
    XCTAssertEqual(r, .fail)
    let s = await repo.state
    if case .scratched(let c) = s { XCTAssertEqual(c, "X") } else { XCTFail() }
  }
}
