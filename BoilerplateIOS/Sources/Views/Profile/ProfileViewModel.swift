import Foundation
import Core
import Combine

/// Protocol định nghĩa các navigation actions cho Profile screen
protocol ProfileNavigationDelegate: AnyObject {
    func editProfile()
}

final class ProfileViewModel: BaseViewModel {
    
    @Published var username: String = "John Doe"
    @Published var email: String = "john.doe@example.com"
    
    // MARK: - Navigation Delegate
    weak var navigationDelegate: ProfileNavigationDelegate?
    
    override func setupBindings() {
        super.setupBindings()
    }
    
    func editProfile() {
        navigationDelegate?.editProfile()
    }
}
