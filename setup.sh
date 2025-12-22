#!/bin/bash

# BoilerplateIOS Setup Script
# This script helps configure a new project from this boilerplate

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored message
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_step() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Get current directory name
CURRENT_DIR=$(basename "$(pwd)")
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get inputs
print_step "Project Setup Configuration"

read -p "Enter new project name (e.g., MyApp): " NEW_PROJECT_NAME
if [ -z "$NEW_PROJECT_NAME" ]; then
    print_error "Project name cannot be empty"
    exit 1
fi

read -p "Enter new app name (e.g., My App): " NEW_APP_NAME
if [ -z "$NEW_APP_NAME" ]; then
    NEW_APP_NAME="$NEW_PROJECT_NAME"
fi

read -p "Enter new bundle ID (e.g., com.company.myapp): " NEW_BUNDLE_ID
if [ -z "$NEW_BUNDLE_ID" ]; then
    print_error "Bundle ID cannot be empty"
    exit 1
fi

# Validate bundle ID format
if [[ ! "$NEW_BUNDLE_ID" =~ ^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$ ]]; then
    print_warning "Bundle ID format might be invalid. Expected format: com.company.appname"
    read -p "Continue anyway? (y/n): " CONTINUE
    if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
        exit 1
    fi
fi

echo ""
print_info "Configuration Summary:"
echo "  Project Name: $NEW_PROJECT_NAME"
echo "  App Name: $NEW_APP_NAME"
echo "  Bundle ID: $NEW_BUNDLE_ID"
echo ""
read -p "Continue with setup? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    print_info "Setup cancelled"
    exit 0
fi

# Step 1: Remove Git and reinitialize
print_step "Step 1: Reinitializing Git Repository"

if [ -d ".git" ]; then
    print_info "Removing existing .git directory..."
    rm -rf .git
    print_success "Git repository removed"
fi

print_info "Initializing new Git repository..."
git init
print_success "Git repository initialized"

# Step 2: Update Bundle IDs
print_step "Step 2: Updating Bundle IDs"

# Update Project.swift
print_info "Updating Project.swift..."
sed -i '' "s/com\.tt\.studio\.boilerplate-ios/$NEW_BUNDLE_ID/g" Project.swift
sed -i '' "s/com\.tt\.studio\.core/$NEW_BUNDLE_ID.core/g" Project.swift
sed -i '' "s/com\.tt\.studio\.networking/$NEW_BUNDLE_ID.networking/g" Project.swift
sed -i '' "s/com\.tt\.studio\.firebaseservice/$NEW_BUNDLE_ID.firebaseservice/g" Project.swift
print_success "Project.swift updated"

# Update XCConfig files
print_info "Updating XCConfig files..."
find Configurations/XCConfig -name "*.xcconfig" -type f -exec sed -i '' "s/com\.tt\.studio\.boilerplate-ios/$NEW_BUNDLE_ID/g" {} \;
print_success "XCConfig files updated"

# Step 3: Update App Names
print_step "Step 3: Updating App Names"

# Update XCConfig files with app names
print_info "Updating app names in XCConfig files..."
sed -i '' "s/APP_NAME = BoilerplateIOS Dev/APP_NAME = $NEW_APP_NAME Dev/g" Configurations/XCConfig/Develop.xcconfig
sed -i '' "s/APP_NAME = BoilerplateIOS Stg/APP_NAME = $NEW_APP_NAME Stg/g" Configurations/XCConfig/Staging.xcconfig
sed -i '' "s/APP_NAME = BoilerplateIOS Sbx/APP_NAME = $NEW_APP_NAME Sbx/g" Configurations/XCConfig/Sandbox.xcconfig
sed -i '' "s/APP_NAME = BoilerplateIOS$/APP_NAME = $NEW_APP_NAME/g" Configurations/XCConfig/Production.xcconfig
print_success "App names updated"

# Update Project.swift app names
print_info "Updating app names in Project.swift..."
sed -i '' "s/Boilerplate Dev/$NEW_APP_NAME Dev/g" Project.swift
sed -i '' "s/Boilerplate Stg/$NEW_APP_NAME Stg/g" Project.swift
sed -i '' "s/Boilerplate Sbx/$NEW_APP_NAME Sbx/g" Project.swift
sed -i '' "s/Boilerplate\"/$NEW_APP_NAME\"/g" Project.swift
print_success "Project.swift app names updated"

