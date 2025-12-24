import UIKit
import SwiftUI
import Core

/// Detail Coordinator manages detail screen flow
final class DetailCoordinator: BaseCoordinator {
    
    // MARK: - Params nhận từ màn hình trước
    private let itemName: String
    private let itemId: Int
    private let isFavorite: Bool
    private let createdDate: Date
    private let metadata: ItemMetadata?
    
    // MARK: - Initialization
    
    init(
        navigationController: UINavigationController,
        parentCoordinator: Coordinator?,
        itemName: String,
        itemId: Int,
        isFavorite: Bool,
        createdDate: Date,
        metadata: ItemMetadata?
    ) {
        self.itemName = itemName
        self.itemId = itemId
        self.isFavorite = isFavorite
        self.createdDate = createdDate
        self.metadata = metadata
        super.init(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator
        )
    }
    
    // MARK: - Start
    
    override func start() {
        // Tạo ViewModel với params nhận được
        let viewModel = DetailViewModel(
            itemName: itemName,
            itemId: itemId,
            isFavorite: isFavorite,
            createdDate: createdDate,
            metadata: metadata
        )
        
        // Setup navigation callbacks (Delegate Pattern) nếu cần
        // viewModel.onSomeAction = { [weak self] in ... }
        
        // Tạo View với ViewModel
        let detailView = DetailView(viewModel: viewModel)
        
        // Push màn hình Detail
        push(detailView)
    }
}

