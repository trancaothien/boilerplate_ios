# BoilerplateIOS Makefile
# Usage: make <command>
# List all commands: make help

.PHONY: help setup install generate clean reset build test lint format open

# Colors for output
GREEN  := \033[0;32m
YELLOW := \033[0;33m
BLUE   := \033[0;34m
RED    := \033[0;31m
NC     := \033[0m # No Color

# Default target
.DEFAULT_GOAL := help

#==============================================================================
# HELP
#==============================================================================

help: ## Show list of available commands
	@echo ""
	@echo "$(BLUE)╔══════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║         BoilerplateIOS - Tuist Commands                      ║$(NC)"
	@echo "$(BLUE)╚══════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(YELLOW)Usage:$(NC) make $(GREEN)<command>$(NC)"
	@echo ""
	@echo "$(YELLOW)Commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

#==============================================================================
# SETUP & INSTALLATION
#==============================================================================

setup: ## Install dependencies and generate project (first time setup)
	@echo "$(BLUE)🚀 Setting up project...$(NC)"
	@make install
	@make generate
	@echo "$(GREEN)✅ Setup complete!$(NC)"

install: ## Install Swift Package dependencies
	@echo "$(BLUE)📦 Installing dependencies...$(NC)"
	@tuist install
	@echo "$(GREEN)✅ Dependencies installed!$(NC)"

generate: ## Generate Xcode project
	@echo "$(BLUE)🔨 Generating Xcode project...$(NC)"
	@tuist generate
	@echo "$(GREEN)✅ Project generated!$(NC)"

#==============================================================================
# CLEANING
#==============================================================================

clean: ## Clean Tuist cache
	@echo "$(BLUE)🧹 Cleaning Tuist cache...$(NC)"
	@tuist clean
	@echo "$(GREEN)✅ Tuist cache cleaned!$(NC)"

clean-derived: ## Clean Xcode DerivedData
	@echo "$(BLUE)🧹 Cleaning Xcode DerivedData...$(NC)"
	@rm -rf ~/Library/Developer/Xcode/DerivedData
	@rm -rf Derived
	@echo "$(GREEN)✅ DerivedData cleaned!$(NC)"

clean-spm: ## Clean Swift Package Manager cache
	@echo "$(BLUE)🧹 Cleaning SPM cache...$(NC)"
	@rm -rf ~/Library/Caches/org.swift.swiftpm
	@rm -rf ~/Library/org.swift.swiftpm
	@rm -rf Tuist/.build
	@echo "$(GREEN)✅ SPM cache cleaned!$(NC)"

clean-modules: ## Clean Xcode Module Cache
	@echo "$(BLUE)🧹 Cleaning Xcode Module Cache...$(NC)"
	@rm -rf ~/Library/Developer/Xcode/ModuleCache.noindex
	@echo "$(GREEN)✅ Module cache cleaned!$(NC)"

clean-all: ## Clean all caches (Tuist + Xcode + SPM)
	@echo "$(BLUE)🧹 Cleaning all caches...$(NC)"
	@make clean
	@make clean-derived
	@make clean-spm
	@make clean-modules
	@echo "$(GREEN)✅ All caches cleaned!$(NC)"

reset: ## Reset everything and regenerate project (= tuist_reset.sh)
	@echo "$(BLUE)🔄 Resetting project...$(NC)"
	@make clean-all
	@make install
	@make generate
	@echo "$(GREEN)✅ Project reset complete!$(NC)"

#==============================================================================
# BUILD & TEST
#==============================================================================

build-dev: ## Build with Develop scheme
	@echo "$(BLUE)🔨 Building Develop...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Develop \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		build | xcpretty || xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Develop \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		build

build-staging: ## Build with Staging scheme
	@echo "$(BLUE)🔨 Building Staging...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Staging \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		build | xcpretty || xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Staging \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		build

build-sandbox: ## Build with Sandbox scheme
	@echo "$(BLUE)🔨 Building Sandbox...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Sandbox \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		build | xcpretty || xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Sandbox \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		build

build-prod: ## Build with Production scheme
	@echo "$(BLUE)🔨 Building Production...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Production \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		build | xcpretty || xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Production \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		build

test: ## Run unit tests
	@echo "$(BLUE)🧪 Running tests...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Develop \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		test | xcpretty || xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Develop \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		test

#==============================================================================
# ARCHIVE & RELEASE
#==============================================================================

archive-dev: ## Archive for Develop
	@echo "$(BLUE)📦 Archiving Develop...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Develop \
		-configuration Develop-Release \
		-archivePath build/BoilerplateIOS-Develop.xcarchive \
		archive

archive-staging: ## Archive for Staging
	@echo "$(BLUE)📦 Archiving Staging...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Staging \
		-configuration Staging-Release \
		-archivePath build/BoilerplateIOS-Staging.xcarchive \
		archive

archive-sandbox: ## Archive for Sandbox
	@echo "$(BLUE)📦 Archiving Sandbox...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Sandbox \
		-configuration Sandbox-Release \
		-archivePath build/BoilerplateIOS-Sandbox.xcarchive \
		archive

archive-prod: ## Archive for Production
	@echo "$(BLUE)📦 Archiving Production...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Production \
		-configuration Production-Release \
		-archivePath build/BoilerplateIOS-Production.xcarchive \
		archive

#==============================================================================
# UTILITIES
#==============================================================================

open: ## Open project in Xcode
	@echo "$(BLUE)📂 Opening Xcode...$(NC)"
	@open BoilerplateIOS.xcworkspace

edit: ## Open Tuist manifest files for editing
	@echo "$(BLUE)📝 Opening Tuist manifests...$(NC)"
	@tuist edit

graph: ## Generate dependency graph
	@echo "$(BLUE)📊 Generating dependency graph...$(NC)"
	@tuist graph
	@echo "$(GREEN)✅ Graph generated! Opening...$(NC)"
	@open graph.png 2>/dev/null || open graph.pdf 2>/dev/null || echo "Graph file created"

info: ## Show project information
	@echo ""
	@echo "$(BLUE)╔══════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║              BoilerplateIOS - Project Info                   ║$(NC)"
	@echo "$(BLUE)╚══════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(YELLOW)Schemes:$(NC)"
	@echo "  • BoilerplateIOS-Develop"
	@echo "  • BoilerplateIOS-Staging"
	@echo "  • BoilerplateIOS-Sandbox"
	@echo "  • BoilerplateIOS-Production"
	@echo ""
	@echo "$(YELLOW)Configurations:$(NC)"
	@echo "  • Develop / Develop-Release"
	@echo "  • Staging / Staging-Release"
	@echo "  • Sandbox / Sandbox-Release"
	@echo "  • Production / Production-Release"
	@echo ""
	@echo "$(YELLOW)Modules:$(NC)"
	@echo "  • Core (Framework)"
	@echo "  • Networking (Framework)"
	@echo ""

version: ## Show Tuist version
	@tuist version

#==============================================================================
# CI/CD
#==============================================================================

ci-setup: ## Setup for CI/CD environment
	@echo "$(BLUE)🤖 Setting up CI environment...$(NC)"
	@make install
	@make generate
	@echo "$(GREEN)✅ CI setup complete!$(NC)"

ci-build: ## Build for CI (without xcpretty)
	@echo "$(BLUE)🤖 CI Build...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Develop \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		-quiet \
		build

ci-test: ## Test for CI (with output format)
	@echo "$(BLUE)🤖 CI Test...$(NC)"
	@xcodebuild -workspace BoilerplateIOS.xcworkspace \
		-scheme BoilerplateIOS-Develop \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		-resultBundlePath TestResults.xcresult \
		test
