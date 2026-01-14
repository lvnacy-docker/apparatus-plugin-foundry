#!/bin/bash

echo "=================================="
echo "Dev Container Tool Verification"
echo "=================================="
echo ""

# Function to check if a command exists and display its version
check_tool() {
    local tool=$1
    local version_flag=$2
    
    if command -v $tool &> /dev/null; then
        echo "✓ $tool is installed"
        if [ ! -z "$version_flag" ]; then
            echo "  Version: $($tool $version_flag 2>&1 | head -n 1)"
        fi
    else
        echo "✗ $tool is NOT installed"
    fi
    echo ""
}

# Check standard dev tools
echo "Essential Dev Tools:"
echo "-------------------"
check_tool "bash" "--version"

# Check container environment
echo "Container Environment:"
echo "---------------------"
echo "✓ User: $(whoami)"
echo "✓ Working Directory: $(pwd)"
echo "✓ Shell: $SHELL"
echo ""

# ===========================================
# CUSTOMIZE THIS SECTION FOR YOUR LANGUAGE
# ===========================================
# Example customizations:

# For Node.js:
echo "Node.js Tools:"
echo "--------------"
check_tool "node" "--version"
check_tool "npm" "--version"
check_tool "volta" "--version"
echo "Volta home: $VOLTA_HOME"

# For Python:
# echo "Python Tools:"
# echo "-------------"
# check_tool "python3" "--version"
# check_tool "pip3" "--version"
# check_tool "poetry" "--version"

# For Go:
# echo "Go Tools:"
# echo "---------"
# check_tool "go" "version"
# check_tool "gofmt" "-h"

# For Rust:
# echo "Rust Tools:"
# echo "-----------"
# check_tool "rustc" "--version"
# check_tool "cargo" "--version"

# echo "Language-Specific Tools:"
# echo "------------------------"
# echo "⚠️  Add your language-specific tool checks above"
# echo ""

echo "=================================="
echo "Verification Complete!"
echo "Template is ready for customization"
echo "=================================="
