# Scripts Directory

This directory contains custom automation scripts for your Ace project.

## Contents

```
scripts/
├── pre-execute.sh      # Run before plan execution
├── post-execute.sh     # Run after plan completion
├── quality-gates.sh    # Custom quality checks
└── deploy.sh           # Deployment automation
```

## Hook Scripts

You can create hook scripts that run at specific points:

### pre-execute.sh
Runs before `/ace:execute-plan` starts:
- Environment validation
- Dependency checks
- Pre-flight verification

### post-execute.sh
Runs after plan completion:
- Deployment triggers
- Notification sending
- Cleanup tasks

## Custom Quality Gates

Override default quality gates by creating `quality-gates.sh`:

```bash
#!/bin/bash
# Custom quality gates

echo "Running TypeScript check..."
npx tsc --noEmit || exit 1

echo "Running custom linting..."
./scripts/custom-lint.sh || exit 1

echo "All quality gates passed!"
```

## Usage

Scripts must be executable:
```bash
chmod +x scripts/*.sh
```

Ace will detect and run them automatically at the appropriate points.
