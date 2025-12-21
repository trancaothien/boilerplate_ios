import Foundation
import Combine

/// Base ViewModel with common features
open class BaseViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// Combine cancellables to manage subscriptions
    public var cancellables = Set<AnyCancellable>()
    
    /// Loading state
    @Published public var isLoading: Bool = false
    
    /// Error state
    @Published public var error: Error?
    
    /// Error message
    @Published public var errorMessage: String?
    
    // MARK: - Initialization
    
    public init() {
        setupBindings()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Setup Methods
    
    /// Override this method to setup bindings
    open func setupBindings() {
        // Override in subclass
    }
    
    // MARK: - Error Handling
    
    /// Handle error
    public func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.error = error
            self?.errorMessage = error.localizedDescription
            self?.isLoading = false
        }
    }
    
    /// Clear error
    public func clearError() {
        error = nil
        errorMessage = nil
    }
    
    // MARK: - Loading State
    
    /// Set loading state
    public func setLoading(_ loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = loading
        }
    }
}

