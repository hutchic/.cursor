#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Test script for gship command

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GSHIP_SCRIPT="${SCRIPT_DIR}/../cursor/commands/gship"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

passed=0
failed=0
skipped=0

test_pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    passed=$((passed + 1))
}

test_fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    failed=$((failed + 1))
}

test_skip() {
    echo -e "${YELLOW}⊘ SKIP${NC}: $1"
    skipped=$((skipped + 1))
}

echo "Testing gship command..."
echo ""

# Test 1: No arguments
echo "Test 1: No arguments"
set +e
output=$("${GSHIP_SCRIPT}" 2>&1)
exit_code=$?
set -e
if [ $exit_code -ne 0 ] && echo "$output" | grep -q "Missing semantic commit message"; then
    test_pass "Correctly errors on no arguments"
else
    test_fail "Should error on no arguments"
fi

# Test 2: Invalid semantic message
echo "Test 2: Invalid semantic message"
set +e
output=$("${GSHIP_SCRIPT}" "invalid message" 2>&1)
exit_code=$?
set -e
if [ $exit_code -ne 0 ] && echo "$output" | grep -q "Invalid semantic commit format"; then
    test_pass "Correctly errors on invalid semantic message"
else
    test_fail "Should error on invalid semantic message"
fi

# Test 3: Valid semantic message without scope
echo "Test 3: Valid semantic message format validation (without scope)"
set +e
output=$("${GSHIP_SCRIPT}" "feat: add feature" 2>&1)
exit_code=$?
set -e
# Should fail because we're not in the right git state, but shouldn't fail on message validation
if echo "$output" | grep -q "Invalid semantic commit format"; then
    test_fail "Should accept valid semantic message without scope"
else
    test_pass "Accepts valid semantic message without scope"
fi

# Test 4: Valid semantic message with scope
echo "Test 4: Valid semantic message format validation (with scope)"
set +e
output=$("${GSHIP_SCRIPT}" "feat(api): add endpoint" 2>&1)
exit_code=$?
set -e
# Should fail because we're not in the right git state, but shouldn't fail on message validation
if echo "$output" | grep -q "Invalid semantic commit format"; then
    test_fail "Should accept valid semantic message with scope"
else
    test_pass "Accepts valid semantic message with scope"
fi

# Test 5: Invalid semantic type
echo "Test 5: Invalid semantic type"
set +e
output=$("${GSHIP_SCRIPT}" "invalid-type: message" 2>&1)
exit_code=$?
set -e
if [ $exit_code -ne 0 ] && echo "$output" | grep -q "Invalid semantic commit format"; then
    test_pass "Correctly rejects invalid semantic type"
else
    test_fail "Should reject invalid semantic type"
fi

# Test 6: --no-pr flag parsing
echo "Test 6: --no-pr flag parsing"
set +e
output=$("${GSHIP_SCRIPT}" "feat: test" --no-pr 2>&1)
exit_code=$?
set -e
# Just verify the flag doesn't cause a parse error - actual behavior will fail due to git state
if echo "$output" | grep -q "Invalid mode\|Unknown option"; then
    test_fail "--no-pr flag should be accepted"
else
    test_pass "--no-pr flag is accepted"
fi

# Test 7: --mode flag parsing
echo "Test 7: --mode flag parsing"
set +e
output=$("${GSHIP_SCRIPT}" "feat: test" --mode=single 2>&1)
exit_code=$?
set -e
# Just verify the flag doesn't cause a parse error
if echo "$output" | grep -q "Invalid mode: single"; then
    test_fail "--mode=single should be accepted"
else
    test_pass "--mode=single is accepted"
fi

# Test 8: Invalid mode value
echo "Test 8: Invalid mode value"
set +e
output=$("${GSHIP_SCRIPT}" "feat: test" --mode=invalid 2>&1)
exit_code=$?
set -e
if [ $exit_code -ne 0 ] && echo "$output" | grep -q "Invalid mode"; then
    test_pass "Correctly rejects invalid mode value"
else
    test_fail "Should reject invalid mode value"
fi

# Test 9: Command path finding (gadd)
echo "Test 9: Command path finding (gadd)"
if [ -x "${SCRIPT_DIR}/../cursor/commands/gadd" ]; then
    test_pass "gadd command is found and executable"
else
    test_fail "gadd command should be found and executable"
fi

# Test 10: Command path finding (gpr)
echo "Test 10: Command path finding (gpr)"
if [ -x "${SCRIPT_DIR}/gpr" ]; then
    test_pass "gpr command is found and executable"
else
    test_fail "gpr command should be found and executable"
fi

echo ""
echo "================================"
echo "Test Results: ${passed} passed, ${failed} failed, ${skipped} skipped"
echo "================================"

if [ "$failed" -gt 0 ]; then
    exit 1
fi

exit 0
