import ProjectDescription

public let configurations: [Configuration] = [
    .debug(name: .debug),
    .release(name: .release),
]

public let projectSettings: Settings = .settings(
    base: [
        "CLANG_ENABLE_MODULES": "YES",
        "SWIFT_OBJC_INTERFACE_HEADER_NAME": "$(SWIFT_MODULE_NAME)-Swift.h",
    ],
    configurations: configurations
)
