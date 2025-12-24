import UIKit
import SwiftUI
import Core

/// Home Coordinator manages home screen flow
final class HomeCoordinator: BaseCoordinator, HomeNavigationDelegate {
    
    override func start() {
        let viewModel = HomeViewModel()
        
        // Setup navigation delegate
        viewModel.navigationDelegate = self
        
        let homeView = HomeView(viewModel: viewModel)
        
        // Replace all to set home as root
        replaceAll(with: homeView, animated: true)
    }
    
    // MARK: - HomeNavigationDelegate
    
    func showDetail(for item: Item) {
        showDetail(
            itemName: item.name,
            itemId: item.id,
            isFavorite: item.isFavorite,
            createdDate: item.createdDate,
            metadata: item.metadata
        )
    }
    
    // MARK: - Navigation Examples
    
    /// Show detail screen with params from Home screen
    /// Demo passing multiple param types: String, Int, Bool, Date, Custom Object
    /// Uses DetailCoordinator to manage Detail screen flow
    private func showDetail(
        itemName: String,
        itemId: Int,
        isFavorite: Bool,
        createdDate: Date,
        metadata: ItemMetadata?
    ) {
        // Create DetailCoordinator with params
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            parentCoordinator: self,
            itemName: itemName,
            itemId: itemId,
            isFavorite: isFavorite,
            createdDate: createdDate,
            metadata: metadata
        )
        
        // Add to child coordinators and start
        addChildCoordinator(detailCoordinator)
        detailCoordinator.start()
    }
    
    /// Show settings screen modally
    func showSettings() {
        let settingsNavController = UINavigationController()
        
        let settingsCoordinator = SettingCoordinator(
            navigationController: settingsNavController,
            parentCoordinator: self
        )
        addChildCoordinator(settingsCoordinator)
        settingsCoordinator.start()
        
        // Use ModalConfiguration.pageSheet to display as bottom sheet
        present(settingsNavController, configuration: .pageSheet)
    }
    
    /// Show profile screen
    func showProfile() {
        let profileCoordinator = ProfileCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        addChildCoordinator(profileCoordinator)
        profileCoordinator.start()
    }
    
    // MARK: - ModalConfiguration Demo Methods
    
    /// Demo: Display modal with pageSheet style (bottom sheet)
    func showPageSheetModal() {
        let demoView = ModalDemoView(
            title: "Page Sheet Modal",
            description: "This is a page sheet modal (bottom sheet), can swipe down to dismiss.",
            onDismiss: { [weak self] in
                self?.dismiss()
            }
        )
        present(demoView, configuration: .pageSheet)
    }
    
    /// Demo: Display modal with fullScreen style
    func showFullScreenModal() {
        let demoView = ModalDemoView(
            title: "Full Screen Modal",
            description: "This is a full screen modal, takes up the entire screen.",
            onDismiss: { [weak self] in
                self?.dismiss()
            }
        )
        present(demoView, configuration: .fullScreen)
    }
    
    /// Demo: Display modal with formSheet style
    func showFormSheetModal() {
        let demoView = ModalDemoView(
            title: "Form Sheet Modal",
            description: "This is a form sheet modal, commonly used on iPad.",
            onDismiss: { [weak self] in
                self?.dismiss()
            }
        )
        present(demoView, configuration: .formSheet)
    }
    
    /// Demo: Display modal with custom configuration
    func showCustomModal() {
        let customConfig = ModalConfiguration(
            presentationStyle: .pageSheet,
            transitionStyle: .flipHorizontal,
            isModalInPresentation: true // Prevent swipe down to dismiss
        )
        let demoView = ModalDemoView(
            title: "Custom Modal",
            description: "This is a modal with custom configuration:\n- Presentation: Page Sheet\n- Transition: Flip Horizontal\n- isModalInPresentation: true (cannot swipe down)",
            onDismiss: { [weak self] in
                self?.dismiss()
            }
        )
        present(demoView, configuration: customConfig)
    }
    
}

