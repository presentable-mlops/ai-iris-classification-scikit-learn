#!/bin/bash

# Colors for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper function for styled output
print_info() {
    echo -e "${BLUE}${BOLD}$1${NC}"
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

# Banner function
print_banner() {
    local width=80
    local padding_char="="
    local title="$1"

    # Calculate padding
    local title_length=${#title}
    local padding_length=$(( (width - title_length - 2) / 2 ))

    # Declare and assign separately to avoid masking return values
    local padding
    padding=$(printf "%${padding_length}s" "" | tr ' ' "$padding_char")

    # Print the banner
    echo
    echo -e "${BLUE}${BOLD}${padding} ${title} ${padding}${NC}"
    echo -e "${CYAN}Date: $(date)${NC}"
    echo -e "${CYAN}User: $(whoami)${NC}"

    # Only show environment if it's already set
    if [[ -n "${ENVIRONMENT:-}" ]]; then
        echo -e "${CYAN}Environment: ${ENVIRONMENT}${NC}"
    fi

    local full_padding
    full_padding=$(printf "%${width}s" "" | tr ' ' "$padding_char")
    echo -e "${BLUE}${BOLD}${full_padding}${NC}"
    echo
}

# Welcome message
print_banner "🚀 OSS Repository Template"
print_info "Setting up repository..."

# Initialize pre-commit hooks
print_success "Initializing pre-commit hooks..."
pre-commit install

print_info "Running pre-commit hooks..."
if ! pre-commit run --all-files; then
    print_error "Pre-commit hooks failed. Please fix the issues and try again."
    exit 1
fi

cat <<EOF
Your development environment is ready!

This template includes:
 ✓ Default community health files like CODE_OF_CONDUCT.md, CONTRIBUTING.md, ISSUE_TEMPLATE, LICENSE
 ✓ GitHub workflow automations
 ✓ Pre-configured VS Code extensions
 ✓ Pre-commit hooks for code quality
 ✓ GitHub Copilot integration
 ✓ Docker support

Happy coding! 🎉
EOF

exit 0
