import ProjectDescription

let base = SettingsDictionary()
  .automaticCodeSigning(devTeam: "B9YNE9L52C")
  .swiftVersion("5.3")
  .swiftCompilationMode(.wholemodule)

let ws = Workspace(
  name: "Ground",
  projects: [
    "App",
    "Kite",
  ],
  additionalFiles: [
    "README.md"
  ]
)
