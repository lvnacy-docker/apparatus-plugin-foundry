<div align="center">
<br>
<h1>L V N A C Y Apparatus Plugin Foundry</h1>
<p><i>Produced with Love, Magic, and Madness, by L V N A C Y</i></p>
<br />
<img
    src="./assets/lvnacy_emblem_plain.png"
    width="200px"
/>
</div>

<br />

<div align="center">
    •
    <a href="https://github.com/lvnacy/">GitHub</a>
    •
    <a href="https://bsky.app/profile/lvnacy.xyz/">Bluesky</a>
    •
    <a href="https://discord.gg/nh7mqGEfbw">Discord</a>
    •
    <br>
</div>

<br />

<div align="center">
<h2>Hardened Obsidian Plugin Development Container</h2>
</div>

A security-hardened development container for building and testing Preact components with Storybook 10, featuring accessibility testing, browser-based testing with Vitest, and Node.js version management via Volta. This Foundry is the development home for Apparatus plugin work.

## About the Apparatus

The LVNACY Apparatus is a modular system for Obsidian that centers on context and portability. It is designed to live in git submodules so each module can be versioned, shared, and updated independently. Modules act as self-contained blocks that can be moved between vaults and dropped into a project when you want to add a specific layer of context or capability.

The Foundry exists to keep plugin development consistent with the Apparatus ethos: composable, portable, and versioned. For a deeper overview, see the [APPARATUS_README.md](APPARATUS_README.md).

## Features

- **Storybook 10** for component development and documentation
- **Preact** framework support with Vite
- **Accessibility testing** with a11y addon
- **Browser-based testing** with Vitest and Playwright
- **Volta** for consistent Node.js version management across environments
- **Security hardening** with minimal attack surface and no runtime package installation

## Included Tooling

### Core Tools (Available in All Images)

