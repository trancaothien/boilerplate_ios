import UIKit
import SwiftUI
import Core

/// Profile Coordinator manages profile screen flow
final class ProfileCoordinator: BaseCoordinator, ProfileNavigationDelegate {
    
    override func start() {
        let viewModel = ProfileViewModel()
        
        // Setup navigation delegate
        viewModel.navigationDelegate = self
        
        let profileView = ProfileView(viewModel: viewModel)
        
        // Push the profile view onto the navigation stack
        push(profileView)
    }
    
    // MARK: - ProfileNavigationDelegate
    
    func editProfile() {
        // Handle edit profile action
        // showEditProfile()
    }
}
