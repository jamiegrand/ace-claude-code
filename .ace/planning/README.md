# Planning Directory

This directory contains all Ace planning documents.

## Structure

```
planning/
├── PROJECT.md      # Project specification
├── ROADMAP.md      # Phase sequencing
├── STATE.md        # Current position & session state
├── ISSUES.md       # Deferred issues tracker
├── codebase/       # Brownfield analysis (from map-codebase)
└── phases/         # Phase plans and summaries
    ├── 01-foundation/
    │   ├── 01-01-PLAN.md
    │   └── 01-01-SUMMARY.md
    └── 02-core/
        └── ...
```

## Lifecycle

1. `/ace:new-project` creates PROJECT.md
2. `/ace:create-roadmap` creates ROADMAP.md + STATE.md
3. `/ace:plan-phase` creates PLAN.md in phases/
4. `/ace:execute-plan` creates SUMMARY.md after completion

## Key Files

| File | Purpose | Updated When |
|------|---------|--------------|
| PROJECT.md | What we're building | Requirements change |
| ROADMAP.md | Phase sequence | Phases add/remove |
| STATE.md | Where we are | After every action |
| ISSUES.md | Deferred work | During execution |
