import UIKit
import SwiftUI

// MARK: - Navigation Action

/// Enum defining all possible navigation actions
public enum NavigationAction {
    case push(animated: Bool)
    case pop(animated: Bool)
    case popToRoot(animated: Bool)
    case popTo(viewController: UIViewController, animated: Bool)
    case replace(animated: Bool)
    case replaceAll(animated: Bool)
    case present(animated: Bool, completion: (() -> Void)?)
    case dismiss(animated: Bool, completion: (() -> Void)?)
}

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

// MARK: - Navigation Actions

public extension Coordinator {
    
    // MARK: - Push
    
    /// Push a view controller onto the navigation stack
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    /// Push a SwiftUI view onto the navigation stack
    func push<V: View>(_ view: V, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: view)
        push(hostingController, animated: animated)
    }
    
    // MARK: - Pop
    
    /// Pop the top view controller from the navigation stack
    @discardableResult
    func pop(animated: Bool = true) -> UIViewController? {
        navigationController.popViewController(animated: animated)
    }
    
    /// Pop to a specific view controller in the navigation stack
    @discardableResult
    func popTo(_ viewController: UIViewController, animated: Bool = true) -> [UIViewController]? {
        navigationController.popToViewController(viewController, animated: animated)
    }
    
    /// Pop to a view controller of a specific type
    @discardableResult
    func popTo<T: UIViewController>(_ type: T.Type, animated: Bool = true) -> [UIViewController]? {
        guard let viewController = navigationController.viewControllers.first(where: { $0 is T }) else {
            return nil
        }
        return popTo(viewController, animated: animated)
    }
    
    /// Pop to the root view controller
    @discardableResult
    func popToRoot(animated: Bool = true) -> [UIViewController]? {
        navigationController.popToRootViewController(animated: animated)
    }
    
    // MARK: - Replace
    
    /// Replace the top view controller with a new one
    func replace(with viewController: UIViewController, animated: Bool = true) {
        var viewControllers = navigationController.viewControllers
        if !viewControllers.isEmpty {
            viewControllers.removeLast()
        }
        viewControllers.append(viewController)
        navigationController.setViewControllers(viewControllers, animated: animated)
    }
    
    /// Replace the top view controller with a SwiftUI view
    func replace<V: View>(with view: V, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: view)
        replace(with: hostingController, animated: animated)
    }
    
    /// Replace all view controllers with a single new one (set as root)
    func replaceAll(with viewController: UIViewController, animated: Bool = true) {
        navigationController.setViewControllers([viewController], animated: animated)
    }
    
    /// Replace all view controllers with a SwiftUI view (set as root)
    func replaceAll<V: View>(with view: V, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: view)
        replaceAll(with: hostingController, animated: animated)
    }
    
    /// Replace all view controllers with multiple new ones
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool = true) {
        navigationController.setViewControllers(viewControllers, animated: animated)
    }
    
    // MARK: - Present (Modal)
    
    /// Present a view controller modally
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
    
    /// Present a SwiftUI view modally
    func present<V: View>(
        _ view: V,
        configuration: ModalConfiguration = .default,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let hostingController = UIHostingController(rootView: view)
        present(hostingController, configuration: configuration, animated: animated, completion: completion)
    }
    
    /// Present a navigation flow modally (with its own navigation controller)
    func presentNavigation(
        rootViewController: UIViewController,
        configuration: ModalConfiguration = .default,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.modalPresentationStyle = configuration.presentationStyle
        navController.modalTransitionStyle = configuration.transitionStyle
        navController.isModalInPresentation = configuration.isModalInPresentation
        
        navigationController.present(navController, animated: animated, completion: completion)
        return navController
    }
    
    // MARK: - Dismiss
    
    /// Dismiss presented view controller
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    /// Dismiss to root (dismiss all presented view controllers)
    func dismissToRoot(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let rootViewController = navigationController.view.window?.rootViewController else {
            dismiss(animated: animated, completion: completion)
            return
        }
        rootViewController.dismiss(animated: animated, completion: completion)
    }
}

// MARK: - Navigation Stack Info

public extension Coordinator {
    /// Current visible view controller
    var visibleViewController: UIViewController? {
        navigationController.visibleViewController
    }
    
    /// Top view controller on the navigation stack
    var topViewController: UIViewController? {
        navigationController.topViewController
    }
    
    /// All view controllers in the navigation stack
    var viewControllers: [UIViewController] {
        navigationController.viewControllers
    }
    
    /// Number of view controllers in the stack
    var stackCount: Int {
        navigationController.viewControllers.count
    }
    
    /// Check if can pop (more than one view controller in stack)
    var canPop: Bool {
        navigationController.viewControllers.count > 1
    }
}

