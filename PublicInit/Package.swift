// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "PublicInit",
  platforms: [.iOS(.v26), .macOS(.v26)],
  products: [
    .library(
      name: "PublicInit",
      targets: ["PublicInit"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
  ],
  targets: [
    .macro(
      name: "PublicInitMacros",
      dependencies: [
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        .product(name: "SwiftSyntax",          package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros",    package: "swift-syntax"),
        .product(name: "SwiftDiagnostics",     package: "swift-syntax"),      ]
    ),

    .target(name: "PublicInit", dependencies: ["PublicInitMacros"]),

    .testTarget(
      name: "PublicInitTests",
      dependencies: ["PublicInit"]
    ),
  ]
)
