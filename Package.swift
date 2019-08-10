// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BetterSheet",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "BetterSheet", targets: ["BetterSheet"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "BetterSheet", dependencies: []),
        .testTarget(name: "BetterSheetTests", dependencies: ["BetterSheet"]),
    ]
)
