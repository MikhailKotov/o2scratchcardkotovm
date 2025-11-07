//
//  APIClient.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 03/11/2025.
//

import CoreDomain
import Foundation

public struct APIClient: API {
  let session: URLSession
  public init(session: URLSession = .shared) {
    self.session = session
  }

  public func fetchIOSVersion(for code: String) async throws -> String {
    // GET https://api.o2.sk/version?code=<code>
    var comps = URLComponents(string: "https://api.o2.sk/version")!
    comps.queryItems = [.init(name: "code", value: code)]
    let (data, _) = try await session.data(from: comps.url!)
    print(String(data: data, encoding: .utf8) ?? "<--- no data --->")
    let obj = try JSONDecoder().decode(Response.self, from: data)
    return obj.ios
  }

  private struct Response: Decodable {
    let ios: String
  }
}
