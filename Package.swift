// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCTemplate",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "xctemplate", targets: ["CLI"]),
        .library(name: "XCTemplate", targets: ["XCTemplate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.1")
    ],
    targets: [
        .target(name: "XCTemplate", dependencies: []),
        .target(
            name: "CLI",
            dependencies: [
                "XCTemplate",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "XCTemplateTests",
            dependencies: ["XCTemplate"]
        ),
    ]
)
