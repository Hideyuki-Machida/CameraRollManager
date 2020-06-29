// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CameraRollManager",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "CameraRollManager",
            targets: ["CameraRollManager"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Hideyuki-Machida/MetalCanvas", .branch("spm"))
    ],
    targets: [
        .target(
            name: "CameraRollManager",
            dependencies: ["MetalCanvas"]),
        .testTarget(
            name: "CameraRollManagerTests",
            dependencies: ["CameraRollManager"]),
    ]
)
