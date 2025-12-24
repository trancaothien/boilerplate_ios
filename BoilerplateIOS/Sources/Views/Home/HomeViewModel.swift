import Foundation
import Core
import Combine

/// Protocol định nghĩa các navigation actions cho Home screen
protocol HomeNavigationDelegate: AnyObject {
    func showDetail(for item: Item)
    func showSettings()
    func showProfile()
    func showPageSheetModal()
    func showFullScreenModal()
    func showFormSheetModal()
    func showCustomModal()
}

final class HomeViewModel: BaseViewModel {
    @Published var items: [Item] = []
    @Published var userName: String = "User"
    
    // MARK: - Navigation Delegate
    weak var navigationDelegate: HomeNavigationDelegate?
    
    override func setupBindings() {
        loadData()
    }
    
    func loadData() {
        setLoading(true)
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.items = [
                Item(
                    id: 1,
                    name: "Item 1",
                    isFavorite: true,
                    createdDate: Date().addingTimeInterval(-86400 * 1),
                    metadata: ItemMetadata(
                        category: "Technology",
                        tags: ["iOS", "Swift", "Demo"],
                        priority: "High"
                    )
                ),
                Item(
                    id: 2,
                    name: "Item 2",
                    isFavorite: false,
                    createdDate: Date().addingTimeInterval(-86400 * 2),
                    metadata: ItemMetadata(
                        category: "Design",
                        tags: ["UI", "UX"],
                        priority: "Medium"
                    )
                ),
                Item(
                    id: 3,
                    name: "Item 3",
                    isFavorite: true,
                    createdDate: Date().addingTimeInterval(-86400 * 3),
                    metadata: nil
                ),
                Item(
                    id: 4,
                    name: "Item 4",
                    isFavorite: false,
                    createdDate: Date().addingTimeInterval(-86400 * 4),
                    metadata: ItemMetadata(
                        category: "Business",
                        tags: ["Strategy"],
                        priority: "Low"
                    )
                ),
                Item(
                    id: 5,
                    name: "Item 5",
                    isFavorite: true,
                    createdDate: Date().addingTimeInterval(-86400 * 5),
                    metadata: ItemMetadata(
                        category: "Development",
                        tags: ["Backend", "API"],
                        priority: "High"
                    )
                )
            ]
            self?.setLoading(false)
        }
    }
    
    func refresh() {
        items.removeAll()
        loadData()
    }
    
    // MARK: - Navigation Actions
    
    /// Truyền params từ Home sang Detail
    /// Có thể truyền nhiều loại params: String, Int, Bool, Date, Custom Object
    func showDetail(for item: Item) {
        navigationDelegate?.showDetail(for: item)
    }
    
    func showSettings() {
        navigationDelegate?.showSettings()
    }
    
    func showProfile() {
        navigationDelegate?.showProfile()
    }
    
    // MARK: - ModalConfiguration Demo Actions
    
    func showPageSheetModal() {
        navigationDelegate?.showPageSheetModal()
    }
    
    func showFullScreenModal() {
        navigationDelegate?.showFullScreenModal()
    }
    
    func showFormSheetModal() {
        navigationDelegate?.showFormSheetModal()
    }
    
    func showCustomModal() {
        navigationDelegate?.showCustomModal()
    }
}

