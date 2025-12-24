import Foundation
import Core
import Combine

/// Model để demo truyền custom object
struct ItemMetadata: Codable {
    let category: String
    let tags: [String]
    let priority: String
}

/// Model Item để demo
struct Item: Identifiable, Codable {
    let id: Int
    let name: String
    let isFavorite: Bool
    let createdDate: Date
    let metadata: ItemMetadata?
}

final class DetailViewModel: BaseViewModel {
    // MARK: - Params nhận từ màn hình trước
    let itemName: String
    let itemId: Int
    let isFavorite: Bool
    let createdDate: Date
    let metadata: ItemMetadata?
    
    // MARK: - Navigation Callbacks (Delegate Pattern)
    // Note: DetailViewModel không có navigation actions hiện tại
    // Nếu cần thêm navigation trong tương lai, thêm callbacks ở đây
    
    // MARK: - Initialization
    
    /// Khởi tạo với params từ màn hình trước
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
        // Setup bindings nếu cần
    }
}

