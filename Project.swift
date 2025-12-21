import ProjectDescription

// MARK: - Environment Enum

enum Environment: String, CaseIterable {
    case develop = "Develop"
    case staging = "Staging"
    case sandbox = "Sandbox"
    case production = "Production"
    
    var xcconfig: Path {
        return .relativeToRoot("Configurations/XCConfig/\(rawValue).xcconfig")
    }
    
    var bundleId: String {
        switch self {
        case .develop:
            return "com.tt.studio.boilerplate-ios.develop"
        case .staging:
            return "com.tt.studio.boilerplate-ios.staging"
        case .sandbox:
            return "com.tt.studio.boilerplate-ios.sandbox"
        case .production:
            return "com.tt.studio.boilerplate-ios"
        }
    }
    
    var appName: String {
        switch self {
        case .develop:
            return "Boilerplate Dev"
        case .staging:
            return "Boilerplate Stg"
        case .sandbox:
            return "Boilerplate Sbx"
        case .production:
            return "Boilerplate"
        }
    }
    
    var targetName: String {
        return "BoilerplateIOS-\(rawValue)"
    }
    
    /// Use Debug for dev environments, Release for production-like
    var isDebugVariant: Bool {
        switch self {
        case .develop, .staging:
            return true
        case .sandbox, .production:
            return false
        }
    }
    
    var configurationName: ConfigurationName {
        return isDebugVariant ? .debug : .release
    }
}

// MARK: - Configurations

let configurations: [Configuration] = [
    .debug(name: .debug),
    .release(name: .release),
]

// MARK: - Firebase Copy Script

func makeFirebaseCopyScript(for environment: Environment) -> TargetScript {
    return .post(
        script: """
        # Copy the correct GoogleService-Info.plist for \(environment.rawValue)
        FIREBASE_DIR="${SRCROOT}/Configurations/Firebase"
        GOOGLE_SERVICE_INFO_PLIST="${FIREBASE_DIR}/\(environment.rawValue)/GoogleService-Info.plist"
        DESTINATION="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

        if [ -f "${GOOGLE_SERVICE_INFO_PLIST}" ]; then
            echo "Copying GoogleService-Info.plist for \(environment.rawValue) environment"
            cp "${GOOGLE_SERVICE_INFO_PLIST}" "${DESTINATION}"
        else
            echo "warning: GoogleService-Info.plist not found at ${GOOGLE_SERVICE_INFO_PLIST}"
        fi
        """,
        name: "Copy Firebase Configuration",
        basedOnDependencyAnalysis: false
    )
}

// MARK: - Project Settings

let projectSettings: Settings = .settings(
    base: [
        "CLANG_ENABLE_MODULES": "YES",
        "SWIFT_OBJC_INTERFACE_HEADER_NAME": "$(SWIFT_MODULE_NAME)-Swift.h",
    ],
    configurations: configurations
)

// MARK: - Core Target

let coreTarget: Target = .target(
    name: "Core",
    destinations: [.iPhone, .iPad],
    product: .framework,
    bundleId: "com.tt.studio.core",
    deploymentTargets: .iOS("15.0"),
    infoPlist: .default,
    sources: [
        .glob("Modules/Core/Sources/**/*.swift")
    ],
    dependencies: [],
    settings: .settings(
        base: [
            "DEFINES_MODULE": "YES",
            "PRODUCT_MODULE_NAME": "Core",
            "CLANG_ENABLE_MODULES": "YES",
        ],
        configurations: configurations
    )
)

// MARK: - Networking Target

let networkingTarget: Target = .target(
    name: "Networking",
    destinations: [.iPhone, .iPad],
    product: .framework,
    bundleId: "com.tt.studio.networking",
    deploymentTargets: .iOS("15.0"),
    infoPlist: .default,
    sources: [
        .glob("Modules/Networking/Sources/**/*.swift")
    ],
    dependencies: [
        .external(name: "Alamofire")
    ],
    settings: .settings(
        base: [
            "DEFINES_MODULE": "YES",
            "PRODUCT_MODULE_NAME": "Networking",
            "CLANG_ENABLE_MODULES": "YES",
        ],
        configurations: configurations
    )
)

