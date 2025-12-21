import UIKit
import Core

/// App State to manage global state
/// This is a shared state object that can be used across the app
class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: String?
    
    static let shared = AppState()
    
    private init() {
        // Load app state if needed
    }
}

// Note: @main entry point is now in AppDelegate.swift
// This file is kept for AppState management
// The app uses UIKit with Coordinator pattern, managed by SceneDelegate (iOS 13+)
// or AppDelegate (iOS 12 and below)

