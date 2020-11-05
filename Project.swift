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
  name: "Ground",
  packages: [
    .package(path: "Siesta"),
    .package(url: "https://github.com/Quick/Nimble", from: "8.0.0"),
    .package(url: "https://github.com/Quick/Quick", from: "3.0.0"),
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
      sources: ["App/Sources/**"],
      resources: ["App/Resources/**"],
      dependencies: [
        .package(product: "Cleanse"),
        .target(name: "Kite"),
        .target(name: "OpenWeather"),
      ]
    ),

    Target(
      name: "Kite",
      platform: .iOS,
      product: .framework,
      bundleId: "co.nickp.ground.kite",
      infoPlist: .default,
      sources: ["Kite/Sources/**"],
      resources: ["Kite/Resources/**"]
    ),

    Target(
      name: "OpenWeather",
      platform: .iOS,
      product: .framework,
      bundleId: "co.nickp.ground.openweather",
      infoPlist: .default,
      sources: ["OpenWeather/Sources/**"],
      resources: ["OpenWeather/Resources/**"],
      dependencies: [
        .package(product: "Siesta")
      ]
    ),

    Target(
      name: "OpenWeatherTests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "co.nickp.ground.openweather.tests",
      infoPlist: .default,
      sources: ["OpenWeather/Tests/**"],
      resources: ["OpenWeather/TestResources/**"],
      dependencies: [
        .package(product: "Nimble"),
        .package(product: "Quick"),
        .target(name: "OpenWeather"),
      ]
    ),
  ],
  additionalFiles: [
    "**/README.md",
    "Project.swift",
  ]
)
