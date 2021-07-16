// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCResource",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "xcresource", targets: ["CLI"]),
        .library(name: "XCResource", targets: ["XCResource"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.1")
    ],
    targets: [
        .target(name: "XCResource", dependencies: []),
        .target(
            name: "CLI",
            dependencies: [
                "XCResource",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "XCResourceTests",
            dependencies: ["XCResource"]
        ),
    ]
)
