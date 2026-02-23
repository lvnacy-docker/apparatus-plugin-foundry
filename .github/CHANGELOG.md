# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Release 3.0.0]

### Major Changes
- **Introduced dual-variant architecture** for optimized deployment across use cases:
	- **`slim-[version]`** - Minimal image (~200-300MB) with only core Volta tools (Node.js, pnpm, TypeScript, ESLint, Obsidian CLI, obsidian-dev-utils). No pre-installed packages or Playwright.
	- **`playwright-storybook-[version]`** - Full-featured image (~2.7GB) with complete Storybook ecosystem, pre-populated pnpm store, and Playwright Chromium browser.
	- Default build (`docker build .`) now produces slim variant; use `--build-arg WITH_PNPM_STORE=true --build-arg WITH_PLAYWRIGHT_BROWSERS=true` for full variant.

- **Expanded Volta toolchain** (available in all variants):
	- Added ESLint for linting
	- Added Obsidian CLI for vault operations
	- Added obsidian-dev-utils for development utilities

- **Added `build-and-push.sh` script** for convenient multi-architecture multi-variant builds and pushes to Docker Hub with color-coded output.

- **Updated GitHub Actions workflow** to build and push both variants automatically with multi-architecture support (amd64 + arm64).

- **Updated documentation** (README) to clearly document variant differences, use cases, and specific build/troubleshooting guidance for each.

## [Release 2.0.0]

### Major Changes
- Migrated from npm to pnpm as the package manager:
	- Updated Dockerfile to install pnpm via Volta instead of npm.
	- Changed all package management commands from `npm` to `pnpm` (e.g., `npm install` → `pnpm install`, `npx` → `pnpm dlx`).
	- Replaced npm cache (`~/.npm`) with pnpm store (`~/.local/share/pnpm`) for improved disk efficiency and faster installs.
	- Added `PNPM_HOME` environment variable to both builder and runtime stages.
	- Updated README.md to reflect pnpm usage, commands, cache paths, and troubleshooting steps.

## [Release 1.0.0]

### Major Changes
- Refactored and specialized the project for Node.js, Storybook, and Preact development:
	- Renamed `Dockerfile-template` to `Dockerfile` and updated for Node.js 22, Volta, Storybook, Preact, Vite, and Playwright support. Added npm cache pre-population and Playwright browser install.
	- Renamed `devcontainer-template.json` to `devcontainer.json`, switched to using the `lvnacy/storybook` image, and updated postStartCommand and settings for the new stack.
	- Renamed and updated `verify-tools-template.sh` to `verify-tools.sh`, enabling Node.js/Volta tool checks and removing unused checks.

### Removed
- Deleted template and documentation files: `README.md`, `WARP.md`.
- Deleted WARP/dual-remote scripts: `.warp/status-remotes.sh`, `.warp/sync-public.sh`.

### General
- Cleaned up and specialized the project for Storybook/Preact/Node.js devcontainer use.

