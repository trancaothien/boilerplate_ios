import Foundation

// MARK: - Environment

/// Represents the current app environment
public enum Environment: String, CaseIterable {
    case develop = "Develop"
    case staging = "Staging"
    case sandbox = "Sandbox"
    case production = "Production"
    
    // MARK: - Current Environment
    
    /// Returns the current environment based on build configuration
    public static var current: Environment {
        #if DEVELOP
        return .develop
        #elseif STAGING
        return .staging
        #elseif SANDBOX
        return .sandbox
        #elseif PRODUCTION
        return .production
        #else
        // Fallback: try to read from Info.plist
        if let envString = Bundle.main.infoDictionary?["ENVIRONMENT"] as? String,
           let env = Environment(rawValue: envString) {
            return env
        }
        // Default to develop for safety
        return .develop
        #endif
    }
    
    // MARK: - Properties
    
    /// Whether this is a debug environment
    public var isDebug: Bool {
        switch self {
        case .develop, .staging:
            return true
        case .sandbox, .production:
            return false
        }
    }
    
    /// Whether logging is enabled
    public var isLoggingEnabled: Bool {
        switch self {
        case .develop, .staging, .sandbox:
            return true
        case .production:
            return false
        }
    }
    
    /// Whether analytics is enabled
    public var isAnalyticsEnabled: Bool {
        switch self {
        case .develop:
            return false
        case .staging, .sandbox, .production:
            return true
        }
    }
    
    /// Display name for the environment
    public var displayName: String {
        return rawValue
    }
    
    /// Short name for the environment (useful for UI badges)
    public var shortName: String {
        switch self {
        case .develop:
            return "DEV"
        case .staging:
            return "STG"
        case .sandbox:
            return "SBX"
        case .production:
            return "PROD"
        }
    }
}

// MARK: - AppConfiguration

/// Centralized app configuration that reads from Info.plist and xcconfig
public struct AppConfiguration {
    
    // MARK: - Singleton
    
    public static let shared = AppConfiguration()
    
    // MARK: - Properties
    
    /// Current environment
    public let environment: Environment
    
    /// API base URL
    public let apiBaseURL: String
    
    /// App version
    public let appVersion: String
    
    /// Build number
    public let buildNumber: String
    
    /// Bundle identifier
    public let bundleIdentifier: String
    
    /// App display name
    public let appName: String
    
    // MARK: - Initialization
    
    private init() {
        self.environment = Environment.current
        
        let infoDictionary = Bundle.main.infoDictionary ?? [:]
        
        self.apiBaseURL = (infoDictionary["API_BASE_URL"] as? String)?
            .replacingOccurrences(of: "\\", with: "") ?? "https://api.example.com"
        
        self.appVersion = infoDictionary["CFBundleShortVersionString"] as? String ?? "1.0.0"
        self.buildNumber = infoDictionary["CFBundleVersion"] as? String ?? "1"
        self.bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.tt.studio.boilerplate-ios"
        self.appName = infoDictionary["CFBundleDisplayName"] as? String
            ?? infoDictionary["CFBundleName"] as? String
            ?? "BoilerplateIOS"
    }
    
    // MARK: - Computed Properties
    
    /// Full version string (e.g., "1.0.0 (123)")
    public var fullVersionString: String {
        return "\(appVersion) (\(buildNumber))"
    }
    
    /// Whether this is a debug build
    public var isDebug: Bool {
        return environment.isDebug
    }
    
    /// Whether logging should be enabled
    public var shouldEnableLogging: Bool {
        return environment.isLoggingEnabled
    }
    
    /// Whether analytics should be enabled
    public var shouldEnableAnalytics: Bool {
        return environment.isAnalyticsEnabled
    }
}

// MARK: - Debug Description

extension AppConfiguration: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
        AppConfiguration:
        - Environment: \(environment.displayName)
        - API Base URL: \(apiBaseURL)
        - App Version: \(fullVersionString)
        - Bundle ID: \(bundleIdentifier)
        - App Name: \(appName)
        - Is Debug: \(isDebug)
        - Logging Enabled: \(shouldEnableLogging)
        - Analytics Enabled: \(shouldEnableAnalytics)
        """
    }
}

