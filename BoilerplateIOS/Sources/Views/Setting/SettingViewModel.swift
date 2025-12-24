import Foundation
import Core
import Combine

/// Protocol that defines navigation actions for Setting screen
protocol SettingNavigationDelegate: AnyObject {
    func dismissSettings()
}

final class SettingViewModel: BaseViewModel {
    
    // MARK: - Navigation Delegate
    weak var navigationDelegate: SettingNavigationDelegate?
    
    override func setupBindings() {
        super.setupBindings()
    }
    
    func dismissSettings() {
        navigationDelegate?.dismissSettings()
    }
}
