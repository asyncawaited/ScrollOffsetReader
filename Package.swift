// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScrollOffsetReader",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
    ],
    products: [
        .library(name: "ScrollOffsetReader", targets: ["ScrollOffsetReader"]),
        .executable(name: "ScrollOffsetExample", targets: ["ScrollOffsetExample"]),
    ],
    targets: [
        .target(
            name: "ScrollOffsetReader",
            path: "Sources/ScrollOffsetReader"
        ),
        .executableTarget(
            name: "ScrollOffsetExample",
            dependencies: ["ScrollOffsetReader"],
            path: "Sources/Example"
        ),
        .testTarget(
            name: "ScrollOffsetReaderTests",
            dependencies: ["ScrollOffsetReader"],
            path: "Tests/ScrollOffsetReaderTests"
        ),
    ]
)
