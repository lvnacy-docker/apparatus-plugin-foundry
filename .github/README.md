# Hardened Storybook Devcontainer

A security-hardened development container for building and testing Preact components with Storybook 10, featuring accessibility testing, browser-based testing with Vitest, and Node.js version management via Volta.

## Features

- **Storybook 10** for component development and documentation
- **Preact** framework support with Vite
- **Accessibility testing** with a11y addon
- **Browser-based testing** with Vitest and Playwright
- **Volta** for consistent Node.js version management across environments
- **Security hardening** with minimal attack surface and no runtime package installation

## Included Tooling

### Core Tools

- [**Volta**](https://volta.sh/) - JavaScript toolchain manager for consistent Node.js and npm versions
- [**Node.js**](https://nodejs.org/) (v20.18.1) - JavaScript runtime
- [**npm**](https://www.npmjs.com/) (v10+) - Package manager
- [**TypeScript**](https://www.typescriptlang.org/) - Type-safe JavaScript (globally installed)

### Storybook Ecosystem

- [**Storybook**](https://storybook.js.org/) (v10) - UI component development environment
- [**@storybook/preact**](https://storybook.js.org/docs/get-started/frameworks/preact) - Preact framework integration
- [**@storybook/preact-vite**](https://storybook.js.org/docs/get-started/frameworks/preact) - Vite builder for Preact
- [**@storybook/addon-essentials**](https://storybook.js.org/docs/essentials/introduction) - Essential Storybook addons (includes viewport, controls, actions, etc.)
- [**@storybook/addon-a11y**](https://storybook.js.org/addons/@storybook/addon-a11y) - Accessibility testing addon
- [**@storybook/addon-vitest**](https://storybook.js.org/addons/@storybook/addon-vitest) - Vitest integration for component testing
- [**@storybook/addon-interactions**](https://storybook.js.org/docs/writing-tests/interaction-testing) - Interactive testing addon

### Testing Tools

- [**Vitest**](https://vitest.dev/) - Fast unit test framework
- [**Playwright**](https://playwright.dev/) - Browser automation (Chromium pre-installed)
- [**@vitest/browser**](https://vitest.dev/guide/browser) - Browser testing provider for Vitest
- [**@vitest/browser-playwright**](https://vitest.dev/guide/browser) - Playwright integration for Vitest browser mode
- [**@vitest/coverage-v8**](https://vitest.dev/guide/coverage) - Code coverage reporting

### Build Tools

- [**Vite**](https://vitejs.dev/) - Fast build tool and dev server
- [**Preact**](https://preactjs.com/) - Lightweight React alternative

## Usage

### Building the Image

```bash
docker build -t storybook-devcontainer .
```

### Using with VS Code

1. Ensure the devcontainer is configured in `.devcontainer/devcontainer.json`
2. Open the project in VS Code
3. Use the command palette: "Dev Containers: Reopen in Container"
4. Navigate to your submodule directory
5. Run `npm install` to install project dependencies
6. Start Storybook with `npm run storybook`

### Working with Submodules

This devcontainer is designed to work with mono-repo or multi-submodule projects. After the container starts:

```bash
cd path/to/your/submodule
npm install
npm run storybook
```

The pre-populated npm cache will significantly speed up package installation.

### Running Tests

```bash
# Run Vitest tests
npm run test

# Run Storybook test runner
npm run test-storybook
```

## Security

### Hardening Features

This devcontainer implements multiple security best practices to minimize attack surface and prevent unauthorized access:

#### 1. **Minimal Runtime Image**
- Based on `debian:12-slim` with only essential packages
- All development tools removed after installation
- Documentation, man pages, and locales stripped to reduce size and attack surface

#### 2. **No Package Managers at Runtime**
- `apt`, `apt-get`, and `dpkg` binaries are completely removed from the runtime image
- Package manager configuration directories (`/etc/apt`, `/var/lib/apt`) deleted
- Users cannot install additional software at runtime, preventing unauthorized modifications

#### 3. **Disabled Root Account**
- Root account password is locked with `passwd -l root`
- Root shell set to `/usr/sbin/nologin`, preventing login
- All operations run as non-root user `vscode` (UID 1000, GID 1000)

#### 4. **Multi-Stage Build**
- Separates build-time (privileged) operations from runtime environment
- Only necessary artifacts copied to final image
- Build tools and temporary files never make it to production image

#### 5. **Pre-installed Dependencies**
- All npm packages cached during build phase with root privileges
- Playwright browsers and system dependencies installed at build time
- Runtime installations leverage pre-populated cache, avoiding network calls

#### 6. **Immutable Toolchain**
- Volta-managed Node.js and npm versions locked at build time
- Consistent tooling across all environments

### What This Prevents

- **Privilege escalation**: No mechanism to gain root access
- **Unauthorized software installation**: Cannot add packages or system tools
- **Container breakout attempts**: Minimal tooling reduces potential exploit vectors
- **Supply chain attacks at runtime**: All dependencies verified and cached at build time
- **Persistent backdoors**: Read-only system prevents modification of binaries

### What Users CAN Do

- Install project dependencies via `npm install` (uses pre-populated cache)
- Run development servers (Storybook, Vite)
- Execute tests (Vitest, Playwright)
- Develop and build applications normally
- Use all pre-installed tooling (Node.js, TypeScript, etc.)

### What Users CANNOT Do

- Install system packages (`apt install` unavailable)
- Modify system files or binaries
- Switch to root user
- Install global npm packages requiring compilation
- Add new system dependencies

### Security Trade-offs

While this hardening significantly improves security, it does introduce constraints:

- **Flexibility**: Cannot adapt to unexpected system dependency requirements at runtime
- **Debugging**: Some system debugging tools are unavailable
- **Updates**: Security patches require rebuilding the image rather than runtime updates

These trade-offs are intentional and appropriate for development environments where security is prioritized over convenience.

## Maintenance

### Updating Dependencies

To update Storybook or other dependencies:

1. Modify the `npm install` command in the Dockerfile builder stage
2. Rebuild the image: `docker build -t storybook-devcontainer .`
3. Restart your devcontainer

### Adding New Tools

To add new npm packages to the cache:

1. Add them to the `npm install` command in the builder stage (line ~50)
2. Rebuild the image
3. The packages will be available in the cache for faster installation

### Updating Node.js Version

To change the Node.js version:

1. Modify the `volta install node@VERSION` command in the builder stage
2. Rebuild the image

Alternatively, you can run `volta install node@[version]`. All Volta functionality
is available in the container.

## Troubleshooting

### Storybook UI Not Rendering

If the Storybook sidebar loads but stories don't render:
- Check browser console for errors
- Verify no conflicting addons
- Ensure proper port forwarding in devcontainer configuration

### Slow `npm install`

First install will be slower as packages are downloaded. Subsequent installs should be fast due to the pre-populated cache. If still slow:
- Verify the npm cache was copied correctly from builder stage
- Check that `/home/vscode/.npm` exists in the container

### Playwright Tests Failing

If browser tests fail:
- Ensure Chromium system dependencies are installed in runtime stage
- Verify `/home/vscode/.cache/ms-playwright` exists
- Check that tests are configured for headless mode

### Permission Errors

All files should be owned by `vscode:vscode`. If you encounter permission issues:
- Verify workspace mount ownership in `devcontainer.json`
- Check that files created in the container have correct ownership

## License

MIT