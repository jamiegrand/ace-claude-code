---
name: ace:execute-plan
description: Execute current PLAN.md with parallel Team Leads
argument-hint: "[optional: path-to-PLAN.md]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Task
  - AskUserQuestion
---

<objective>
Execute a PLAN.md file by spawning parallel Team Leads, each committing atomically.

This is Ace's core execution engine combining:
- Planckatron's parallel 3-tier hierarchy
- GSD's per-task atomic commits and context management
</objective>

<context>
Plan path: $ARGUMENTS (optional - defaults to current plan from STATE.md)

**Required:**
@.ace/planning/STATE.md
@.ace/config.json
@.ace/project-types.json

**Load plan:**
If $ARGUMENTS provided: Use that path
Else: Read STATE.md for current plan path

**Templates:**
@.ace/templates/planning/summary.md
</context>

<execution_strategies>

## Workflow Mode (from config.json)

```
Read config.json for workflow.mode

if workflow.mode == "yolo":
    - Skip plan approval confirmation
    - Auto-proceed at checkpoints
    - Only stop on errors or architectural decisions
    - Faster execution, less interruption

if workflow.mode == "interactive" (default):
    - Show plan before execution
    - Pause at checkpoints for user confirmation
    - Standard behavior with user approvals
```

## Strategy A: Fully Autonomous (No Checkpoints)
- Plan has no VERIFY or DECISION checkpoints
- Spawn all Team Leads in single message
- Each Team Lead commits independently
- Main context: orchestration only (~5% usage)

## Strategy B: Segmented (Has Verify Checkpoints)
- Execute in segments between checkpoints
- Spawn Team Leads for each segment
- Pause at VERIFY for user confirmation (skip in YOLO mode)
- Continue after verification

## Strategy C: Decision-Dependent (Has Decision Checkpoints)
- Execute in main context (no subagents)
- Decision outcomes affect subsequent tasks
- Quality maintained through small scope (max 3 tasks)
- In YOLO mode: use first/recommended option automatically

</execution_strategies>

<process>

## 1. Pre-Flight Checks

```
if .ace/planning/ does not exist:
    Error: "Run /ace:new-project first"

if PLAN.md not found:
    Error: "No plan to execute. Run /ace:plan-phase [N]"

if SUMMARY.md already exists for this plan:
    Ask: "Plan already executed. Re-run?"
```

## 2. Parse Plan

Read PLAN.md and extract:
- Tasks (max 3)
- Zone assignments
- Checkpoints (if any)
- File patterns per task

Determine execution strategy (A, B, or C)

## 3. Display Execution Plan

```
+==============================================================+
|                    ACE EXECUTE                          |
+==============================================================+
|  Phase: [X] - [Phase Name]                                   |
|  Plan: [plan_id] - [Plan Name]                               |
|  Strategy: [A/B/C] - [Description]                           |
+==============================================================+

TASK DISTRIBUTION:

+------------------+------------------+------------------+
|      ALPHA       |       BETA       |      GAMMA       |
+------------------+------------------+------------------+
| Task: [name]     | Task: [name]     | Task: [name]     |
| Files:           | Files:           | Files:           |
| - model.ts       | - service.ts     | - route.ts       |
+------------------+------------------+------------------+

Execution: PARALLEL
Commits: [N] tasks + 1 docs = [N+1] total

+==============================================================+
```

## 4. Spawn Team Leads (PARALLEL)

**CRITICAL:** Send ALL Task calls in ONE message.

For each task in PLAN.md, spawn a Team Lead:

### Team Lead Prompt Template

**CRITICAL: Use this EXACT prompt structure for best results.**

