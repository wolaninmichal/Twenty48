// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Storage",
    // macOS only so `swift test` runs on the host, without a simulator.
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "Storage", targets: ["Storage"]),
    ],
    dependencies: [
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "Storage", dependencies: [
                "Domain"
            ]
        ),
        .testTarget(
            name: "StorageTests", dependencies: [
                "Storage",
                "Domain",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
