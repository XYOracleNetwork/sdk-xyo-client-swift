// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "XyoClient",
    platforms: [
        .macOS(.v12),
        .iOS(.v13),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "XyoClient",
            targets: ["XyoClient"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/21-DOT-DEV/swift-secp256k1", .upToNextMinor(from: "0.18.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
    ],
    targets: [
        .target(name: "keccak"),
        .target(
            name: "XyoClient",
            dependencies: [
                .product(name: "secp256k1", package: "swift-secp256k1"),
                "Alamofire",
                "keccak",
            ],
            resources: [
                .process("Model.xcdatamodeld")
            ],
            plugins: [
                .plugin(name: "CoreDataModelGenerator")
            ]
        ),
        .plugin(
            name: "CoreDataModelGenerator",
            capability: .buildTool(),
            dependencies: []
        ),
        .testTarget(
            name: "XyoClientTests",
            dependencies: ["XyoClient"]),
    ],
    
    swiftLanguageModes: [.v5, .v4_2]
)
