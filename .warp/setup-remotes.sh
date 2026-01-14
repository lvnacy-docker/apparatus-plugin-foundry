#!/bin/bash

# Dual Remote Setup Script
# Configures Git remotes and initializes the dual repository structure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[SETUP]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

prompt() {
    echo -e "${YELLOW}[INPUT]${NC} $1"
}

# Verify we're in a git repository
if [ ! -d ".git" ]; then
    error "Not in a git repository. Initialize git first with: git init"
fi

echo "=== Node.js Dev Container - Dual Remote Management ==="
echo
echo "This script can:"
echo "  • Set up initial dual remote configuration"
echo "  • Update existing remote URLs (e.g., moving to lvnacy-docker space)"
echo "  • Selectively update private or public remotes"
echo
echo "Repository Types:"
echo "  • Private repository: Complete project (WARP.md, .warp/, all files)"
echo "  • Public repository:  Docker container only (Dockerfile, README, CHANGELOG, LICENSE)"
echo
echo "TIP: Run '.warp/status-remotes.sh' to check current configuration anytime"
echo

# Check current remote configuration
echo "Current remote configuration:"
if git remote get-url private &>/dev/null; then
    CURRENT_PRIVATE=$(git remote get-url private)
    echo "  private: $CURRENT_PRIVATE"
else
    echo "  private: (not set)"
    CURRENT_PRIVATE=""
fi

if git remote get-url public &>/dev/null; then
    CURRENT_PUBLIC=$(git remote get-url public)
    echo "  public: $CURRENT_PUBLIC"
else
    echo "  public: (not set)"
    CURRENT_PUBLIC=""
fi
echo

# Collect user input with current values as defaults
echo "Update repository URLs (press Enter to keep current):"
echo

if [[ -n "$CURRENT_PRIVATE" ]]; then
    prompt "Private repository URL [$CURRENT_PRIVATE]: "
    read -r NEW_PRIVATE_INPUT
    PRIVATE_URL=${NEW_PRIVATE_INPUT:-$CURRENT_PRIVATE}
else
    prompt "Private repository URL (required for initial setup): "
    read -r PRIVATE_URL
    if [[ -z "$PRIVATE_URL" ]]; then
        error "Private repository URL is required for initial setup"
    fi
fi

if [[ -n "$CURRENT_PUBLIC" ]]; then
    prompt "Public repository URL [$CURRENT_PUBLIC]: "
    read -r NEW_PUBLIC_INPUT
    PUBLIC_URL=${NEW_PUBLIC_INPUT:-$CURRENT_PUBLIC}
else
    prompt "Public repository URL (required for initial setup): "
    read -r PUBLIC_URL
    if [[ -z "$PUBLIC_URL" ]]; then
        error "Public repository URL is required for initial setup"
    fi
fi

# Remove .git suffix if present and normalize URLs for comparison
PRIVATE_URL=${PRIVATE_URL%.git}
PUBLIC_URL=${PUBLIC_URL%.git}
CURRENT_PRIVATE_NORMALIZED=${CURRENT_PRIVATE%.git}
CURRENT_PUBLIC_NORMALIZED=${CURRENT_PUBLIC%.git}

# Determine what changed
PRIVATE_CHANGED=false
PUBLIC_CHANGED=false
IS_INITIAL_SETUP=false

if [[ -z "$CURRENT_PRIVATE" && -z "$CURRENT_PUBLIC" ]]; then
    IS_INITIAL_SETUP=true
else
    if [[ "$PRIVATE_URL" != "$CURRENT_PRIVATE_NORMALIZED" ]]; then
        PRIVATE_CHANGED=true
    fi
    if [[ "$PUBLIC_URL" != "$CURRENT_PUBLIC_NORMALIZED" ]]; then
        PUBLIC_CHANGED=true
    fi
fi

if [[ "$PRIVATE_CHANGED" == "false" && "$PUBLIC_CHANGED" == "false" && "$IS_INITIAL_SETUP" == "false" ]]; then
    echo
    log "No changes requested. Current configuration maintained."
    exit 0
fi

echo
if [[ "$IS_INITIAL_SETUP" == "true" ]]; then
    log "Initial setup configuration:"
    echo "  Private: $PRIVATE_URL"
    echo "  Public:  $PUBLIC_URL"
else
    log "Configuration changes:"
    if [[ "$PRIVATE_CHANGED" == "true" ]]; then
        echo "  Private: $CURRENT_PRIVATE_NORMALIZED → $PRIVATE_URL"
    else
        echo "  Private: $PRIVATE_URL (unchanged)"
    fi
    if [[ "$PUBLIC_CHANGED" == "true" ]]; then
        echo "  Public:  $CURRENT_PUBLIC_NORMALIZED → $PUBLIC_URL"
    else
        echo "  Public:  $PUBLIC_URL (unchanged)"
    fi
fi
echo

prompt "Continue with setup? (y/N): "
read -r CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    log "Setup cancelled."
    exit 0
fi

