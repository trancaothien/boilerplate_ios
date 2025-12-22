import ProjectDescription

public enum Environment: String, CaseIterable {
    case develop = "Develop"
    case staging = "Staging"
    case sandbox = "Sandbox"
    case production = "Production"
    
    public var xcconfig: Path {
        return .relativeToRoot("Configurations/XCConfig/\(rawValue).xcconfig")
    }
    
    public var bundleId: String {
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
    
    public var appName: String {
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
    
    public var targetName: String {
        return "BoilerplateIOS-\(rawValue)"
    }
    
    /// Use Debug for dev environments, Release for production-like
    public var isDebugVariant: Bool {
        switch self {
        case .develop, .staging:
            return true
        case .sandbox, .production:
            return false
        }
    }
    
    public var configurationName: ConfigurationName {
        return isDebugVariant ? .debug : .release
    }
}
