import SwiftUI
import Combine

/// Base View for SwiftUI with common features
public protocol BaseViewProtocol: View {
    associatedtype ViewModelType: BaseViewModel
    
    var viewModel: ViewModelType { get }
}

public extension BaseViewProtocol {
    /// Bind ViewModel to View
    func setupBindings() {
        // Override in subclass if needed
    }
}

/// Base View with ViewModel
public struct BaseView<Content: View, ViewModel: BaseViewModel>: View {
    @ObservedObject public var viewModel: ViewModel
    public let content: (ViewModel) -> Content
    
    public init(
        viewModel: ViewModel,
        @ViewBuilder content: @escaping (ViewModel) -> Content
    ) {
        self.viewModel = viewModel
        self.content = content
    }
    
    public var body: some View {
        content(viewModel)
            .onAppear {
                setupBindings()
            }
    }
    
    private func setupBindings() {
        // Override in subclass if needed
    }
}

/// View Modifier to display loading overlay
public struct LoadingModifier: ViewModifier {
    let isLoading: Bool
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)
            
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
    }
}

public extension View {
    /// Display loading overlay
    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}

/// View Modifier to display error alert
public struct ErrorAlertModifier: ViewModifier {
    @Binding var errorMessage: String?
    
    public func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK") {
                    errorMessage = nil
                }
            } message: {
                if let message = errorMessage {
                    Text(message)
                }
            }
    }
}

public extension View {
    /// Display error alert
    func errorAlert(errorMessage: Binding<String?>) -> some View {
        modifier(ErrorAlertModifier(errorMessage: errorMessage))
    }
}

