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
    
    /// Show detail screen với params từ màn hình Home
    /// Demo cách truyền nhiều loại params: String, Int, Bool, Date, Custom Object
    /// Sử dụng DetailCoordinator để quản lý flow của màn hình Detail
    private func showDetail(
        itemName: String,
        itemId: Int,
        isFavorite: Bool,
        createdDate: Date,
        metadata: ItemMetadata?
    ) {
        // Tạo DetailCoordinator với params
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            parentCoordinator: self,
            itemName: itemName,
            itemId: itemId,
            isFavorite: isFavorite,
            createdDate: createdDate,
            metadata: metadata
        )
        
        // Thêm vào child coordinators và start
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
        
        // Sử dụng ModalConfiguration.pageSheet để hiển thị dạng bottom sheet
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
    
    /// Demo: Hiển thị modal với style pageSheet (bottom sheet)
    func showPageSheetModal() {
        let demoView = ModalDemoView(
            title: "Page Sheet Modal",
            description: "Đây là modal dạng page sheet (bottom sheet), có thể kéo xuống để đóng.",
            onDismiss: { [weak self] in
                self?.dismiss()
            }
        )
        present(demoView, configuration: .pageSheet)
    }
    
    /// Demo: Hiển thị modal với style fullScreen
    func showFullScreenModal() {
        let demoView = ModalDemoView(
            title: "Full Screen Modal",
            description: "Đây là modal dạng full screen, chiếm toàn bộ màn hình.",
            onDismiss: { [weak self] in
                self?.dismiss()
            }
        )
        present(demoView, configuration: .fullScreen)
    }
    
    /// Demo: Hiển thị modal với style formSheet
    func showFormSheetModal() {
        let demoView = ModalDemoView(
            title: "Form Sheet Modal",
            description: "Đây là modal dạng form sheet, thường dùng trên iPad.",
            onDismiss: { [weak self] in
                self?.dismiss()
            }
        )
        present(demoView, configuration: .formSheet)
    }
    
    /// Demo: Hiển thị modal với custom configuration
    func showCustomModal() {
        let customConfig = ModalConfiguration(
            presentationStyle: .pageSheet,
            transitionStyle: .flipHorizontal,
            isModalInPresentation: true // Không cho phép swipe down để dismiss
        )
        let demoView = ModalDemoView(
            title: "Custom Modal",
            description: "Đây là modal với custom configuration:\n- Presentation: Page Sheet\n- Transition: Flip Horizontal\n- isModalInPresentation: true (không thể swipe down)",
            onDismiss: { [weak self] in
                self?.dismiss()
            }
        )
        present(demoView, configuration: customConfig)
    }
    
}

