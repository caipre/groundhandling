import ProjectDescription

let base = SettingsDictionary()
  .automaticCodeSigning(devTeam: "B9YNE9L52C")
  .swiftVersion("5.3")
  .swiftCompilationMode(.wholemodule)

let project = Project(
  name: "Kite",
  settings: Settings(base: base),
  targets: [
    Target(
      name: "Kite",
      platform: .iOS,
      product: .framework,
      bundleId: "co.nickp.ground.kite",
      infoPlist: .default,
      sources: ["Sources/**"],
      resources: ["Resources/**"]
    ),
  ],
  additionalFiles: [
    "Project.swift",
    "README.md",
  ]
)
