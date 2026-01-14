# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

