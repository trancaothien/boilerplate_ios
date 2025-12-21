import Foundation
import Core
import Combine

final class SplashViewModel: BaseViewModel {
    @Published var isFinished: Bool = false
    
    /// Callback when splash screen finishes
    var onFinish: (() -> Void)?
    
    override func setupBindings() {
        // Simulate splash screen delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isFinished = true
            self?.onFinish?()
        }
    }
}

