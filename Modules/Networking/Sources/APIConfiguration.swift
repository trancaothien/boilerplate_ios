import Foundation

/// API Configuration singleton
public final class APIConfiguration {
    public static let shared = APIConfiguration()
    
    /// Base URL of the API
    public var baseURL: String {
        // TODO: Change based on environment (Development, Staging, Production)
        return "https://api.example.com"
    }
    
    /// Timeout interval for requests (seconds)
    public var timeoutInterval: TimeInterval {
        return 30.0
    }
    
    /// Authorization token
    public var authToken: String? {
        // TODO: Get from Keychain or UserDefaults
        return UserDefaults.standard.string(forKey: "auth_token")
    }
    
    /// Set authorization token
    public func setAuthToken(_ token: String?) {
        if let token = token {
            UserDefaults.standard.set(token, forKey: "auth_token")
        } else {
            UserDefaults.standard.removeObject(forKey: "auth_token")
        }
    }
    
    private init() {}
}