```
You are **Ace Team Lead [ALPHA/BETA/GAMMA]** - an expert software engineer responsible for implementing one specific task in a parallel execution system.

## CONTEXT

PROJECT: [project name] at [path]
PURPOSE: [One-line description from PROJECT.md]
TECH STACK: [Stack from PROJECT.md or detection]
PLAN: [plan_id] - [plan name]
OVERALL GOAL: [What the full plan achieves - from PLAN.md description]

## YOUR MISSION

You are implementing: **[Task Name]**

WHY THIS MATTERS: [Brief explanation of why this task is needed for the overall goal]

WHAT SUCCESS LOOKS LIKE:
- [Acceptance criterion 1 from PLAN.md]
- [Acceptance criterion 2 from PLAN.md]
- [Acceptance criterion 3 from PLAN.md]

## YOUR ZONE (files you OWN)

You have EXCLUSIVE ownership of:
[Zone patterns from project-types.json]

FORBIDDEN - other teams own these:
[Forbidden patterns]

## EXECUTION APPROACH

Think step-by-step before coding:

1. **UNDERSTAND**: Read any existing files in your zone first
2. **PLAN**: Mentally outline the changes needed
3. **IMPLEMENT**: Write clean, production-quality code
4. **VERIFY**: Test your changes work (run relevant commands)
5. **COMMIT**: Stage only YOUR files and commit

## QUALITY STANDARDS

- Write clean, readable code with meaningful names
- Follow existing patterns in the codebase
- Handle errors gracefully
- NO placeholder code or TODOs - implement fully
- NO comments like "// implement this later"

## IF SOMETHING GOES WRONG

- **Bug found**: Fix it immediately, note in your report
- **Missing dependency**: Install it, note in your report
- **File outside your zone needed**: DO NOT MODIFY IT - note as blocker
- **Architectural question**: STOP and report - don't guess
- **Nice-to-have idea**: Log to ISSUES.md, continue with task

## COMMIT WHEN DONE

After verifying your work:

1. Stage ONLY your files:
   git add [specific-files-you-created-or-modified]

2. Commit with semantic message:
   git commit -m "[type]([plan_id]): [task-name]"

   Types: feat | fix | refactor | test | chore

3. Get the commit hash:
   git rev-parse --short HEAD

## YOUR REPORT

When complete, provide a clear summary:

**Task**: [Task name]
**Status**: COMPLETE | BLOCKED | PARTIAL

**Files Created**:
- path/to/file1.ts
- path/to/file2.ts

**Files Modified**:
- path/to/existing.ts

**Commit**: [hash] - [commit message]

**Deviations** (if any):
- [What you did differently and why]

**Blockers** (if any):
- [What prevented full completion]

**Issues Logged** (nice-to-haves for later):
- [Enhancement ideas added to ISSUES.md]
```

### Mini-Agent Prompt (when Team Lead spawns sub-agents)

If a Team Lead's task requires 3+ file operations, spawn mini-agents:

```
You are a mini-agent working for Team Lead [ALPHA/BETA/GAMMA].

YOUR SPECIFIC SUB-TASK: [Sub-task description]

CONSTRAINTS:
- Work ONLY on: [specific files]
- Do NOT commit - Team Lead will commit all work together
- Report back what you created/modified

CONTEXT FROM TEAM LEAD:
[Relevant context passed down]

When done, report:
- Files created/modified
- Any issues encountered
```

## 5. Show Progress Board

```
+==============================================================+
|                    EXECUTION PROGRESS                        |
+==============================================================+

+------------------+------------------+------------------+
|      ALPHA       |       BETA       |      GAMMA       |
+------------------+------------------+------------------+
| Status: WORKING  | Status: WORKING  | Status: DONE     |
| [*] task 1       | [*] task 1       | [*] task 1       |
|                  |                  | Commit: ghi789   |
+------------------+------------------+------------------+

Progress: [========>           ] 33%
```

Update as each Team Lead reports completion.

## 6. Handle Checkpoints (Strategy B/C)

### VERIFY Checkpoint
```
CHECKPOINT: Verify [description]

[Show what was built]

Verification Questions:
- [ ] [Check 1]
- [ ] [Check 2]

Continue? [Yes / Need fixes]
```

### DECISION Checkpoint
```
CHECKPOINT: Decision Required

[Context for decision]

Options:
1. [Option A]
2. [Option B]

Select option to continue.
```

## 7. Collect Results

Wait for all Team Leads to complete.

Aggregate:
- All files created/modified
- All commit hashes
- All deviations
- All issues logged

## 8. Run Quality Gates

For each enabled gate in config.json:

### 8.1 Check Gate Availability

Before running each gate, verify command exists:

```
TypeScript Check:
  Run: npx tsc --version
  Available if: exit code 0

Build Check:
  Read package.json scripts
  Available if: "build" script exists
  Alt: npm run build --dry-run (if supported)

Lint Check:
  Read package.json scripts
  Available if: "lint" script exists

Test Check:
  Read package.json scripts
  Available if: "test" script exists
```

### 8.2 Run Available Gates

```
QUALITY GATES:
+--------------+--------+
| TypeScript   | RUN    |
| Build        | RUN    |
| Lint         | SKIP   |
| Tests        | SKIP   |
+--------------+--------+
```

