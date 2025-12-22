import Foundation
import Core
import Combine

final class SettingViewModel: BaseViewModel {
    
    // MARK: - Coordinator
    weak var coordinator: SettingCoordinator?
    
    override func setupBindings() {
        super.setupBindings()
    }
    
    func dismissSettings() {
        coordinator?.finish()
    }
}
