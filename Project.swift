import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "BoilerplateIOS",
    settings: projectSettings,
    targets: [
        Target.core,
        Target.networking,
        Target.firebaseService
    ] + Environment.allCases.map { Target.app(for: $0) }
      + [Target.unitTests],
    schemes: Environment.allCases.map { Scheme.app(for: $0) }
)
