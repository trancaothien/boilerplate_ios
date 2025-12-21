import Foundation
import Alamofire

/// Protocol defining API endpoint
public protocol APIEndpoint {
    /// Base URL of the API
    var baseURL: String { get }
    
    /// Path of the endpoint
    var path: String { get }
    
    /// HTTP method
    var method: HTTPMethod { get }
    
    /// Request parameters
    var parameters: Parameters? { get }
    
    /// Request headers
    var headers: HTTPHeaders? { get }
    
    /// Encoding type
    var encoding: ParameterEncoding { get }
}

public extension APIEndpoint {
    var baseURL: String {
        return APIConfiguration.shared.baseURL
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get, .delete:
            return URLEncoding.default
        case .post, .put, .patch:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders? {
        var defaultHeaders = HTTPHeaders()
        defaultHeaders["Content-Type"] = "application/json"
        defaultHeaders["Accept"] = "application/json"
        
        // Add authorization token if available
        if let token = APIConfiguration.shared.authToken {
            defaultHeaders["Authorization"] = "Bearer \(token)"
        }
        
        return defaultHeaders
    }
}

