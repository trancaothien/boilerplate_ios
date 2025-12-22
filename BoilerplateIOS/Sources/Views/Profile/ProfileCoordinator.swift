import UIKit
import SwiftUI
import Core

final class ProfileCoordinator: BaseCoordinator {
    
    override func start() {
        let viewModel = ProfileViewModel()
        viewModel.coordinator = self
        let profileView = ProfileView(viewModel: viewModel)
        
        // Push the profile view onto the navigation stack
        let hostingController = UIHostingController(rootView: profileView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}
