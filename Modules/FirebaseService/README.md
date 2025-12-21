# FirebaseService Module

FirebaseService module provides a clean, organized interface to Firebase services, separated into submodules for better maintainability.

## Structure

```
FirebaseService/
├── Analyze/          # Firebase Analytics
├── Messaging/        # Firebase Cloud Messaging (FCM)
├── Crashlytics/      # Firebase Crashlytics
├── Storage/          # Firebase Storage
└── Authenticate/     # Firebase Authentication
```

## Services

### 1. FirebaseAnalyticsService

Handles analytics tracking and user properties.

```swift
import FirebaseService

// Log custom event
FirebaseAnalyticsService.shared.logEvent("button_clicked", parameters: [
    "button_name": "login",
    "screen": "home"
])

// Log screen view
FirebaseAnalyticsService.shared.logScreenView(screenName: "Home", screenClass: "HomeViewController")

// Set user property
FirebaseAnalyticsService.shared.setUserProperty("premium", forName: "user_type")

// Set user ID
FirebaseAnalyticsService.shared.setUserId("user123")
```

### 2. FirebaseMessagingService

Handles push notifications and FCM tokens.

```swift
import FirebaseService

// Get FCM token
FirebaseMessagingService.shared.getFCMToken { token in
    print("FCM Token: \(token ?? "nil")")
}

// Subscribe to topic
FirebaseMessagingService.shared.subscribe(toTopic: "news") { error in
    if let error = error {
        print("Error: \(error)")
    }
}

// Listen for token updates
FirebaseMessagingService.shared.onTokenUpdate { token in
    // Send token to your server
    print("New token: \(token)")
}

// Request notification permissions
FirebaseMessagingService.shared.requestNotificationPermissions()
```

### 3. FirebaseCrashlyticsService

Handles crash reporting and error tracking.

```swift
import FirebaseService

// Record error
do {
    try someRiskyOperation()
} catch {
    FirebaseCrashlyticsService.shared.recordError(error, context: "User Action")
}

// Record error with additional info
FirebaseCrashlyticsService.shared.recordError(
    error,
    context: "API Call",
    additionalInfo: [
        "endpoint": "/users",
        "method": "GET"
    ]
)

// Log message
FirebaseCrashlyticsService.shared.log("User completed checkout")

// Set custom key
FirebaseCrashlyticsService.shared.setCustomValue("premium", forKey: "user_type")

// Set user ID
FirebaseCrashlyticsService.shared.setUserID("user123")
```

### 4. FirebaseStorageService

Handles file uploads and downloads.

```swift
import FirebaseService

// Upload data
let imageData = UIImage.pngData(image)()
FirebaseStorageService.shared.uploadData(
    imageData,
    to: "images/profile.jpg"
) { result in
    switch result {
    case .success(let metadata):
        print("Uploaded: \(metadata.path ?? "")")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Upload file from URL
let fileURL = URL(fileURLWithPath: "/path/to/file.pdf")
FirebaseStorageService.shared.uploadFile(
    from: fileURL,
    to: "documents/file.pdf"
) { result in
    // Handle result
}

// Download data
FirebaseStorageService.shared.downloadData(from: "images/profile.jpg") { result in
    switch result {
    case .success(let data):
        let image = UIImage(data: data)
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Get download URL
FirebaseStorageService.shared.getDownloadURL(for: "images/profile.jpg") { result in
    switch result {
    case .success(let url):
        print("Download URL: \(url)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Delete file
FirebaseStorageService.shared.deleteFile(at: "images/old.jpg") { result in
    // Handle result
}
```

### 5. FirebaseAuthService

Handles user authentication.

```swift
import FirebaseService

// Sign up
FirebaseAuthService.shared.signUp(
    email: "user@example.com",
    password: "password123"
) { result in
    switch result {
    case .success(let user):
        print("User signed up: \(user.uid)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Sign in
FirebaseAuthService.shared.signIn(
    email: "user@example.com",
    password: "password123"
) { result in
    // Handle result
}

// Sign out
do {
    try FirebaseAuthService.shared.signOut()
} catch {
    print("Error: \(error)")
}

// Check if signed in
if FirebaseAuthService.shared.isSignedIn {
    let user = FirebaseAuthService.shared.currentUser
    print("User: \(user?.email ?? "")")
}

// Update profile
FirebaseAuthService.shared.updateProfile(
    displayName: "John Doe",
    photoURL: photoURL
) { result in
    // Handle result
}

// Send password reset
FirebaseAuthService.shared.sendPasswordReset(email: "user@example.com") { result in
    // Handle result
}

// Listen to auth state changes
let handle = FirebaseAuthService.shared.addAuthStateListener { user in
    if let user = user {
        print("User signed in: \(user.uid)")
    } else {
        print("User signed out")
    }
}

// Remove listener
FirebaseAuthService.shared.removeAuthStateListener(handle)
```

## Configuration

All services automatically respect the app's environment configuration:

- **Develop/Staging**: Analytics and Crashlytics enabled for debugging
- **Sandbox/Production**: Full analytics and crash reporting enabled

Services check `AppConfiguration.shared.shouldEnableAnalytics` to determine if they should be active.

## Integration

The services are automatically initialized in `AppDelegate`:

```swift
func configureFirebase() {
    FirebaseApp.configure()
    
    // Services initialize themselves
    _ = FirebaseAnalyticsService.shared
    _ = FirebaseCrashlyticsService.shared
    _ = FirebaseMessagingService.shared
    _ = FirebaseStorageService.shared
    _ = FirebaseAuthService.shared
}
```

## Dependencies

- `Core` module (for Logger and AppConfiguration)
- `FirebaseAnalytics`
- `FirebaseCrashlytics`
- `FirebaseMessaging`
- `FirebaseStorage`
- `FirebaseAuth`

