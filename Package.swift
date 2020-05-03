// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCTemplate",
    platforms: [
        .macOS(.v10_14),
    ],
    products: [
        .executable(name: "xctemplate", targets: ["XCTemplate"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.5")
    ],
    targets: [
        .target(
            name: "XCTemplate",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "XCTemplateTests",
            dependencies: ["XCTemplate"]
        ),
    ]
)
