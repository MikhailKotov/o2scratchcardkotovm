// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ScratchCardKit",
  platforms: [.iOS(.v26)],
  products: [
    .library(name: "CoreDomain", targets: ["CoreDomain"]),
    .library(name: "DataLayer", targets: ["DataLayer"]),
    .library(name: "DesignSystem", targets: ["DesignSystem"]),
    .library(name: "FeatureMain", targets: ["FeatureMain"]),
    .library(name: "FeatureScratch", targets: ["FeatureScratch"]),
    .library(name: "FeatureActivation", targets: ["FeatureActivation"]),
    .library(name: "Shared", targets: ["Shared"]),
  ],
  dependencies: [
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: Version(0, 62, 0))
  ],
  targets: [
    .target(
      name: "CoreDomain",
      plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
    ),
    .testTarget(
      name: "CoreDomainTests",
      dependencies: ["CoreDomain"]
    ),
    .target(
      name: "DataLayer",
      dependencies: ["CoreDomain"],
      plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
    ),
    .testTarget(
      name: "DataLayerTests",
      dependencies: ["DataLayer", "CoreDomain"]
    ),
    .target(
      name: "DesignSystem",
      plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
    ),
    .target(
      name: "FeatureMain",
      dependencies: ["CoreDomain", "DesignSystem"],
      plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
    ),
    .testTarget(name: "FeatureMainTests", dependencies: ["FeatureMain", "CoreDomain"]),
    .target(
      name: "FeatureScratch",
      dependencies: ["CoreDomain", "DesignSystem"],
      plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
    ),
    .testTarget(name: "FeatureScratchTests", dependencies: ["FeatureScratch", "CoreDomain"]),
    .target(
      name: "FeatureActivation",
      dependencies: ["CoreDomain", "DesignSystem"],
      plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
    ),
    .testTarget(name: "FeatureActivationTests", dependencies: ["FeatureActivation", "CoreDomain"]),
    .target(name: "Shared"),
  ]
)
