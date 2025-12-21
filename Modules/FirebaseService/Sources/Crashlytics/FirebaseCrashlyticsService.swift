import Foundation
import FirebaseCrashlytics
import Core

/// Firebase Crashlytics Service
public final class FirebaseCrashlyticsService {
    
    // MARK: - Singleton
    
    public static let shared = FirebaseCrashlyticsService()
    
    // MARK: - Properties
    
    private let config = AppConfiguration.shared
    private var isEnabled: Bool {
        return config.shouldEnableAnalytics
    }
    
    // MARK: - Initialization
    
    private init() {
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(isEnabled)
        
        if isEnabled {
            setInitialUserProperties()
        }
        
        Logger.info("Firebase Crashlytics initialized - Enabled: \(isEnabled)")
    }
    
    private func setInitialUserProperties() {
        setCustomValue(config.environment.shortName, forKey: "environment")
        setCustomValue(config.fullVersionString, forKey: "app_version")
        setCustomValue(config.bundleIdentifier, forKey: "bundle_id")
    }
    
    // MARK: - Public Methods
    
    /// Record a non-fatal error
    public func recordError(_ error: Error, userInfo: [String: Any]? = nil) {
        guard isEnabled else { return }
        
        if let userInfo = userInfo {
            for (key, value) in userInfo {
                setCustomValue("\(value)", forKey: key)
            }
        }
        
        Crashlytics.crashlytics().record(error: error)
        Logger.error("Error recorded in Crashlytics: \(error.localizedDescription)")
    }
    
    /// Log a message
    public func log(_ message: String) {
        guard isEnabled else { return }
        
        Crashlytics.crashlytics().log(message)
    }
    
    /// Set custom key-value pair
    public func setCustomValue(_ value: String, forKey key: String) {
        guard isEnabled else { return }
        
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    /// Set user identifier
    public func setUserID(_ userID: String) {
        guard isEnabled else { return }
        
        Crashlytics.crashlytics().setUserID(userID)
    }
    
    /// Check if crashlytics is enabled
    public var isCrashlyticsEnabled: Bool {
        return isEnabled
    }
    
    // MARK: - Convenience Methods
    
    /// Record error with context
    public func recordError(
        _ error: Error,
        context: String,
        additionalInfo: [String: Any]? = nil
    ) {
        var info: [String: Any] = [
            "context": context
        ]
        
        if let additionalInfo = additionalInfo {
            info.merge(additionalInfo) { (_, new) in new }
        }
        
        recordError(error, userInfo: info)
    }
}

