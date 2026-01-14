# DevContainer Template Repository

A language-agnostic template for creating secure, optimized VS Code Dev Container base images. This template follows best practices for multi-stage Docker builds, security hardening, and VS Code integration.

## 🎯 Purpose

This repository serves as a **template for creating custom dev container images** that can be published to container registries and consumed by any project's `.devcontainer/devcontainer.json` configuration.

## ✨ Template Features

- **🔒 Security First**: Non-root execution with hardened runtime environment
- **⚡ Multi-Stage Build**: Optimized for both development and production
- **💻 VS Code Optimized**: Pre-configured for Dev Container extension  
- **🌐 Language Agnostic**: Easily customizable for any programming language
- **📝 Self-Documenting**: Comprehensive JSONC comments and examples

## 🚀 Quick Start

### 1. Use This Template
```bash
# Create a new repository from this template
git clone <your-new-repo-url>
cd <your-new-repo>
```

### 2. Customize for Your Language
```bash
# Copy and modify the template files
cp Dockerfile-template Dockerfile-python
cp devcontainer-template.json devcontainer-python.json  
cp verify-tools-template.sh verify-python-tools.sh

# Edit Dockerfile-python to install Python, pip, poetry, etc.
# Edit devcontainer-python.json using the JSONC comments as guidance
# Edit verify-python-tools.sh to check Python-specific tools
```

### 3. Build and Publish Your Image
```bash
# Build your custom dev container image
docker build -f Dockerfile-python -t my-org/python-devcontainer:latest .

# Test the image
docker run -it --rm -v "$(pwd)":/workspace my-org/python-devcontainer:latest

# Push to registry for team use
docker push my-org/python-devcontainer:latest
```

### 4. Use in Projects
Projects can then consume your image:
```json
{
    "name": "Python Development",
    "image": "my-org/python-devcontainer:latest",
    "customizations": {
        "vscode": {
            "extensions": ["ms-python.python"]
        }
    },
    "postCreateCommand": "pip install -r requirements.txt"
}
```

## 📁 Template Files

| File | Description |
|------|-------------|
| `Dockerfile-template` | Multi-stage Docker template with security hardening |
| `devcontainer-template.json` | VS Code Dev Container configuration with JSONC comments |
| `verify-tools-template.sh` | Tool verification script with language examples |
| `WARP.md` | Detailed usage guide for WARP AI terminal |

## 🏗️ Architecture

### Multi-Stage Build Design
- **Builder Stage**: Installs development tools and language-specific tooling
- **Runtime Stage**: Minimal production image with security hardening  
- **VS Code Integration**: Uses `vscode` user convention for seamless IDE integration

### Security Features
- Root account completely disabled (no password, nologin shell)
- Minimal attack surface with cleaned package managers
- Non-privileged user execution
- Optimized layer caching for faster rebuilds

## 🛠️ Customization Examples

The template includes examples for:
- **Python**: pip, poetry, black, pylint, pytest
- **Go**: Go toolchain, goimports, golangci-lint
- **Rust**: rustc, cargo
- **Node.js**: Volta, npm, TypeScript

## 📋 Requirements

- Docker Engine 20.10+
- VS Code with Dev Containers extension (for development)
- Git (for cloning and version control)

## 🤝 Contributing

1. Fork this template repository
2. Create your custom language implementation
3. Test with both Docker CLI and VS Code Dev Containers
4. Share your improvements back to the community

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

**Ready to create your first custom dev container?** Start by copying `Dockerfile-template` and follow the examples in `devcontainer-template.json`!