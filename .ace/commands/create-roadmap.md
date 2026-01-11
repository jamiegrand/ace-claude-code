---
name: ace:create-roadmap
description: Build ROADMAP.md and initialize STATE.md
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - AskUserQuestion
---

<objective>
Create ROADMAP.md with phased plan and initialize STATE.md for session tracking.

This establishes the phase sequence and enables progress tracking.
</objective>

<context>
**Required:**
@.ace/planning/PROJECT.md (must exist)

**Load templates:**
@.ace/templates/planning/roadmap.md
@.ace/templates/planning/state.md

**Optional context:**
@.ace/planning/codebase/ (if brownfield)
</context>

<process>

## 1. Verify Prerequisites

```
if PROJECT.md does not exist:
    Error: "Run /ace:new-project first"
```

## 2. Read Project Requirements

Parse PROJECT.md to understand:
- Core value
- Must-have requirements
- Technical stack
- Constraints

## 3. Propose Phases

Based on requirements, propose 3-6 phases:

```
+==============================================================+
|                    PROPOSED ROADMAP                          |
+==============================================================+

Phase 1: Foundation
- Set up project structure
- Configure tooling
- Basic scaffolding

Phase 2: Core Features
- [Based on must-haves]
- [Primary functionality]

Phase 3: Integration
- Connect components
- Polish UI
- Testing

[Additional phases if needed]

+==============================================================+
```

## 4. Get Approval

Use AskUserQuestion:
- "Does this phase breakdown work for you?"
- Options: "Yes, create roadmap" / "Adjust phases"

If adjust:
- Ask what changes needed
- Revise and re-present

## 5. Create ROADMAP.md

Write to `.ace/planning/ROADMAP.md`:
- Phase definitions with goals
- Empty plan slots
- Dependencies between phases

## 6. Initialize STATE.md

Write to `.ace/planning/STATE.md`:
- Reference PROJECT.md
- Set position to "Phase 1 ready to plan"
- Initialize empty metrics
- Set session start time

## 7. Git Commit (if enabled)

```bash
git add .ace/planning/
git commit -m "docs: initialize [project-name] ([N] phases)

[One-liner from PROJECT.md]

Phases:
1. [phase-name]: [goal]
2. [phase-name]: [goal]
3. [phase-name]: [goal]
"
```

## 8. Next Steps

Display:
```
+==============================================================+
|                    ROADMAP CREATED                           |
+==============================================================+

Phases: [N]
Current: Phase 1 - [Name]
Status: Ready to plan

Next: /ace:plan-phase 1

+==============================================================+
```

</process>

<success_criteria>
- [ ] ROADMAP.md created with all phases
- [ ] STATE.md initialized
- [ ] Git commit created (if enabled)
- [ ] User informed of next steps (/ace:plan-phase 1)
</success_criteria>
