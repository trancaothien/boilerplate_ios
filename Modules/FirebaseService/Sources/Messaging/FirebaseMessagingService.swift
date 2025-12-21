import Foundation
import UIKit
import FirebaseMessaging
import Core
import UserNotifications

/// Firebase Cloud Messaging Service
public final class FirebaseMessagingService: NSObject {
    
    // MARK: - Singleton
    
    public static let shared = FirebaseMessagingService()
    
    // MARK: - Properties
    
    private var fcmToken: String?
    private var tokenUpdateHandler: ((String) -> Void)?
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        Messaging.messaging().delegate = self
        
        // Request notification permissions
        requestNotificationPermissions()
        
        // Get existing token
        getFCMToken { [weak self] token in
            self?.fcmToken = token
            Logger.info("FCM Token retrieved: \(token?.prefix(20) ?? "nil")...")
        }
    }
    
    // MARK: - Public Methods
    
    /// Request notification permissions
    public func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                Logger.error("Notification permission error: \(error.localizedDescription)")
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                Logger.info("Notification permissions granted")
            } else {
                Logger.warning("Notification permissions denied")
            }
        }
    }
    
    /// Get FCM token
    public func getFCMToken(completion: @escaping (String?) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                Logger.error("Failed to get FCM token: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            completion(token)
        }
    }
    
    /// Subscribe to topic
    public func subscribe(toTopic topic: String, completion: ((Error?) -> Void)? = nil) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                Logger.error("Failed to subscribe to topic \(topic): \(error.localizedDescription)")
                completion?(error)
                return
            }
            
            Logger.info("Subscribed to topic: \(topic)")
            completion?(nil)
        }
    }
    
    /// Unsubscribe from topic
    public func unsubscribe(fromTopic topic: String, completion: ((Error?) -> Void)? = nil) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            if let error = error {
                Logger.error("Failed to unsubscribe from topic \(topic): \(error.localizedDescription)")
                completion?(error)
                return
            }
            
            Logger.info("Unsubscribed from topic: \(topic)")
            completion?(nil)
        }
    }
    
    /// Set token update handler
    public func onTokenUpdate(_ handler: @escaping (String) -> Void) {
        tokenUpdateHandler = handler
    }
    
    /// Handle APNs token
    public func setAPNSToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Logger.debug("APNs token set")
    }
}

// MARK: - MessagingDelegate

extension FirebaseMessagingService: MessagingDelegate {
    
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        
        self.fcmToken = token
        Logger.info("FCM Token updated: \(token.prefix(20))...")
        
        // Notify handler
        tokenUpdateHandler?(token)
        
        // Post notification
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: ["token": token]
        )
    }
}

