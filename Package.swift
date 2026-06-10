// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "yowanai",
    platforms: [.macOS(.v26)],
    products: [
        .library(name: "YowanaiCore", targets: ["YowanaiCore"]),
        .executable(name: "YowanaiApp", targets: ["YowanaiApp"]),
    ],
    targets: [
        .target(name: "YowanaiCore"),
        .executableTarget(
            name: "YowanaiApp",
            dependencies: ["YowanaiCore"]
        ),
        .testTarget(
            name: "YowanaiCoreTests",
            dependencies: ["YowanaiCore"]
        ),
    ]
)
