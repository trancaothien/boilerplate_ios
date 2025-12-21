import Foundation

/// Network error types
public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int, message: String?)
    case noData
    case networkUnavailable
    case timeout
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let statusCode, let message):
            return message ?? "Server error with status code: \(statusCode)"
        case .noData:
            return "No data received from server"
        case .networkUnavailable:
            return "Network is unavailable. Please check your connection."
        case .timeout:
            return "Request timeout. Please try again."
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
    
    public var statusCode: Int? {
        if case .serverError(let code, _) = self {
            return code
        }
        return nil
    }
}

