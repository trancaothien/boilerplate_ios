import ProjectDescription

public extension Target {
    static let core: Target = .target(
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
    
    static let networking: Target = .target(
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
    
    static let firebaseService: Target = .target(
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
    
    static func app(for environment: Environment) -> Target {
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
    
    static let unitTests: Target = .target(
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
}
