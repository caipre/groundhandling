import ProjectDescription

let setup = Setup([
  .homebrew(packages: ["swift-format", "swiftlint"]),
  .custom(name: "git hooks", meet: ["./hooks/install.sh"], isMet: ["./hooks/install.sh", "check"]),
])