# Configure remotes
if [[ "$IS_INITIAL_SETUP" == "true" ]]; then
    log "Configuring initial Git remotes..."
    
    # Remove existing remotes if they exist
    git remote remove private 2>/dev/null || true
    git remote remove public 2>/dev/null || true
    git remote remove origin 2>/dev/null || true
    
    # Add new remotes
    git remote add private "$PRIVATE_URL"
    git remote add public "$PUBLIC_URL"
    
    success "Remotes configured successfully"
else
    log "Updating Git remotes..."
    
    # Update only changed remotes
    if [[ "$PRIVATE_CHANGED" == "true" ]]; then
        git remote set-url private "$PRIVATE_URL"
        success "Private remote updated"
    fi
    
    if [[ "$PUBLIC_CHANGED" == "true" ]]; then
        git remote set-url public "$PUBLIC_URL"
        success "Public remote updated"
    fi
fi

# Handle initial setup vs. remote updates
if [[ "$IS_INITIAL_SETUP" == "true" ]]; then
    # Initialize main branch if no commits exist
    if [ -z "$(git log --oneline 2>/dev/null)" ]; then
        log "No commits found. Creating initial commit..."
        
        # Stage all files
        git add .
        
        # Create initial commit
        git commit -m "Initial commit: Node.js Dev Container project

Features:
- Multi-stage Dockerfile with Volta integration
- VS Code Dev Container optimization
- Security-hardened runtime environment
- TypeScript development support
- Dual repository publishing setup"
        
        success "Initial commit created"
    fi
    
    # Push to private repository (full project)
    log "Pushing complete project to private repository..."
    git push -u private main
    
    success "Private repository initialized"
    
    # Create and configure public branch
    log "Setting up public branch for open source release..."
    
    # Create orphan public branch
    git checkout --orphan public
    git rm -rf . 2>/dev/null || true
    
    # Copy public files from main (including .github directory)
    git checkout main -- Dockerfile .github/README.md .github/CHANGELOG.md .github/LICENSE
    
    # Note: .github directory structure is preserved in public repo
    # Only difference: .github/workflows will be added later for CI/CD automation
    
    # Add and commit public files
    git add -A
    git commit -m "Initial public release: Node.js Dev Container

A production-ready Dockerfile optimized for VS Code\'s Dev Container extension, providing a complete Node.js development environment with Volta for version management.

Features:
- Volta integration for Node.js version management
- VS Code Dev Container optimization
- Security-first design with non-root execution  
- TypeScript ready environment
- Multi-stage build for development and production"
    
    # Push to public repository
    git push -u public public:main
    
    success "Public repository initialized"
    
    # Return to main branch
    git checkout main
else
    log "Remote URLs updated. Use '.warp/sync-public.sh' to sync changes to repositories."
fi

# Create .gitignore for the sync script
if [ ! -f ".gitignore" ]; then
    log "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# OS files
.DS_Store
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~

# Logs
*.log
npm-debug.log*

# Dependencies
node_modules/

# Build outputs
dist/
build/

# Environment files
.env
.env.local

# Temporary files
tmp/
temp/
EOF
fi

echo
if [[ "$IS_INITIAL_SETUP" == "true" ]]; then
    success "Dual remote setup completed successfully!"
    echo
    log "Repository Structure:"
    echo "  Local branches:"
    echo "    • main   - Complete project (pushes to private repository)"
    echo "    • public - Public files only (pushes to public repository)"
    echo
    echo "  Remotes:"
    echo "    • private - Full project repository"
    echo "    • public  - Open source repository"
    echo
    log "Usage (with Branch Protection):"
    echo "  • Regular development: Work on feature branches, create PRs to main"
    echo "  • Sync releases: Run '.warp/sync-public.sh' to create sync branches"
    echo "  • Create PRs from sync branches to main in both repositories"
    echo
    log "Next steps:"
    echo "  1. Enable branch protection on main in both repositories"
    echo "  2. Develop features on branches, create PRs to main"
    echo "  3. When ready to publish: .warp/sync-public.sh"
    echo "  4. Create PRs from generated sync branches to main"
    echo "  5. Merge PRs to trigger GitHub Actions build"
else
    success "Remote configuration updated successfully!"
    echo
    log "Updated Remotes:"
    if [[ "$PRIVATE_CHANGED" == "true" ]]; then
        echo "    • private - $PRIVATE_URL"
    fi
    if [[ "$PUBLIC_CHANGED" == "true" ]]; then
        echo "    • public  - $PUBLIC_URL"
    fi
    echo
    log "Next steps:"
    echo "  • Run '.warp/sync-public.sh' to sync any pending changes"
    echo "  • Update any scripts or CI/CD that reference the old URLs"
    if [[ "$PRIVATE_CHANGED" == "true" ]]; then
        echo "  • Update private repository settings (branch protection, webhooks, etc.)"
    fi
    if [[ "$PUBLIC_CHANGED" == "true" ]]; then
        echo "  • Update public repository settings (GitHub Actions secrets, etc.)"
    fi
fi
