import Foundation
import UIKit

/// App constants
public struct AppConstants {
    private init() {}
    
    /// App information
    public struct App {
        public static let name = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "App"
        public static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        public static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    /// UI Constants
    public struct UI {
        public static let defaultCornerRadius: CGFloat = 8.0
        public static let defaultPadding: CGFloat = 16.0
        public static let defaultSpacing: CGFloat = 8.0
        public static let defaultAnimationDuration: TimeInterval = 0.3
    }
    
    /// Network Constants
    public struct Network {
        public static let defaultTimeout: TimeInterval = 30.0
        public static let maxRetryCount: Int = 3
    }
    
    /// Date Formats
    public struct DateFormat {
        public static let defaultFormat = "yyyy-MM-dd HH:mm:ss"
        public static let dateOnly = "yyyy-MM-dd"
        public static let timeOnly = "HH:mm:ss"
        public static let displayFormat = "MMM dd, yyyy"
    }
}