# Step 4: Update Project Name
print_step "Step 4: Updating Project Name"

# Update Project.swift - project name, target names, folder paths
print_info "Updating project name in Project.swift..."
sed -i '' "s/name: \"BoilerplateIOS\"/name: \"$NEW_PROJECT_NAME\"/g" Project.swift
sed -i '' "s/BoilerplateIOS-/$NEW_PROJECT_NAME-/g" Project.swift
sed -i '' "s/BoilerplateIOS\//$NEW_PROJECT_NAME\//g" Project.swift
sed -i '' "s/name: \"BoilerplateIOSTests\"/name: \"${NEW_PROJECT_NAME}Tests\"/g" Project.swift
sed -i '' "s/BoilerplateIOSTests/$NEW_PROJECT_NAMETests/g" Project.swift
print_success "Project.swift updated"

# Update Package.swift
print_info "Updating Package.swift..."
sed -i '' "s/name: \"BoilerplateIOS\"/name: \"$NEW_PROJECT_NAME\"/g" Tuist/Package.swift
print_success "Package.swift updated"

# Update Makefile - workspace name, scheme names, target names, comments
print_info "Updating Makefile..."
# Replace workspace name
sed -i '' "s/BoilerplateIOS\.xcworkspace/$NEW_PROJECT_NAME.xcworkspace/g" Makefile
# Replace scheme names (BoilerplateIOS-Develop, etc.)
sed -i '' "s/-scheme BoilerplateIOS-/-scheme $NEW_PROJECT_NAME-/g" Makefile
sed -i '' "s/BoilerplateIOS-/$NEW_PROJECT_NAME-/g" Makefile
# Replace in comments and help text
sed -i '' "s/BoilerplateIOS /$NEW_PROJECT_NAME /g" Makefile
sed -i '' "s/BoilerplateIOS\$/$NEW_PROJECT_NAME/g" Makefile
# Replace in archive paths
sed -i '' "s/BoilerplateIOS-Develop\.xcarchive/$NEW_PROJECT_NAME-Develop.xcarchive/g" Makefile
sed -i '' "s/BoilerplateIOS-Staging\.xcarchive/$NEW_PROJECT_NAME-Staging.xcarchive/g" Makefile
sed -i '' "s/BoilerplateIOS-Sandbox\.xcarchive/$NEW_PROJECT_NAME-Sandbox.xcarchive/g" Makefile
sed -i '' "s/BoilerplateIOS-Production\.xcarchive/$NEW_PROJECT_NAME-Production.xcarchive/g" Makefile
# Replace in header comments
sed -i '' "s/# BoilerplateIOS Makefile/# $NEW_PROJECT_NAME Makefile/g" Makefile
sed -i '' "s/BoilerplateIOS - Tuist Commands/$NEW_PROJECT_NAME - Tuist Commands/g" Makefile
sed -i '' "s/BoilerplateIOS - Project Info/$NEW_PROJECT_NAME - Project Info/g" Makefile
print_success "Makefile updated"

# Update test file (before folder rename)
print_info "Updating test files..."
if [ -f "BoilerplateIOS/Tests/BoilerplateIosTests.swift" ]; then
    # Replace import statement (case-insensitive)
    sed -i '' "s/@testable import BoilerplateIos/@testable import $NEW_PROJECT_NAME/g" BoilerplateIOS/Tests/BoilerplateIosTests.swift
    sed -i '' "s/@testable import BoilerplateIOS/@testable import $NEW_PROJECT_NAME/g" BoilerplateIOS/Tests/BoilerplateIosTests.swift
    # Replace struct name
    sed -i '' "s/struct BoilerplateIosTests/struct ${NEW_PROJECT_NAME}Tests/g" BoilerplateIOS/Tests/BoilerplateIosTests.swift
    print_success "Test files updated"
fi

# Update README.md
print_info "Updating README.md..."
if [ -f "README.md" ]; then
    sed -i '' "s/BoilerplateIOS/$NEW_PROJECT_NAME/g" README.md
    print_success "README.md updated"
fi

