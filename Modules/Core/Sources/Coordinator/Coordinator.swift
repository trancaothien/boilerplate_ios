import UIKit
import SwiftUI



// MARK: - Presentation Style

/// Modal presentation configuration
public struct ModalConfiguration {
    public let presentationStyle: UIModalPresentationStyle
    public let transitionStyle: UIModalTransitionStyle
    public let isModalInPresentation: Bool
    
    public init(
        presentationStyle: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        isModalInPresentation: Bool = false
    ) {
        self.presentationStyle = presentationStyle
        self.transitionStyle = transitionStyle
        self.isModalInPresentation = isModalInPresentation
    }
    
    public static let `default` = ModalConfiguration()
    public static let fullScreen = ModalConfiguration(presentationStyle: .fullScreen)
    public static let pageSheet = ModalConfiguration(presentationStyle: .pageSheet)
    public static let formSheet = ModalConfiguration(presentationStyle: .formSheet)
}

// MARK: - Coordinator Protocol

/// Protocol defining interface for Coordinator pattern
public protocol Coordinator: AnyObject {
    /// Navigation controller to manage navigation
    var navigationController: UINavigationController { get set }
    
    /// Child coordinators to manage sub-flows
    var childCoordinators: [Coordinator] { get set }
    
    /// Start coordinator flow
    func start()
    
    /// Finish coordinator and remove from parent
    func finish()
}

// MARK: - Child Coordinator Management

public extension Coordinator {
    /// Add child coordinator
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    /// Remove child coordinator
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    /// Remove all child coordinators
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    
    /// Find child coordinator by type
    func findChildCoordinator<T: Coordinator>(ofType type: T.Type) -> T? {
        childCoordinators.first { $0 is T } as? T
    }
}





