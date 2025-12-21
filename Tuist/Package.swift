// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Using staticFramework for better compatibility
        productTypes: [
            "Alamofire": .staticFramework,
            "FirebaseAnalytics": .staticFramework,
            "FirebaseCrashlytics": .staticFramework,
            "FirebaseMessaging": .staticFramework,
            "FirebaseStorage": .staticFramework,
            "FirebaseAuth": .staticFramework,
            "GoogleUtilities": .staticFramework,
            "GoogleDataTransport": .staticFramework,
            "Promises": .staticFramework,
        ]
    )
#endif

let package = Package(
    name: "BoilerplateIOS",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", exact: "5.11.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "11.6.0"),
    ]
)
