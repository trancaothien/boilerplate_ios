import UIKit
import Combine

/// Base ViewController with common features
open class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Combine cancellables to manage subscriptions
    public var cancellables = Set<AnyCancellable>()
    
    /// Loading indicator
    private var loadingIndicator: UIActivityIndicatorView?
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Setup Methods
    
    /// Override this method to setup UI
    open func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    /// Override this method to bind ViewModel
    open func bindViewModel() {
        // Override in subclass
    }
    
    // MARK: - Loading Indicator
    
    /// Show loading indicator
    public func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.loadingIndicator == nil {
                let indicator = UIActivityIndicatorView(style: .large)
                indicator.translatesAutoresizingMaskIntoConstraints = false
                indicator.hidesWhenStopped = true
                self.view.addSubview(indicator)
                
                NSLayoutConstraint.activate([
                    indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                ])
                
                self.loadingIndicator = indicator
            }
            
            self.loadingIndicator?.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    /// Hide loading indicator
    public func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingIndicator?.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Error Handling
    
    /// Show error alert
    public func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    /// Show error message
    public func showError(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

