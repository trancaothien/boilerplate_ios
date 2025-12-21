#!/bin/bash

# Script to clean all build caches and regenerate the project
# This helps resolve module resolution issues with Alamofire and Network framework

echo "🧹 Cleaning build caches..."

echo "Tuist clean"
tuist clean

# Clean Tuist build cache
echo "Cleaning Tuist build cache..."
rm -rf Tuist/.build

# Clean Xcode DerivedData
echo "Cleaning Xcode DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData

# Clean Module Cache
echo "Cleaning Module Cache..."
rm -rf ~/Library/Developer/Xcode/ModuleCache.noindex

# Clean Swift Package Manager cache
echo "Cleaning Swift Package Manager cache..."
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf ~/Library/org.swift.swiftpm

# Clean Xcode build products
echo "Cleaning Xcode build products..."
if [ -d "Derived" ]; then
    rm -rf Derived
fi

echo "Tuist install"
tuist install

echo "✅ All caches cleaned!"
echo ""
echo "📦 Regenerating Tuist project..."
tuist generate

echo ""
echo "✅ Done! Please try building your project again in Xcode."

