import UIKit
import SwiftUI

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

// MARK: - Modal Presentation

public extension Coordinator {
    /// Present a SwiftUI view modally with configuration
    func present(
        _ view: some View,
        configuration: ModalConfiguration = .default,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let hostingController = UIHostingController(rootView: view)
        present(hostingController, configuration: configuration, animated: animated, completion: completion)
    }
    
    /// Present a view controller modally with configuration
    func present(
        _ viewController: UIViewController,
        configuration: ModalConfiguration = .default,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        viewController.modalPresentationStyle = configuration.presentationStyle
        viewController.modalTransitionStyle = configuration.transitionStyle
        viewController.isModalInPresentation = configuration.isModalInPresentation
        
        navigationController.present(viewController, animated: animated, completion: completion)
    }
    
    /// Dismiss the currently presented modal
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
}

// MARK: - Navigation

public extension Coordinator {
    /// Push a SwiftUI view onto the navigation stack
    func push(_ view: some View, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: view)
        push(hostingController, animated: animated)
    }
    
    /// Push a view controller onto the navigation stack
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    /// Pop the top view controller from the navigation stack
    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
    
    /// Pop to the root view controller
    func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }
    
    /// Replace all view controllers with a new SwiftUI view (set as root)
    func replaceAll(with view: some View, animated: Bool = false) {
        let hostingController = UIHostingController(rootView: view)
        replaceAll(with: hostingController, animated: animated)
    }
    
    /// Replace all view controllers with a new view controller (set as root)
    func replaceAll(with viewController: UIViewController, animated: Bool = false) {
        navigationController.setViewControllers([viewController], animated: animated)
    }
}