- [**Volta**](https://volta.sh/) - JavaScript toolchain manager for consistent Node.js and pnpm versions
- [**Node.js**](https://nodejs.org/) (v22) - JavaScript runtime
- [**pnpm**](https://pnpm.io/) - Fast, disk space efficient package manager
- [**TypeScript**](https://www.typescriptlang.org/) - Type-safe JavaScript (globally installed via Volta)
- [**ESLint**](https://eslint.org/) - JavaScript linting (globally installed via Volta)
- [**Obsidian**](https://obsidian.md/) - Obsidian types (globally installed via Volta)
- [**obsidian-dev-utils**](https://github.com/mnaoumov/obsidian-dev-utils) - Development utilities (globally installed via Volta)

### Storybook Ecosystem (playwright-storybook variant only)

- [**Storybook**](https://storybook.js.org/) (v10) - UI component development environment
- [**@storybook/preact**](https://storybook.js.org/docs/get-started/frameworks/preact) - Preact framework integration
- [**@storybook/preact-vite**](https://storybook.js.org/docs/get-started/frameworks/preact) - Vite builder for Preact
- [**@storybook/addon-essentials**](https://storybook.js.org/docs/essentials/introduction) - Essential Storybook addons (includes viewport, controls, actions, etc.)
- [**@storybook/addon-a11y**](https://storybook.js.org/addons/@storybook/addon-a11y) - Accessibility testing addon
- [**@storybook/addon-vitest**](https://storybook.js.org/addons/@storybook/addon-vitest) - Vitest integration for component testing
- [**@storybook/addon-interactions**](https://storybook.js.org/docs/writing-tests/interaction-testing) - Interactive testing addon

### Testing Tools (playwright-storybook variant only)

- [**Vitest**](https://vitest.dev/) - Fast unit test framework
- [**Playwright**](https://playwright.dev/) - Browser automation (Chromium pre-installed)
- [**@vitest/browser**](https://vitest.dev/guide/browser) - Browser testing provider for Vitest
- [**@vitest/browser-playwright**](https://vitest.dev/guide/browser) - Playwright integration for Vitest browser mode
- [**@vitest/coverage-v8**](https://vitest.dev/guide/coverage) - Code coverage reporting

### Build Tools (playwright-storybook variant only)

- [**Vite**](https://vitejs.dev/) - Fast build tool and dev server
- [**Preact**](https://preactjs.com/) - Lightweight React alternative

## Image Variants

The Foundry is available in two optimized variants:

### Slim Image (`slim-[version]`)

- Includes only core Volta tools: Node.js, pnpm, TypeScript, ESLint, Obsidian types, and obsidian-dev-utils
- No pre-installed pnpm packages or Playwright browsers
- Minimal image size (~200-300MB)
- Perfect for lightweight Obsidian plugin development without Storybook
- Fast to pull and run

### Playwright-Storybook Image (`playwright-storybook-[version]`)

- Includes all core tools plus the complete Storybook ecosystem
- Pre-populated pnpm store with Storybook, Preact, Vite, Vitest, and Playwright packages
- Playwright Chromium browser pre-installed
- Larger image size (~2.7GB)
- Optimal for full-featured component development with visual testing and accessibility checks
- Faster `pnpm install` due to pre-populated package cache

## Usage

### Building the Images

**Slim variant** (default, no optional packages):
```bash
docker build -t lvnacy/apparatus-plugin-foundry:slim-3.0.0 .
```

**Playwright-Storybook variant** (with cached packages and Playwright):
```bash
docker build \
    --build-arg WITH_PNPM_STORE=true \
    --build-arg WITH_PLAYWRIGHT_BROWSERS=true \
    -t lvnacy/apparatus-plugin-foundry:playwright-storybook-3.0.0 .
```

### Using with VS Code

Both image variants work with VS Code devcontainers. Choose the variant that matches your project needs:

1. In `.devcontainer/devcontainer.json`, set the image:
   - For lightweight plugin development: `"image": "lvnacy/apparatus-plugin-foundry:slim-[version]"`
   - For Storybook/component development: `"image": "lvnacy/apparatus-plugin-foundry:playwright-storybook-[version]"`
2. Open the project in VS Code
3. Use the command palette: "Dev Containers: Reopen in Container"
4. Navigate to your submodule directory
5. Run `pnpm install` to install project dependencies
6. Start Storybook (if using playwright-storybook variant) with `pnpm storybook`

### Working with Submodules

This devcontainer is designed to work with mono-repo or multi-submodule projects. After the container starts:

```bash
cd path/to/your/submodule
pnpm install
pnpm storybook
```

The pre-populated pnpm store will significantly speed up package installation.

### Running Tests

```bash
# Run Vitest tests
pnpm test

# Run Storybook test runner
pnpm test-storybook
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
- All pnpm packages cached during build phase with root privileges
- Playwright browsers and system dependencies installed at build time
- Runtime installations leverage pre-populated store, avoiding network calls

#### 6. **Immutable Toolchain**
- Volta-managed Node.js and pnpm versions locked at build time
- Consistent tooling across all environments

### What This Prevents

- **Privilege escalation**: No mechanism to gain root access
- **Unauthorized software installation**: Cannot add packages or system tools
- **Container breakout attempts**: Minimal tooling reduces potential exploit vectors
- **Supply chain attacks at runtime**: All dependencies verified and cached at build time
- **Persistent backdoors**: Read-only system prevents modification of binaries

### What Users CAN Do

- Install project dependencies via `pnpm install` (uses pre-populated store)
- Run development servers (Storybook, Vite)
- Execute tests (Vitest, Playwright)
- Develop and build applications normally
- Use all pre-installed tooling (Node.js, TypeScript, etc.)

### What Users CANNOT Do

- Install system packages (`apt install` unavailable)
- Modify system files or binaries
- Switch to root user
- Install global pnpm packages requiring compilation
- Add new system dependencies

### Security Trade-offs

While this hardening significantly improves security, it does introduce constraints:

- **Flexibility**: Cannot adapt to unexpected system dependency requirements at runtime
- **Debugging**: Some system debugging tools are unavailable
- **Updates**: Security patches require rebuilding the image rather than runtime updates

These trade-offs are intentional and appropriate for development environments where security is prioritized over convenience.

## Maintenance

### Updating Dependencies (playwright-storybook variant)

To update Storybook or other cached dependencies:

1. Modify the `pnpm install` command in the Dockerfile builder stage (within the `if [ "$WITH_PNPM_STORE" = "true" ]` block)
2. Rebuild the image with build args: `docker build --build-arg WITH_PNPM_STORE=true --build-arg WITH_PLAYWRIGHT_BROWSERS=true -t lvnacy/apparatus-plugin-foundry:playwright-storybook-X.Y.Z .`
3. Restart your devcontainer

### Updating Volta Tools (all variants)

To add or update global tools managed by Volta:

1. Modify the `volta install` command in the Dockerfile builder stage
2. Rebuild both variants:
   ```bash
   # Slim variant
   docker build -t lvnacy/apparatus-plugin-foundry:slim-X.Y.Z .
   
   # Playwright-Storybook variant
   docker build --build-arg WITH_PNPM_STORE=true --build-arg WITH_PLAYWRIGHT_BROWSERS=true -t lvnacy/apparatus-plugin-foundry:playwright-storybook-X.Y.Z .
   ```
3. Restart your devcontainers

### Updating Node.js Version

To change the Node.js version:

1. Modify the `volta install node@VERSION` command in the builder stage
2. Rebuild the image

Alternatively, you can run `volta install node@[version]`. All Volta functionality
is available in the container.

## Troubleshooting

### Storybook UI Not Rendering (playwright-storybook variant)

If the Storybook sidebar loads but stories don't render:
- Check browser console for errors
- Verify no conflicting addons
- Ensure proper port forwarding in devcontainer configuration

### Slow `pnpm install` (playwright-storybook variant)

First install will be slower as packages are downloaded. Subsequent installs should be fast due to the pre-populated store. If still slow:
- Verify the pnpm store was copied correctly from builder stage
- Check that `/home/vscode/.local/share/pnpm` exists in the container

### Playwright Tests Failing (playwright-storybook variant)

If browser tests fail:
- Ensure Chromium system dependencies are installed in runtime stage
- Verify `/home/vscode/.cache/ms-playwright` exists
- Check that tests are configured for headless mode

### Permission Errors (all variants)

All files should be owned by `vscode:vscode`. If you encounter permission issues:
- Verify workspace mount ownership in `devcontainer.json`
- Check that files created in the container have correct ownership

## License

MIT