import Foundation
import Core
import Combine

/// Protocol định nghĩa các navigation actions cho Splash screen
protocol SplashNavigationDelegate: AnyObject {
    func onFinish()
}

final class SplashViewModel: BaseViewModel {
    @Published var isFinished: Bool = false
    
    // MARK: - Navigation Delegate
    weak var navigationDelegate: SplashNavigationDelegate?
    
    override func setupBindings() {
        // Simulate splash screen delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isFinished = true
            self?.navigationDelegate?.onFinish()
        }
    }
}

