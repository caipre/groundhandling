import ProjectDescription

let base = SettingsDictionary()
  .automaticCodeSigning(devTeam: "B9YNE9L52C")
  .swiftVersion("5.3")
  .swiftCompilationMode(.wholemodule)

let infop: InfoPlist = .extendingDefault(with: [
  "UILaunchStoryboardName": "LaunchScreen",
  "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
  "UIAppFonts": [
    "Oxygen-Regularttf", "Oxygen-Light.ttf", "Oxygen-Bold.ttf",
    "Overpass-Regular.ttf", "Overpass-SemiBold.ttf", "Overpass-Bold.ttf",
  ],
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
  name: "Ground",
  packages: [
    .package(url: "https://github.com/square/Cleanse", from: "4.2.5"),
    .package(url: "https://github.com/tbaranes/SwiftyUtils", from: "5.3.0"),
  ],
  settings: Settings(base: base),
  targets: [
    Target(
      name: "App",
      platform: .iOS,
      product: .app,
      bundleId: "co.nickp.ground",
      infoPlist: infop,
      sources: ["App/Sources/**"],
      resources: ["App/Resources/**"],
      dependencies: [
        .package(product: "Cleanse"),
        .package(product: "SwiftyUtils"),
      ]
    )
  ],
  additionalFiles: [
    "Project.swift",
    "README.md",
  ]
)
