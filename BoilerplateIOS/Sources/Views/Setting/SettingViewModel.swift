import Foundation
import Core
import Combine

/// Protocol định nghĩa các navigation actions cho Setting screen
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
