import Foundation
import FirebaseAnalytics
import Core

/// Firebase Analytics Service
public final class FirebaseAnalyticsService {
    
    // MARK: - Singleton
    
    public static let shared = FirebaseAnalyticsService()
    
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
        Analytics.setAnalyticsCollectionEnabled(isEnabled)
        
        if config.isDebug {
            setUserProperties()
        }
        
        Logger.info("Firebase Analytics initialized - Enabled: \(isEnabled)")
    }
    
    private func setUserProperties() {
        Analytics.setUserProperty(config.environment.shortName, forName: "environment")
        Analytics.setUserProperty(config.fullVersionString, forName: "app_version")
    }
    
    // MARK: - Public Methods
    
    /// Log a custom event
    public func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        guard isEnabled else { return }
        
        Analytics.logEvent(name, parameters: parameters)
        Logger.debug("Analytics Event: \(name)")
    }
    
    /// Set user property
    public func setUserProperty(_ value: String?, forName name: String) {
        guard isEnabled else { return }
        
        Analytics.setUserProperty(value, forName: name)
    }
    
    /// Set user ID
    public func setUserId(_ userId: String?) {
        guard isEnabled else { return }
        
        Analytics.setUserID(userId)
    }
    
    /// Reset analytics data
    public func resetAnalyticsData() {
        Analytics.resetAnalyticsData()
    }
    
    // MARK: - Convenience Methods
    
    /// Log screen view
    public func logScreenView(screenName: String, screenClass: String? = nil) {
        var parameters: [String: Any] = [
            AnalyticsParameterScreenName: screenName
        ]
        
        if let screenClass = screenClass {
            parameters[AnalyticsParameterScreenClass] = screenClass
        }
        
        logEvent(AnalyticsEventScreenView, parameters: parameters)
    }
    
    /// Log button click
    public func logButtonClick(buttonName: String, screenName: String? = nil) {
        var parameters: [String: Any] = [
            "button_name": buttonName
        ]
        
        if let screenName = screenName {
            parameters["screen_name"] = screenName
        }
        
        logEvent("button_clicked", parameters: parameters)
    }
}

