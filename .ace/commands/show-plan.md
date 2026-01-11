---
name: ace:show-plan
description: Display current plan without executing
argument-hint: "[optional: plan_id or path]"
allowed-tools:
  - Read
  - Glob
---

<objective>
Display the current or specified PLAN.md in visual format without executing it.

This is a read-only inspection command for reviewing plans before execution.
</objective>

<context>
Plan reference: $ARGUMENTS (optional - defaults to current plan from STATE.md)

**Required:**
@.ace/planning/STATE.md

**Load plan from:**
- If $ARGUMENTS is a path: Use that path directly
- If $ARGUMENTS is a plan_id (e.g., "02-01"): Find in phases/
- If no arguments: Read STATE.md for current plan reference
</context>

<process>

## 1. Locate Plan

```
if $ARGUMENTS provided:
    if $ARGUMENTS is path (contains /):
        plan_path = $ARGUMENTS
    else:
        # Treat as plan_id like "02-01"
        Find matching PLAN.md in .ace/planning/phases/

if no $ARGUMENTS:
    Read STATE.md for current plan path
    if no current plan:
        Error: "No current plan. Run /ace:plan-phase [N] first"
```

## 2. Parse Plan File

Read PLAN.md and extract:
- Phase and plan metadata
- Tasks (max 3)
- Zone assignments per task
- File patterns per task
- Checkpoints (if any)
- Verification criteria

## 3. Display Plan Header

```
+==============================================================+
|                    ACE PLAN                             |
+==============================================================+
|  Phase: [X] - [Phase Name]                                   |
|  Plan: [plan_id] - [Plan Name]                               |
|  Status: [Ready to execute / In progress / Complete]         |
|  Created: [date]                                             |
+==============================================================+

Goal: "[Plan objective from PLAN.md]"

+==============================================================+
```

## 4. Display Visual Task Distribution

```
TASK DISTRIBUTION:

              "[Phase Goal]"
                    |
    +---------------+---------------+
    |               |               |
    v               v               v
+--------+     +--------+     +--------+
| ALPHA  |     |  BETA  |     | GAMMA  |
+--------+     +--------+     +--------+
| Task 1 |     | Task 2 |     | Task 3 |
| [desc] |     | [desc] |     | [desc] |
+--------+     +--------+     +--------+
| Files: |     | Files: |     | Files: |
| - x.ts |     | - y.ts |     | - z.ts |
| - a.ts |     | - b.ts |     | - c.ts |
+--------+     +--------+     +--------+

+==============================================================+
```

## 5. Display Task Details

```
TASK DETAILS:

TASK 1: [Task Name]
Zone: ALPHA
Action: [What to implement]
Files:
  - src/models/user.ts (create)
  - src/types/user.ts (create)
Verify: [Verification criteria]
Done when: [Completion criteria]

--------------------------------------------------------------

TASK 2: [Task Name]
Zone: BETA
Action: [What to implement]
Files:
  - src/services/auth.ts (create)
Verify: [Verification criteria]
Done when: [Completion criteria]

--------------------------------------------------------------

TASK 3: [Task Name]
Zone: GAMMA
Action: [What to implement]
Files:
  - src/routes/auth.ts (create)
  - src/middleware/auth.ts (create)
Verify: [Verification criteria]
Done when: [Completion criteria]

+==============================================================+
```

## 6. Display Checkpoints (if any)

```
if PLAN.md contains checkpoints:

CHECKPOINTS:

[1] VERIFY after Task 1-2:
    "Confirm data models before routes"
    - Check: [verification step]

[2] DECISION before Task 3:
    "Choose authentication strategy"
    - Option A: JWT tokens
    - Option B: Session-based

+==============================================================+
```

## 7. Display Execution Info

```
EXECUTION INFO:

Strategy: [A: Autonomous / B: Segmented / C: Decision-Dependent]
Parallel execution: [Yes/No]
Expected commits: [N] tasks + 1 docs = [N+1] total

Quality Gates:
- TypeScript: [Enabled/Disabled]
- Build: [Enabled/Disabled]
- Tests: [Enabled/Disabled]
- Lint: [Enabled/Disabled]

+==============================================================+
```

## 8. Show Actions

```
ACTIONS:

- /ace:execute-plan    Execute this plan
- /ace:plan-phase [N]  Create a different plan
- /ace:validate-plan   Validate plan before execution
- /ace:progress        Check project status

+==============================================================+
```

</process>

<display_rules>
**Visual consistency:**
- Use ASCII box drawing for structure
- Align columns in tables
- Show empty zones as "[ --- ]" if no task assigned

**Information density:**
- Full task details for inspection
- Show all file patterns clearly
- Include checkpoint details if present

**Read-only emphasis:**
- No modifications to any files
- No execution triggers
- Pure display command
</display_rules>

<success_criteria>
- [ ] Plan located (from STATE.md or arguments)
- [ ] Visual task distribution displayed
- [ ] All task details shown
- [ ] Checkpoints displayed if present
- [ ] Zone assignments clear
- [ ] File patterns visible
- [ ] Next actions suggested
</success_criteria>
