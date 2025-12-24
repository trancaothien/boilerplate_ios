import Foundation
import Core
import Combine

/// Model for demo passing custom object
struct ItemMetadata: Codable {
    let category: String
    let tags: [String]
    let priority: String
}

/// Item model for demo
struct Item: Identifiable, Codable {
    let id: Int
    let name: String
    let isFavorite: Bool
    let createdDate: Date
    let metadata: ItemMetadata?
}

final class DetailViewModel: BaseViewModel {
    // MARK: - Params received from previous screen
    let itemName: String
    let itemId: Int
    let isFavorite: Bool
    let createdDate: Date
    let metadata: ItemMetadata?
    
    // MARK: - Navigation Callbacks (Delegate Pattern)
    // Note: DetailViewModel currently has no navigation actions
    // If navigation is needed in the future, add callbacks here
    
    // MARK: - Initialization
    
    /// Initialize with params from previous screen
    init(
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
        super.init()
    }
    
    override func setupBindings() {
        // Setup bindings if needed
    }
}

