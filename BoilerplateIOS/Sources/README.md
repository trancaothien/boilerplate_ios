# Project Structure

## Architecture Overview

The project is configured following best practices with:

### 1. Coordinator Pattern
- **Coordinator.swift**: Protocol defining interface for Coordinator
- **AppCoordinator.swift**: Main coordinator managing the entire app flow
- **Feature Coordinators**: Child coordinators for specific features

### 2. Base Classes
- **BaseViewController.swift**: Base class for all ViewControllers with:
  - Loading indicator management
  - Error handling
  - Combine cancellables management
  
- **BaseViewModel.swift**: Base class for all ViewModels with:
  - Loading state management
  - Error handling
  - Combine support

### 3. Network Module
- **APIService.swift**: Service class for performing network requests with Alamofire
- **APIEndpoint.swift**: Protocol for defining API endpoints
- **APIConfiguration.swift**: Configuration for API (base URL, timeout, auth token)
- **NetworkError.swift**: Custom error types for network layer
- **APIResponse.swift**: Generic response wrapper

### 4. Firebase Services
- **FirebaseAnalyticsService**: Analytics tracking
- **FirebaseCrashlyticsService**: Crash reporting
- **FirebaseMessagingService**: Push notifications
- **FirebaseStorageService**: File storage
- **FirebaseAuthService**: User authentication

## Usage Examples

### Creating an Endpoint
```swift
enum UserEndpoint: APIEndpoint {
    case getUsers
    case getUser(id: Int)
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getUser(let id):
            return "/users/\(id)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return nil
    }
}
```

### Using in ViewModel
```swift
class UserViewModel: BaseViewModel {
    private let apiService = APIService.shared
    
    func fetchUsers() {
        setLoading(true)
        
        apiService.request(endpoint: UserEndpoint.getUsers, responseType: [User].self)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.setLoading(false)
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { users in
                    // Handle success
                }
            )
            .store(in: &cancellables)
    }
}
```

### Using in ViewController
```swift
class UserViewController: BaseViewController {
    private let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func bindViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
    }
}
```

## Configuration

### Configuring API Base URL
Edit in `APIConfiguration.swift` or use environment variables from xcconfig:

```swift
// Automatically reads from Info.plist (set via xcconfig)
let baseURL = APIConfiguration.shared.baseURL
```

### Configuring Auth Token
```swift
APIConfiguration.shared.setAuthToken("your-token-here")
```

## Environment Configuration

The app supports multiple environments (Develop, Staging, Sandbox, Production) with different configurations:

- Different bundle IDs per environment
- Different API base URLs
- Different Firebase projects
- Different feature flags

See `Configurations/README.md` for more details.
