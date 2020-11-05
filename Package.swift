// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "GroundPkg",
  platforms: [
    .iOS(.v10),
    .macOS(.v10_12),
    .tvOS(.v9),
  ],
  products: [
    .library(name: "KitePkg", targets: ["Kite"])
  ],
  dependencies: [
    .package(
      name: "Siesta",
      url: "https://github.com/bustoutsolutions/siesta/",
      .branch("bump-swift-package-version")
    )
  ],
  targets: [
    .target(
      name: "Kite",
      dependencies: ["Siesta"],
      path: "Kite/Sources",
      sources: ["Kite.swift"]
    )
  ]
)
