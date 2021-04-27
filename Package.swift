// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sdk-xyo-client-swift",
    platforms: [.macOS(.v10_15),
                .iOS(.v10),
                .tvOS(.v10),
                .watchOS(.v3)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "sdk-xyo-client-swift",
            targets: ["sdk-xyo-client-swift"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "sdk-xyo-client-swift",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "sdk-xyo-client-swiftTests",
            dependencies: ["sdk-xyo-client-swift"])
    ],
  swiftLanguageVersions: [.v5, .v4_2, .v4]
)
