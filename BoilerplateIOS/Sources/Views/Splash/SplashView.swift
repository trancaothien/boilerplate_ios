import SwiftUI
import Core

struct SplashView: View {
    @ObservedObject var viewModel: SplashViewModel
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    init(viewModel: SplashViewModel = SplashViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "667eea") ?? .blue,
                    Color(hex: "764ba2") ?? .purple
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // App Icon/Logo
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                // App Name
                Text(AppConstants.App.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(opacity)
                
                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
        }
        .loading(viewModel.isLoading)
        .errorAlert(errorMessage: $viewModel.errorMessage)
    }
}

#Preview {
    SplashView()
}

