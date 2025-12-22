import ProjectDescription

public func makeFirebaseCopyScript(for environment: Environment) -> TargetScript {
    return .post(
        script: """
        # Copy the correct GoogleService-Info.plist for \(environment.rawValue)
        FIREBASE_DIR="${SRCROOT}/Configurations/Firebase"
        GOOGLE_SERVICE_INFO_PLIST="${FIREBASE_DIR}/\(environment.rawValue)/GoogleService-Info.plist"
        DESTINATION="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

        if [ -f "${GOOGLE_SERVICE_INFO_PLIST}" ]; then
            echo "Copying GoogleService-Info.plist for \(environment.rawValue) environment"
            cp "${GOOGLE_SERVICE_INFO_PLIST}" "${DESTINATION}"
        else
            echo "warning: GoogleService-Info.plist not found at ${GOOGLE_SERVICE_INFO_PLIST}"
        fi
        """,
        name: "Copy Firebase Configuration",
        basedOnDependencyAnalysis: false
    )
}
