import ProjectDescription

let base = SettingsDictionary()
  .automaticCodeSigning(devTeam: "B9YNE9L52C")
  .swiftVersion("5.3")
  .swiftCompilationMode(.wholemodule)

let infop: InfoPlist = .extendingDefault(with: [
  "UILaunchStoryboardName": "LaunchScreen",
  "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
  "UIApplicationSceneManifest": [
    "UIApplicationSupportsMultipleScenes": false,
    "UISceneConfigurations": [
      "UIWindowSceneSessionRoleApplication": [
        [
          "UISceneConfigurationName": "Default Configuration",
          "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
        ]
      ]
    ],
  ],
])

let project = Project(
  name: "App",
  packages: [
    .package(url: "https://github.com/square/Cleanse", from: "4.2.5"),
  ],
  settings: Settings(base: base),
  targets: [
    Target(
      name: "App",
      platform: .iOS,
      product: .app,
      bundleId: "co.nickp.ground",
      infoPlist: infop,
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .package(product: "Cleanse"),
        .project(target: "Kite", path: "../Kite")
      ]
    ),
  ],
  additionalFiles: [
    "Project.swift",
    "README.md",
  ]
)
