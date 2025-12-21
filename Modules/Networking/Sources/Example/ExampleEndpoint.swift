import Foundation
import Alamofire

/// Example endpoint to demonstrate usage
enum ExampleEndpoint: APIEndpoint {
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

/// Example model
struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

/// Example usage in ViewModel
/*
class ExampleViewModel: BaseViewModel {
    private let apiService = APIService.shared
    
    func fetchUsers() {
        setLoading(true)
        
        apiService.request(endpoint: ExampleEndpoint.getUsers, responseType: [User].self)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.setLoading(false)
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] users in
                    // Handle success
                    print("Users: \(users)")
                }
            )
            .store(in: &cancellables)
    }
}
*/

