// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fsnotes2obsidian",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .executable(name: "fsnotes2obsidian", targets: ["fsnotes2obsidian"]),
        .library(name: "fsnotes2obsidianCore", targets: ["fsnotes2obsidianCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.3")),
        .package(url: "https://github.com/mxcl/Path.swift.git", .upToNextMinor(from: "1.2.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "fsnotes2obsidian",
            dependencies: [
                "fsnotes2obsidianCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Path", package: "Path.swift"),
            ]),
        .target(
            name: "fsnotes2obsidianCore",
            dependencies: [
                .product(name: "Path", package: "Path.swift"),
            ]),
        .testTarget(
            name: "fsnotes2obsidianTests",
            dependencies: ["fsnotes2obsidian"]),
    ]
)
