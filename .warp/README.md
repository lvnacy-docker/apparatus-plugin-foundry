# .warp Directory

This directory contains Warp AI session archives and project-specific context for the node-devcontainer project.

## Structure

```
.warp/
├── README.md              # This file - explains the .warp directory structure
├── conversations/         # Archive of Warp AI conversations
│   ├── YYYY-MM-DD-session-name.md
│   └── ...
└── context/              # Additional context files for AI sessions
    ├── notes.md          # Project notes and observations
    └── decisions.md      # Architecture and design decisions
```

## Purpose

The `.warp` directory serves as a local archive for AI-assisted development sessions, separate from the main project documentation. This allows for:

- **Session History**: Tracking of AI conversations and decisions
- **Context Preservation**: Maintaining context between sessions
- **Development Notes**: Recording insights and learnings
- **Private Documentation**: Information not suitable for public repositories

## Usage Guidelines

### Conversation Archives
- Save significant AI conversation sessions in `conversations/`
- Use descriptive filenames: `2024-09-30-dual-remote-setup.md`
- Include session context, decisions made, and outcomes

### Context Files
- `notes.md`: General observations, tips, and learnings
- `decisions.md`: Important architectural or design decisions
- Additional files as needed for project context

## Integration with Repositories

This `.warp` directory is included in the private repository but excluded from the public repository, allowing for:

- **Private Development Context**: Full development history in private repo
- **Clean Public Release**: Only production-ready files in public repo
- **Session Continuity**: Preserved context for future AI interactions

## Best Practices

1. **Regular Updates**: Save important conversations and decisions
2. **Descriptive Naming**: Use clear, date-prefixed filenames
3. **Context Maintenance**: Keep context files updated with project evolution
4. **Privacy Awareness**: Remember this content goes to private repo only