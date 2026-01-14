# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a **devcontainers template repository** that provides reusable Dockerfile templates for VS Code's Dev Container extension. It demonstrates best practices for creating secure, optimized development environments that can be customized for different programming languages and frameworks.

## Template Architecture

### Multi-Stage Build Design
- **Builder Stage**: Installs development tools and language-specific tooling
- **Runtime Stage**: Minimal production image with security hardening
- **VS Code Integration**: Uses `vscode` user convention for seamless IDE integration

### Key Features
- **Language Agnostic**: Template can be adapted for any development stack
- **VS Code Optimized**: Pre-configured for Dev Container extension
- **Security First**: Non-root execution, hardened runtime environment  
- **Customizable**: Build arguments for flexible configuration

## Using This Template

### Creating Custom Dev Container Images
```bash
# 1. Clone this template repository
git clone <this-template-repo-url>
cd template-devcontainer

# 2. Customize Dockerfile-template for your language/framework
# Example: Create a Python-based dev container
cp Dockerfile-template Dockerfile-python
# Edit to install Python, pip, poetry, etc. instead of Node.js/Volta

# 3. Build and tag your custom image
docker build -f Dockerfile-python -t my-org/python-devcontainer:latest .

# 4. Push to registry for team use
docker push my-org/python-devcontainer:latest
```

### Testing Your Custom Image
```bash
# Test the image locally
docker run -it --rm -v "$(pwd)":/workspace my-org/python-devcontainer:latest

# Test with VS Code user mapping (macOS)
docker run -it --rm -v "$(pwd)":/workspace --user 1000:1000 my-org/python-devcontainer:latest

# Verify your development tools are installed
docker run --rm my-org/python-devcontainer:latest python --version
docker run --rm my-org/python-devcontainer:latest pip --version
```

### Consuming Images in Projects
Once you've created and published custom dev container images, projects can use them in their `.devcontainer/devcontainer.json`:

```json
{
    "name": "Python Development",
    "image": "my-org/python-devcontainer:latest",
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "ms-python.black-formatter"
            ]
        }
    },
    "postCreateCommand": "pip install -r requirements.txt"
}
```

## Template Configuration

### Build Arguments for Customization
- `USERNAME=vscode`: Matches VS Code Dev Container user convention
- `USER_UID=1000`: Default UID for container user
- `USER_GID=1000`: Default GID for container user

### Runtime Environment
- **Working Directory**: `/workspace` (VS Code mounts project here)
- **User Context**: Non-root `vscode` user for security
- **Shell**: Bash with customizable environment
- **Base System**: Debian 12 slim with essential development tools

### Customization Examples

#### Python Development Image
```dockerfile
# Replace the Volta/Node.js section with:
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install Python development tools
RUN pip3 install --no-cache-dir \
    poetry \
    black \
    pylint \
    pytest
```

#### Go Development Image
```dockerfile
# Replace the Volta/Node.js section with:
ENV GO_VERSION=1.21.0
RUN curl -fsSL https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz | \
    tar -C /usr/local -xzf -
ENV PATH=/usr/local/go/bin:$PATH

# Install Go development tools
RUN go install golang.org/x/tools/cmd/goimports@latest
RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

## Template Files

This repository includes template files to help you get started:

### devcontainer-template.json
A comprehensive VS Code Dev Container configuration template with:
- JSONC comments explaining each section
- Examples for popular languages (Python, Node.js, Go, Rust)
- Placeholder sections for extensions, settings, and commands
- References to `Dockerfile-template` and `verify-tools-template.sh`

### verify-tools-template.sh
A verification script template that:
- Checks essential development tools (git, curl, bash)
- Displays container environment information
- Provides commented examples for language-specific tool checks
- Clear customization section with multiple language examples

### Usage with Template Files
```bash
# 1. Copy and customize the files for your language
mv devcontainer-template.json .devcontainer/devcontainer.json
mv verify-tools-template.sh verify-python-tools.sh

# 2. Edit devcontainer.json using the JSONC comments as guidance
# 3. Edit verify-python-tools.sh to check Python-specific tools
# 4. Update Dockerfile-template with your language requirements
```

## Security Features
- Root account completely disabled (no password, nologin shell)
- Minimal attack surface with cleaned package managers
- Non-privileged user execution
- Optimized layer caching for faster rebuilds
