#!/bin/bash

# Script to run all integration tests sequentially
# This handles the debug connection issues by running tests one at a time

echo "🚀 Running All Integration Tests Sequentially"
echo "=============================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counter for results
PASSED=0
FAILED=0
TOTAL=0

# Function to run a single test
run_test() {
    local test_file=$1
    local test_name=$2
    
    echo -e "${BLUE}▶ Running: ${test_name}${NC}"
    echo "   File: ${test_file}"
    echo ""
    
    TOTAL=$((TOTAL + 1))
    
    # Kill any existing Flutter processes
    pkill -f flutter > /dev/null 2>&1
    sleep 2
    
    # Run the test
    if flutter test "$test_file" -d linux; then
        echo -e "${GREEN}✅ PASSED: ${test_name}${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}❌ FAILED: ${test_name}${NC}"
        FAILED=$((FAILED + 1))
    fi
    
    echo ""
    echo "---"
    echo ""
    
    # Kill Flutter processes after test
    pkill -f flutter > /dev/null 2>&1
    sleep 1
}

# Run all tests
echo -e "${YELLOW}🎯 Core Tests${NC}"
run_test "integration_test/form_validation_test.dart" "Form Validation Tests"
run_test "integration_test/resident_toggle_test.dart" "Resident Toggle Tests"  
run_test "integration_test/reset_button_test.dart" "Reset Button Tests"

echo -e "${YELLOW}🚀 Advanced Tests${NC}"
run_test "integration_test/toggle_demo_test.dart" "Toggle Dependencies Demo"
run_test "integration_test/json_form_test.dart" "JSON Form Tests (may have issues)"

echo -e "${YELLOW}📋 Comprehensive Suite${NC}"
run_test "integration_test/app_test.dart" "App Integration Tests"

# Final summary
echo "=============================================="
echo -e "${BLUE}🏁 FINAL RESULTS${NC}"
echo "=============================================="
echo -e "Total tests: ${TOTAL}"
echo -e "${GREEN}Passed: ${PASSED}${NC}"
echo -e "${RED}Failed: ${FAILED}${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some tests failed. Check output above for details.${NC}"
    exit 1
fi