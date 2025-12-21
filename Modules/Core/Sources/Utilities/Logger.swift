import Foundation
import OSLog

/// Logger utility to log messages
public struct Logger {
    private let logger: OSLog
    
    // MARK: - Shared Instance
    
    /// Shared logger instance for app-wide logging
    public static let shared = Logger(category: "App")
    
    // MARK: - Initialization
    
    public init(subsystem: String = Bundle.main.bundleIdentifier ?? "com.app", category: String) {
        self.logger = OSLog(subsystem: subsystem, category: category)
    }
    
    // MARK: - Instance Methods
    
    /// Log debug message
    public func debug(_ message: String) {
        os_log("%{public}@", log: logger, type: .debug, message)
    }
    
    /// Log info message
    public func info(_ message: String) {
        os_log("%{public}@", log: logger, type: .info, message)
    }
    
    /// Log warning message
    public func warning(_ message: String) {
        os_log("%{public}@", log: logger, type: .default, message)
    }
    
    /// Log error message
    public func error(_ message: String) {
        os_log("%{public}@", log: logger, type: .error, message)
    }
    
    /// Log fault message
    public func fault(_ message: String) {
        os_log("%{public}@", log: logger, type: .fault, message)
    }
    
    // MARK: - Static Convenience Methods
    
    /// Log debug message using shared logger
    public static func debug(_ message: String) {
        shared.debug(message)
    }
    
    /// Log info message using shared logger
    public static func info(_ message: String) {
        shared.info(message)
    }
    
    /// Log warning message using shared logger
    public static func warning(_ message: String) {
        shared.warning(message)
    }
    
    /// Log error message using shared logger
    public static func error(_ message: String) {
        shared.error(message)
    }
    
    /// Log fault message using shared logger
    public static func fault(_ message: String) {
        shared.fault(message)
    }
}
