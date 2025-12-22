import UIKit
import Core
import FirebaseCore
import FirebaseService

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        
        // Configure Firebase
        configureFirebase()
        
        // Log current configuration
        logAppConfiguration()
        
        // Create window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Initialize and start AppCoordinator
        guard let window = window else { return false }
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
        return true
    }
    
    // MARK: - Scene Support (iOS 13+)
    
    @available(iOS 13.0, *)
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
    
    // MARK: - Push Notifications
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        FirebaseMessagingService.shared.setAPNSToken(deviceToken)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Logger.error("Failed to register for remote notifications: \(error.localizedDescription)")
        FirebaseCrashlyticsService.shared.recordError(error, context: "Remote Notifications")
    }
}

// MARK: - Firebase Configuration

private extension AppDelegate {
    
    func configureFirebase() {
        // Firebase is configured automatically using GoogleService-Info.plist
        // The correct plist is copied based on the build configuration
        FirebaseApp.configure()
        
        // Initialize Firebase services
        // Services will handle their own setup based on configuration
        _ = FirebaseAnalyticsService.shared
        _ = FirebaseCrashlyticsService.shared
        _ = FirebaseMessagingService.shared
        _ = FirebaseStorageService.shared
        _ = FirebaseAuthService.shared
        
        Logger.info("Firebase services initialized")
    }
    
    func logAppConfiguration() {
        let config = AppConfiguration.shared
        
        if config.shouldEnableLogging {
            Logger.info("=== App Configuration ===")
            Logger.info(config.debugDescription)
            Logger.info("========================")
        }
    }
}

