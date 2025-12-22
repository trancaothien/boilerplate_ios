import Foundation
import Core
import Combine

final class ProfileViewModel: BaseViewModel {
    
    @Published var username: String = "John Doe"
    @Published var email: String = "john.doe@example.com"
    
    // MARK: - Coordinator
    weak var coordinator: ProfileCoordinator?
    
    override func setupBindings() {
        super.setupBindings()
    }
    
    func editProfile() {
        // Handle edit profile action
    }
}
