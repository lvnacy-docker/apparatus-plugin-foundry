# LVNACY Apparatus (Obsidian)

## Overview
The LVNACY Apparatus is a modular system for Obsidian that centers on context and portability. It is designed to live in git submodules so each module can be versioned, shared, and updated independently. Modules act as self-contained blocks that can be moved between vaults and dropped into a project when you want to add a specific layer of context or capability.

In practice, the Apparatus provides a consistent way to scaffold content, research, and tooling without forcing a single monolithic vault structure. You can keep a lean, purpose-built vault and attach modules only where they are useful.

## Core Ideas
- Context-first structure: modules are built to carry their own context, references, and conventions.
- Portable by default: modules are small, self-contained units that can be moved or reused across vaults.
- Versioned in git submodules: each module can evolve on its own release cycle without disrupting other work.
- Composable: modules can be combined to create more complex working environments.

## Current Module Families
### Newsletter Modules
Scaffolding for online periodicals, including structure for editions, recurring segments, submission workflows, and publishing checklists. These modules focus on cadence and repeatable production.

### Story Modules
Scaffolding for novels, short stories, and serials. These modules emphasize narrative continuity, scene organization, character tracking, and revision passes.

### Context Library Modules
Research and reference libraries that can be attached to any vault. These modules include curated notes, sources, and conceptual scaffolds that add depth and clarity to ongoing work.

### Plugin Development Template
A ready-to-use structure for Obsidian plugin development. It provides baseline setup, project conventions, and documentation patterns so you can start building quickly while keeping tooling consistent.

## How Modules Work in a Vault
Each module is an independent repository, typically added as a git submodule inside a vault. That makes it easy to:
- Pull updates when a module improves.
- Pin a module to a specific version for stability.
- Swap modules in or out without refactoring the rest of the vault.

Modules can be nested, layered, or arranged in dedicated areas of a vault. The Apparatus does not require a single canonical layout; it favors practical composition per project.

## When to Use the Apparatus
- You want the same scaffolding across multiple vaults.
- You work on multiple long-term projects that benefit from shared context.
- You want to keep research, writing frameworks, and tooling modular.
- You prefer versioned, reusable building blocks over one large vault template.

## Future Direction
The Apparatus is expected to expand with additional modules and shared conventions. Over time, the system can evolve into a library of composable building blocks that cover more workflows while remaining lightweight and portable.