// MARK: - FirebaseService Target

let firebaseServiceTarget: Target = .target(
    name: "FirebaseService",
    destinations: [.iPhone, .iPad],
    product: .framework,
    bundleId: "com.tt.studio.firebaseservice",
    deploymentTargets: .iOS("15.0"),
    infoPlist: .default,
    sources: [
        .glob("Modules/FirebaseService/Sources/**/*.swift")
    ],
    dependencies: [
        .target(name: "Core"),
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseCrashlytics"),
        .external(name: "FirebaseMessaging"),
        .external(name: "FirebaseStorage"),
        .external(name: "FirebaseAuth"),
    ],
    settings: .settings(
        base: [
            "DEFINES_MODULE": "YES",
            "PRODUCT_MODULE_NAME": "FirebaseService",
            "CLANG_ENABLE_MODULES": "YES",
            "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES": "YES",
            "OTHER_LDFLAGS": "$(inherited) -ObjC",
        ],
        configurations: configurations
    )
)

// MARK: - App Targets (one per environment)

func makeAppTarget(for environment: Environment) -> Target {
    let envConfigurations: [Configuration] = [
        .debug(
            name: .debug,
            xcconfig: environment.xcconfig
        ),
        .release(
            name: .release,
            xcconfig: environment.xcconfig
        ),
    ]
    
    let infoPlist: InfoPlist = .extendingDefault(
        with: [
            "UILaunchScreen": [
                "UIColorName": "",
                "UIImageName": "",
            ],
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        [
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ]
                    ]
                ]
            ],
            "CFBundleDisplayName": .string(environment.appName),
            "CFBundleName": .string(environment.appName),
            "ENVIRONMENT": .string(environment.rawValue),
            "API_BASE_URL": "$(API_BASE_URL)",
        ]
    )
    
    let settings: Settings = .settings(
        base: [
            "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: environment.bundleId),
            "PRODUCT_NAME": SettingValue(stringLiteral: environment.appName),
            "INFOPLIST_KEY_CFBundleDisplayName": SettingValue(stringLiteral: environment.appName),
            "OTHER_LDFLAGS": "$(inherited) -ObjC",
            "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES": "YES",
        ],
        configurations: envConfigurations
    )
    
    return .target(
        name: environment.targetName,
        destinations: [.iPhone, .iPad],
        product: .app,
        bundleId: environment.bundleId,
        deploymentTargets: .iOS("15.0"),
        infoPlist: infoPlist,
        sources: [
            .glob("BoilerplateIOS/Sources/**/*.swift")
        ],
        resources: .resources([
            .glob(pattern: "BoilerplateIOS/Resources/**", excluding: [
                "**/*.md"
            ])
        ]),
        scripts: [
            makeFirebaseCopyScript(for: environment)
        ],
        dependencies: [
            .target(name: "Core"),
            .target(name: "Networking"),
            .target(name: "FirebaseService"),
        ],
        settings: settings
    )
}

let appTargets: [Target] = Environment.allCases.map { makeAppTarget(for: $0) }

// MARK: - Test Target

let testTarget: Target = .target(
    name: "BoilerplateIOSTests",
    destinations: [.iPhone, .iPad],
    product: .unitTests,
    bundleId: "com.tt.studio.boilerplate-iosTests",
    deploymentTargets: .iOS("15.0"),
    infoPlist: .default,
    sources: [
        .glob("BoilerplateIOS/Tests/**/*.swift")
    ],
    dependencies: [.target(name: "BoilerplateIOS-Develop")],
    settings: .settings(
        configurations: configurations
    )
)

// MARK: - Schemes

func makeScheme(for environment: Environment) -> Scheme {
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

let schemes: [Scheme] = Environment.allCases.map { makeScheme(for: $0) }

// MARK: - Project

let project = Project(
    name: "BoilerplateIOS",
    settings: projectSettings,
    targets: [coreTarget, networkingTarget, firebaseServiceTarget] + appTargets + [testTarget],
    schemes: schemes
)
