// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "XyoClient",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v12),
    .tvOS(.v12),
    .watchOS(.v5),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "XyoClient",
      targets: ["XyoClient"])
  ],
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
    .package(url: "https://github.com/21-DOT-DEV/swift-secp256k1", "0.18.0"..."0.18.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(name: "keccak"),
    .target(
      name: "XyoClient",
      dependencies: [
        .product(name: "secp256k1", package: "swift-secp256k1"),
        "Alamofire",
        "keccak",
      ]
    ),
    .testTarget(
      name: "XyoClientTests",
      dependencies: ["XyoClient"]),
  ],
  swiftLanguageModes: [.v5, .v4_2]
)
