#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Test script for .cursor self-configuration

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
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

echo "Testing .cursor self-configuration..."
echo "Repository root: ${REPO_ROOT}"
echo ""

# Test 1: .cursor directory exists
echo "Test 1: .cursor directory exists"
if [ -d "${REPO_ROOT}/.cursor" ]; then
    test_pass ".cursor directory exists"
else
    test_fail ".cursor directory not found"
fi

# Test 2: commands symlink exists and is valid
echo "Test 2: commands symlink exists and is valid"
if [ -L "${REPO_ROOT}/.cursor/commands" ]; then
    test_pass "commands is a symlink"
    if [ -d "${REPO_ROOT}/.cursor/commands" ]; then
        test_pass "commands symlink resolves to a directory"
    else
        test_fail "commands symlink does not resolve"
    fi
else
    test_fail "commands is not a symlink"
fi

# Test 3: skills symlink exists and is valid
echo "Test 3: skills symlink exists and is valid"
if [ -L "${REPO_ROOT}/.cursor/skills" ]; then
    test_pass "skills is a symlink"
    if [ -d "${REPO_ROOT}/.cursor/skills" ]; then
        test_pass "skills symlink resolves to a directory"
    else
        test_fail "skills symlink does not resolve"
    fi
else
    test_fail "skills is not a symlink"
fi

# Test 4: commands symlink points to correct target
echo "Test 4: commands symlink points to correct target"
commands_target=$(readlink "${REPO_ROOT}/.cursor/commands")
if [ "${commands_target}" = "../cursor/commands" ]; then
    test_pass "commands symlink points to ../cursor/commands"
else
    test_fail "commands symlink points to ${commands_target} instead of ../cursor/commands"
fi

# Test 5: skills symlink points to correct target
echo "Test 5: skills symlink points to correct target"
skills_target=$(readlink "${REPO_ROOT}/.cursor/skills")
if [ "${skills_target}" = "../cursor/skills" ]; then
    test_pass "skills symlink points to ../cursor/skills"
else
    test_fail "skills symlink points to ${skills_target} instead of ../cursor/skills"
fi

# Test 6: gadd command is accessible through symlink
echo "Test 6: gadd command is accessible through symlink"
if [ -f "${REPO_ROOT}/.cursor/commands/gadd" ]; then
    test_pass "gadd command is accessible"
else
    test_fail "gadd command is not accessible"
fi

# Test 7: gship command is accessible through symlink
echo "Test 7: gship command is accessible through symlink"
if [ -f "${REPO_ROOT}/.cursor/commands/gship" ]; then
    test_pass "gship command is accessible"
else
    test_fail "gship command is not accessible"
fi

# Test 8: README.md exists in .cursor directory
echo "Test 8: README.md exists in .cursor directory"
if [ -f "${REPO_ROOT}/.cursor/README.md" ]; then
    test_pass ".cursor/README.md exists"
else
    test_fail ".cursor/README.md not found"
fi

# Test 9: Verify symlinks are committed to git
echo "Test 9: Verify symlinks are committed to git"
cd "${REPO_ROOT}"
if git ls-files -s .cursor/commands | grep -q "^120000"; then
    test_pass "commands symlink is committed as symlink (mode 120000)"
else
    test_fail "commands symlink is not properly committed to git"
fi

if git ls-files -s .cursor/skills | grep -q "^120000"; then
    test_pass "skills symlink is committed as symlink (mode 120000)"
else
    test_fail "skills symlink is not properly committed to git"
fi

echo ""
echo "========================================="
echo "Test Results:"
echo -e "${GREEN}Passed: ${passed}${NC}"
echo -e "${RED}Failed: ${failed}${NC}"
echo "========================================="

if [ ${failed} -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
