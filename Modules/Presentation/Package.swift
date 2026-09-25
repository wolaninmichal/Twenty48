// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Presentation", targets: ["Presentation"])
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../DesignSystem"),
        .package(path: "../Navigation"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.9.0"),
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: [
                "Domain",
                "DesignSystem",
                "Navigation",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
