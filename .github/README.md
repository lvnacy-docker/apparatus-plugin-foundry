# DevContainer Template

A language-agnostic template for creating secure, optimized VS Code Dev Container base images. Use this template to create custom dev container images for any programming language or framework.

## Features

- **💻 VS Code Optimized**: Pre-configured for Dev Container extension
- **🔒 Security First**: Non-root execution with hardened runtime environment
    - No `apt`, `dpkg`, `curl`, etc
- **⚡ Multi-Stage Build**: Optimized for both development and production
- *insert language-specific benefits*

## Quick Start

### Using VS Code Dev Containers

1. **Prerequisites**: Install [VS Code](https://code.visualstudio.com/) and the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

2. **Open in Container**:
   - Open VS Code
   - Configure `.devcontainer/devcontainer.json` (see below)
   - Command Palette → `Dev Containers: Reopen in Container`

3. **Start Developing**: Your development environment is ready with [ language tooling ]!

### Manual Docker Usage

1. Clone this repo and

```bash
# Build the container
docker build -t *container-name* .
```

2. Navigate to your project workspace and

```
# Run interactively
docker run -it --rm -v "$(pwd)":/workspace *container-name*

# Run with proper user mapping (macOS/Linux)
docker run -it --rm -v "$(pwd)":/workspace --user 1000:1000 *container-name*
```

## Configuration

### Dev Container Integration

Create `.devcontainer/devcontainer.json` in your project:

```json
{
    "name": "Node.js Dev Container",
    "image": "{ image name }:latest",
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.vscode-typescript-next",
                "esbenp.prettier-vscode"
            ]
        }
    }
}
```

### Volta Version Management

```bash
# Pin Node.js version for your project
volta pin node@20

# Install specific versions
volta install node@18
volta install npm@10

# List available versions
volta list all
```

## Architecture

### Multi-Stage Build Design

- **Builder Stage**: Development tools, Volta, Node.js, and TypeScript installation
- **Runtime Stage**: Minimal production environment with security hardening
- **VS Code Integration**: Uses `vscode` user convention for seamless IDE integration

### Security Features

- Root account completely disabled
- Non-privileged user execution
- Minimal attack surface
- Optimized layer caching

## Development Workflow

```bash
# Initialize new project
npm init -y

# Install dependencies
npm install
npm install -D typescript @types/node

# Development commands
npm run dev
npm start
npm test
npm run build
```

## Build Arguments

Customize the container build:

- `USERNAME=vscode`: Container username (default: vscode)
- `USER_UID=1000`: User ID (default: 1000)
- `USER_GID=1000`: Group ID (default: 1000)

```bash
docker build --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) -t node-devcontainer .
```

## Requirements

- Docker Engine 20.10+
- VS Code with Dev Containers extension (for Dev Container usage)
- Git (for cloning the repository)

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with both manual Docker and VS Code Dev Container workflows
5. Submit a pull request

---

*This container follows VS Code Dev Container conventions and provides an optimized Node.js development environment suitable for any Node.js project.*