# Update setup.sh comments (for future reference)
print_info "Updating setup.sh comments..."
sed -i '' "s/# BoilerplateIOS Setup Script/# $NEW_PROJECT_NAME Setup Script/g" setup.sh
print_success "setup.sh updated"

# Step 5: Delete GoogleService-Info.plist files
print_step "Step 5: Removing Firebase Configuration Files"

print_info "Removing GoogleService-Info.plist files..."
find Configurations/Firebase -name "GoogleService-Info.plist" -type f -delete
print_success "Firebase configuration files removed"

# Create placeholder files
print_info "Creating placeholder files..."
for env in Develop Staging Sandbox Production; do
    cat > "Configurations/Firebase/$env/GoogleService-Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!--
    ============================================
    $env ENVIRONMENT - Firebase Configuration
    ============================================
    
    Replace this file with your actual GoogleService-Info.plist
    downloaded from Firebase Console for the $env environment.
    
    Steps:
    1. Go to Firebase Console (https://console.firebase.google.com)
    2. Select your $env project
    3. Go to Project Settings > General
    4. Download GoogleService-Info.plist
    5. Replace this file with the downloaded one
    ============================================
    -->
    <key>BUNDLE_ID</key>
    <string>$NEW_BUNDLE_ID</string>
    <key>PROJECT_ID</key>
    <string>your-$env-project-id</string>
</dict>
</plist>
EOF
done
print_success "Placeholder Firebase files created"

# Step 6: Rename BoilerplateIOS folder
print_step "Step 6: Renaming Project Folder"

if [ -d "BoilerplateIOS" ]; then
    print_info "Renaming BoilerplateIOS folder to $NEW_PROJECT_NAME..."
    mv "BoilerplateIOS" "$NEW_PROJECT_NAME"
    print_success "Folder renamed from BoilerplateIOS to $NEW_PROJECT_NAME"
    
    # Update Project.swift with new folder path
    print_info "Updating folder paths in Project.swift..."
    sed -i '' "s/BoilerplateIOS\/Sources/$NEW_PROJECT_NAME\/Sources/g" Project.swift
    sed -i '' "s/BoilerplateIOS\/Resources/$NEW_PROJECT_NAME\/Resources/g" Project.swift
    sed -i '' "s/BoilerplateIOS\/Tests/$NEW_PROJECT_NAME\/Tests/g" Project.swift
    print_success "Folder paths updated in Project.swift"
    
    # Update test files in the renamed folder
    if [ -f "$NEW_PROJECT_NAME/Tests/BoilerplateIosTests.swift" ]; then
        print_info "Updating test files in renamed folder..."
        sed -i '' "s/@testable import BoilerplateIos/@testable import $NEW_PROJECT_NAME/g" "$NEW_PROJECT_NAME/Tests/BoilerplateIosTests.swift" 2>/dev/null || true
        sed -i '' "s/@testable import BoilerplateIOS/@testable import $NEW_PROJECT_NAME/g" "$NEW_PROJECT_NAME/Tests/BoilerplateIosTests.swift" 2>/dev/null || true
        sed -i '' "s/struct BoilerplateIosTests/struct ${NEW_PROJECT_NAME}Tests/g" "$NEW_PROJECT_NAME/Tests/BoilerplateIosTests.swift" 2>/dev/null || true
        # Rename test file if needed
        if [ -f "$NEW_PROJECT_NAME/Tests/BoilerplateIosTests.swift" ] && [ ! -f "$NEW_PROJECT_NAME/Tests/${NEW_PROJECT_NAME}Tests.swift" ]; then
            mv "$NEW_PROJECT_NAME/Tests/BoilerplateIosTests.swift" "$NEW_PROJECT_NAME/Tests/${NEW_PROJECT_NAME}Tests.swift" 2>/dev/null || true
        fi
        print_success "Test files updated in renamed folder"
    fi
else
    print_warning "BoilerplateIOS folder not found, skipping rename"
fi

# Check root folder name
CURRENT_FOLDER=$(basename "$PROJECT_ROOT")
if [ "$CURRENT_FOLDER" != "$NEW_PROJECT_NAME" ]; then
    print_warning "Current root folder name is '$CURRENT_FOLDER' but project name is '$NEW_PROJECT_NAME'"
    print_info "You may want to rename the root folder manually:"
    echo "  cd .."
    echo "  mv $CURRENT_FOLDER $NEW_PROJECT_NAME"
    echo "  cd $NEW_PROJECT_NAME"
else
    print_success "Root folder name matches project name"
fi

# Step 7: Final comprehensive replacement
print_step "Step 7: Final Comprehensive Replacement"

# Replace any remaining instances of BoilerplateIOS in all Swift files
print_info "Replacing remaining BoilerplateIOS references in Swift files..."
find . -type f -name "*.swift" -not -path "./.git/*" -not -path "./Tuist/.build/*" -exec sed -i '' "s/BoilerplateIOS/$NEW_PROJECT_NAME/g" {} \;
print_success "Swift files updated"

# Replace in XCConfig files (comprehensive)
print_info "Replacing BoilerplateIOS in XCConfig files..."
find Configurations/XCConfig -name "*.xcconfig" -type f -exec sed -i '' "s/BoilerplateIOS/$NEW_PROJECT_NAME/g" {} \;
print_success "XCConfig files updated"

# Update README.md (if not already updated)
if [ -f "README.md" ]; then
    print_info "Final update to README.md..."
    sed -i '' "s/BoilerplateIOS/$NEW_PROJECT_NAME/g" README.md 2>/dev/null || true
    sed -i '' "s/Boilerplate/$NEW_APP_NAME/g" README.md 2>/dev/null || true
    print_success "README.md updated"
fi

# Final summary
print_step "Setup Complete!"

print_success "Project has been configured with:"
echo "  • Project Name: $NEW_PROJECT_NAME"
echo "  • App Name: $NEW_APP_NAME"
echo "  • Bundle ID: $NEW_BUNDLE_ID"
echo "  • Git repository reinitialized"
echo "  • Firebase configuration files removed (placeholders created)"

echo ""
print_step "Next Steps"

echo ""
echo -e "${YELLOW}1. Configure Firebase:${NC}"
echo "   • Go to Firebase Console (https://console.firebase.google.com)"
echo "   • Create projects for each environment (Develop, Staging, Sandbox, Production)"
echo "   • Download GoogleService-Info.plist for each environment"
echo "   • Replace files in Configurations/Firebase/[Environment]/GoogleService-Info.plist"
echo ""

echo -e "${YELLOW}2. Update Code Signing:${NC}"
echo "   • Open Configurations/XCConfig/*.xcconfig files"
echo "   • Uncomment and update:"
echo "     - CODE_SIGN_IDENTITY"
echo "     - DEVELOPMENT_TEAM"
echo "     - PROVISIONING_PROFILE_SPECIFIER"
echo ""

echo -e "${YELLOW}3. Update API Configuration:${NC}"
echo "   • Open Configurations/XCConfig/*.xcconfig files"
echo "   • Update API_BASE_URL for each environment"
echo ""

echo -e "${YELLOW}4. Install Dependencies:${NC}"
echo "   • Run: make install"
echo "   • Or: tuist install"
echo ""

echo -e "${YELLOW}5. Generate Xcode Project:${NC}"
echo "   • Run: make generate"
echo "   • Or: tuist generate"
echo ""

echo -e "${YELLOW}6. Open Project:${NC}"
echo "   • Run: make open"
echo "   • Or: open $NEW_PROJECT_NAME.xcworkspace"
echo ""

echo -e "${YELLOW}7. Build and Run:${NC}"
echo "   • Select a scheme (e.g., $NEW_PROJECT_NAME-Develop)"
echo "   • Build and run (Cmd+R)"
echo ""

echo -e "${YELLOW}8. Verify Changes:${NC}"
echo "   • Check that all 'BoilerplateIOS' references have been replaced"
echo "   • Verify Makefile commands use '$NEW_PROJECT_NAME'"
echo "   • Confirm folder structure is correct"
echo ""

if [ "$CURRENT_FOLDER" != "$NEW_PROJECT_NAME" ]; then
    echo -e "${YELLOW}8. Rename Project Folder (Optional):${NC}"
    echo "   • cd .."
    echo "   • mv $CURRENT_FOLDER $NEW_PROJECT_NAME"
    echo "   • cd $NEW_PROJECT_NAME"
    echo ""
fi

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Setup completed successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