For each enabled gate:

```
if gate command exists:
    Run gate command
    if fails:
        Identify which zone's files failed
        Spawn targeted fix agent
        Re-run checks
else:
    Display: "Skipping [gate] - command not available"
    Log status as SKIP (unavailable)
    Continue to next gate
```

### 8.3 Handle Unavailable Gates

Gates that are skipped due to unavailability should NOT fail execution.

Log skipped gates in SUMMARY.md under "Quality Gates" section:

```
QUALITY GATE RESULTS:
+--------------+------------------------+
| Gate         | Status                 |
+--------------+------------------------+
| TypeScript   | SKIP (not installed)   |
| Build        | PASS                   |
| Lint         | SKIP (no script)       |
| Tests        | PASS                   |
+--------------+------------------------+
```

Status values:
- **PASS** - Gate ran and succeeded
- **FAIL** - Gate ran and failed (triggers fix agent)
- **SKIP (disabled)** - Gate disabled in config.json
- **SKIP (not installed)** - Command/tool not available
- **SKIP (no script)** - No script defined in package.json

## 9. Create SUMMARY.md

Write to `.ace/planning/phases/{phase}/{plan_id}-SUMMARY.md`:
- Tasks completed with commit hashes
- Files created/modified
- Deviations documented
- Quality gate results

## 10. Update STATE.md

Update:
- Current position
- Performance metrics (add duration)
- Session info

## 11. Metadata Commit

```bash
git add .ace/planning/phases/{phase}/{plan_id}-PLAN.md
git add .ace/planning/phases/{phase}/{plan_id}-SUMMARY.md
git add .ace/planning/STATE.md
git add .ace/planning/ROADMAP.md
git commit -m "docs({plan_id}): complete {plan-name} plan

Tasks completed: [N]/[N]
- [Task 1 name]
- [Task 2 name]
- [Task 3 name]
"
```

## 12. Completion Report

```
+==============================================================+
|               ACE COMPLETE                              |
+==============================================================+

Plan: [plan_id] - [plan name]
Duration: [X] minutes

+------------------+------------------+------------------+
|      ALPHA       |       BETA       |      GAMMA       |
+------------------+------------------+------------------+
| [*] COMPLETE     | [*] COMPLETE     | [*] COMPLETE     |
| Files: 2         | Files: 1         | Files: 2         |
| Commit: abc123   | Commit: def456   | Commit: ghi789   |
+------------------+------------------+------------------+

COMMITS:
| Task | Type | Hash    | Message                          |
|------|------|---------|----------------------------------|
| 1    | feat | abc123  | feat(01-02): create user model   |
| 2    | feat | def456  | feat(01-02): add auth service    |
| 3    | feat | ghi789  | feat(01-02): create auth routes  |
| docs | docs | jkl012  | docs(01-02): complete auth plan  |

Quality Gates: PASSED

+==============================================================+

NEXT:
- /ace:verify-work     User acceptance testing
- /ace:plan-phase [N]  Continue to next plan
- /ace:progress        Check overall status

+==============================================================+
```

</process>

<deviation_rules>
During execution, handle discoveries automatically:

1. **Auto-fix bugs** - Fix immediately, document in Summary
2. **Auto-add critical** - Security/correctness gaps, fix and document
3. **Auto-fix blockers** - Can't proceed without fix, do it and document
4. **Ask about architectural** - Major structural changes, STOP and ask user
5. **Log enhancements** - Nice-to-haves, log to ISSUES.md, continue

Only rule 4 requires user intervention.
</deviation_rules>

<commit_rules>
**Per-Task Commits:**
- Stage only files modified by that task
- Commit format: `{type}({phase}-{plan}): {task-name}`
- Record commit hash for SUMMARY.md

**Plan Metadata Commit:**
- Stage: PLAN.md, SUMMARY.md, STATE.md, ROADMAP.md
- Format: `docs({phase}-{plan}): complete {plan-name} plan`
- NO code files (already committed per-task)

**NEVER use:**
- `git add .`
- `git add -A`
- `git add src/`

**Always stage files individually.**
</commit_rules>

<success_criteria>
- [ ] All tasks executed
- [ ] Each task committed individually
- [ ] SUMMARY.md created with commit hashes
- [ ] STATE.md updated
- [ ] ROADMAP.md updated (plan count)
- [ ] Metadata committed
- [ ] User informed of next steps
</success_criteria>
