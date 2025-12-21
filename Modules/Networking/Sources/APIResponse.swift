import Foundation

/// Generic API Response wrapper
public struct APIResponse<T: Decodable>: Decodable {
    public let data: T?
    public let message: String?
    public let success: Bool?
    public let statusCode: Int?
    
    public enum CodingKeys: String, CodingKey {
        case data
        case message
        case success
        case statusCode = "status_code"
    }
    
    public init(data: T?, message: String?, success: Bool?, statusCode: Int?) {
        self.data = data
        self.message = message
        self.success = success
        self.statusCode = statusCode
    }
}

/// Empty response for APIs that don't return data
public struct EmptyResponse: Decodable {
    public init() {}
}

