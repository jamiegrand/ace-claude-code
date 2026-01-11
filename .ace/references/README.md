# References Directory

This directory contains external references, research documents, and supporting materials.

## Contents

```
references/
├── phase-1-research.md    # Research for Phase 1
├── phase-2-research.md    # Research for Phase 2
├── design-specs/          # Design mockups and specs
└── api-docs/              # API documentation references
```

## Created By

- `/ace:research-phase [N]` - Creates phase-N-research.md
- Manual addition by user - Design specs, API docs

## Usage

Reference documents inform planning but are not modified during execution.

During `/ace:plan-phase`:
- Check for relevant research documents
- Incorporate findings into task definitions
- Link to references in PLAN.md

## Not For

- Planning documents (use .ace/planning/)
- Runtime state (use .ace/state/)
- Configuration (use .ace/config.json)
