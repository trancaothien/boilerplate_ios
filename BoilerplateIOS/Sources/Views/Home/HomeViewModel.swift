import Foundation
import Core
import Combine

final class HomeViewModel: BaseViewModel {
    @Published var items: [String] = []
    @Published var userName: String = "User"
    
    // MARK: - Coordinator
    weak var coordinator: HomeCoordinator?
    
    override func setupBindings() {
        loadData()
    }
    
    func loadData() {
        setLoading(true)
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.items = [
                "Item 1",
                "Item 2",
                "Item 3",
                "Item 4",
                "Item 5"
            ]
            self?.setLoading(false)
        }
    }
    
    func refresh() {
        items.removeAll()
        loadData()
    }
    
    // MARK: - Navigation Actions
    
    func showDetail(for item: String) {
        coordinator?.showDetail(for: item)
    }
    
    func showSettings() {
        coordinator?.showSettings()
    }
    
    func showProfile() {
        coordinator?.showProfile()
    }
}

