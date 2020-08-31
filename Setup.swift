import ProjectDescription

let setup = Setup([
  .homebrew(packages: ["jq", "swift-format", "swiftlint"]),
  .custom(
    name: "git hooks",
    meet: ["./scripts/install-hooks.sh"],
    isMet: ["./scripts/install-hooks.sh", "check"]
  ),
  .custom(name: "rq", meet: ["./scripts/install-rq.sh"], isMet: ["which", "rq"]),
])
