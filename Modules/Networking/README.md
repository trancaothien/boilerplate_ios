# Networking Module

The Networking module is separated into its own framework for reusability across different projects.

## Structure

- **APIConfiguration.swift**: API configuration (base URL, timeout, auth token)
- **APIEndpoint.swift**: Protocol for defining API endpoints
- **APIService.swift**: Service class for performing network requests with Alamofire
- **NetworkError.swift**: Custom error types for network layer
- **APIResponse.swift**: Generic response wrapper
- **Example/ExampleEndpoint.swift**: Example usage

## Dependencies

- Alamofire
- Combine (built-in framework)

## Usage

In other modules, import the Networking framework:

```swift
import Networking
```

Then use the classes and protocols:

```swift
import Networking
import Combine

class MyViewModel {
    private let apiService = APIService.shared
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData() {
        apiService.request(endpoint: MyEndpoint.getData, responseType: MyModel.self)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    // Handle error
                },
                receiveValue: { data in
                    // Handle success
                }
            )
            .store(in: &cancellables)
    }
}
```

## Creating an Endpoint

```swift
import Networking
import Alamofire

enum UserEndpoint: APIEndpoint {
    case getUsers
    case getUser(id: Int)
    case createUser(name: String, email: String)
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getUser(let id):
            return "/users/\(id)"
        case .createUser:
            return "/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUser:
            return .get
        case .createUser:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getUsers, .getUser:
            return nil
        case .createUser(let name, let email):
            return [
                "name": name,
                "email": email
            ]
        }
    }
}
```

## Error Handling

```swift
import Networking

apiService.request(endpoint: UserEndpoint.getUsers, responseType: [User].self)
    .receive(on: DispatchQueue.main)
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                switch error {
                case .networkError(let underlyingError):
                    print("Network error: \(underlyingError)")
                case .decodingError(let error):
                    print("Decoding error: \(error)")
                case .serverError(let statusCode, let message):
                    print("Server error \(statusCode): \(message)")
                case .unknown(let error):
                    print("Unknown error: \(error)")
                }
            }
        },
        receiveValue: { users in
            // Handle success
        }
    )
    .store(in: &cancellables)
```

## Configuration

### Setting API Base URL
Edit in `APIConfiguration.swift` or use environment variables from xcconfig:

```swift
// Automatically reads from Info.plist (set via xcconfig)
let baseURL = APIConfiguration.shared.baseURL
```

### Setting Auth Token
```swift
APIConfiguration.shared.setAuthToken("your-token-here")
```

### Custom Headers
```swift
APIConfiguration.shared.setCustomHeader("X-Custom-Header", value: "value")
```
