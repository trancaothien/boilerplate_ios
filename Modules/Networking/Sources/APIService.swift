import Foundation
import Alamofire
import Combine

/// API Service class for performing network requests
public final class APIService {
    public static let shared = APIService()
    
    private let session: Session
    
    private init() {
        // Configure session with timeout and retry policy
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIConfiguration.shared.timeoutInterval
        configuration.timeoutIntervalForResource = APIConfiguration.shared.timeoutInterval
        
        let interceptor = RequestInterceptor()
        
        self.session = Session(
            configuration: configuration,
            interceptor: interceptor
        )
    }
    
    // MARK: - Generic Request Methods
    
    /// Perform request and decode response to model
    /// - Parameters:
    ///   - endpoint: API endpoint
    ///   - responseType: Type of response model (must conform to Decodable)
    /// - Returns: Publisher with response model or error
    public func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknown(NSError(domain: "APIService", code: -1))))
                return
            }
            
            guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
                promise(.failure(.invalidURL))
                return
            }
            
            self.session.request(
                url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: endpoint.encoding,
                headers: endpoint.headers
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase // Or .useDefaultKeys
                        let decodedObject = try decoder.decode(T.self, from: data)
                        promise(.success(decodedObject))
                    } catch {
                        promise(.failure(.decodingError(error)))
                    }
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        let message = self.extractErrorMessage(from: response.data)
                        promise(.failure(.serverError(statusCode: statusCode, message: message)))
                    } else if let urlError = error as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet, .networkConnectionLost:
                            promise(.failure(.networkUnavailable))
                        case .timedOut:
                            promise(.failure(.timeout))
                        default:
                            promise(.failure(.unknown(error)))
                        }
                    } else {
                        promise(.failure(.unknown(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Perform request without decoding response
    /// - Parameter endpoint: API endpoint
    /// - Returns: Publisher with Data or error
    public func request(endpoint: APIEndpoint) -> AnyPublisher<Data, NetworkError> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknown(NSError(domain: "APIService", code: -1))))
                return
            }
            
            guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
                promise(.failure(.invalidURL))
                return
            }
            
            self.session.request(
                url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: endpoint.encoding,
                headers: endpoint.headers
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    promise(.success(data))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        let message = self.extractErrorMessage(from: response.data)
                        promise(.failure(.serverError(statusCode: statusCode, message: message)))
                    } else if let urlError = error as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet, .networkConnectionLost:
                            promise(.failure(.networkUnavailable))
                        case .timedOut:
                            promise(.failure(.timeout))
                        default:
                            promise(.failure(.unknown(error)))
                        }
                    } else {
                        promise(.failure(.unknown(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    
    private func extractErrorMessage(from data: Data?) -> String? {
        guard let data = data else { return nil }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = json["message"] as? String {
                return message
            } else if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let error = json["error"] as? String {
                return error
            }
        } catch {
            // Ignore parsing error
        }
        
        return nil
    }
}

// MARK: - Request Interceptor

private class RequestInterceptor: Alamofire.RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        // Add custom headers if needed
        // request.setValue("custom-value", forHTTPHeaderField: "custom-header")
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // Retry logic if needed
        // Example: retry on 401 to refresh token
        
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        // TODO: Implement token refresh logic
        completion(.doNotRetry)
    }
}

