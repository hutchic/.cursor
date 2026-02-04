#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Test script for gpr command

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GPR_SCRIPT="${SCRIPT_DIR}/gpr"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

passed=0
failed=0

test_pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    passed=$((passed + 1))
}

test_fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    failed=$((failed + 1))
}

# Test 1: Help flag
echo "Test 1: Help flag"
if "${GPR_SCRIPT}" --help | grep -q "Usage: gpr"; then
    test_pass "Help flag works"
else
    test_fail "Help flag failed"
fi

# Test 2: No arguments
echo "Test 2: No arguments"
set +e
output=$("${GPR_SCRIPT}" 2>&1)
set -e
if echo "$output" | grep -q "PR title is required"; then
    test_pass "Correctly errors on no arguments"
else
    test_fail "Should error on no arguments"
fi

# Test 3: Invalid snippet mode
echo "Test 3: Invalid snippet mode"
set +e
output=$("${GPR_SCRIPT}" "feat: test" --snippet-mode invalid 2>&1)
set -e
if echo "$output" | grep -q "Invalid snippet mode"; then
    test_pass "Correctly errors on invalid snippet mode"
else
    test_fail "Should error on invalid snippet mode"
fi

# Test 4: File mode without path
echo "Test 4: File mode without path"
set +e
output=$("${GPR_SCRIPT}" "feat: test" --snippet-mode file 2>&1)
set -e
if echo "$output" | grep -q "requires --snippet-path"; then
    test_pass "Correctly errors on file mode without path"
else
    test_fail "Should error on file mode without path"
fi

# Test 5: Paste mode without content
echo "Test 5: Paste mode without content"
set +e
output=$("${GPR_SCRIPT}" "feat: test" --snippet-mode paste 2>&1)
set -e
if echo "$output" | grep -q "requires --snippet-content"; then
    test_pass "Correctly errors on paste mode without content"
else
    test_fail "Should error on paste mode without content"
fi

echo ""
echo "================================"
echo "Test Results: ${passed} passed, ${failed} failed"
echo "================================"

if [ "$failed" -gt 0 ]; then
    exit 1
fi

exit 0
