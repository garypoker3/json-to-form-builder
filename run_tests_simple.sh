#!/bin/bash

echo "🚀 Running Integration Tests with Concurrency Control"
echo "===================================================="

# Method 1: Use concurrency control (recommended for CI/CD)
echo "📋 Method 1: Sequential with concurrency control"
flutter test integration_test/ -d linux --concurrency=1

echo ""
echo "===================================================="
echo "📋 Method 2: Individual test runs (if Method 1 fails)"
echo "Run these commands individually:"
echo ""
echo "flutter test integration_test/toggle_demo_test.dart -d linux"
echo "flutter test integration_test/form_validation_test.dart -d linux" 
echo "flutter test integration_test/resident_toggle_test.dart -d linux"
echo "flutter test integration_test/reset_button_test.dart -d linux"
echo "flutter test integration_test/app_test.dart -d linux"
echo ""
echo "📋 Method 3: Use VS Code 'Run and Debug' panel"
echo "Select 'Run All Integration Tests (Master File)'"