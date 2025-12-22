import ProjectDescription

public extension Scheme {
    static func app(for environment: Environment) -> Scheme {
        return .scheme(
            name: environment.targetName,
            shared: true,
            buildAction: .buildAction(
                targets: [.target(environment.targetName)]
            ),
            testAction: .targets(
                [.testableTarget(target: .target("BoilerplateIOSTests"))],
                configuration: environment.configurationName,
                options: .options(coverage: true)
            ),
            runAction: .runAction(
                configuration: environment.configurationName,
                arguments: .arguments(
                    environmentVariables: [
                        "ENVIRONMENT": .environmentVariable(value: environment.rawValue, isEnabled: true)
                    ]
                )
            ),
            archiveAction: .archiveAction(
                configuration: .release
            ),
            profileAction: .profileAction(
                configuration: .release
            ),
            analyzeAction: .analyzeAction(
                configuration: environment.configurationName
            )
        )
    }
}
