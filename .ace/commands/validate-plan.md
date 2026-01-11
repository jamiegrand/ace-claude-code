---
name: ace:validate-plan
description: Verify PLAN.md structure before execution
argument-hint: "[optional: path-to-PLAN.md]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - AskUserQuestion
---

<objective>
Validate a PLAN.md file structure and content before execution.

Catches errors early to prevent execution failures, ensuring all required
fields exist, zones are valid, and there are no conflicts.
</objective>

<context>
Plan path: $ARGUMENTS (optional - defaults to current plan from STATE.md)

**Required:**
@.ace/planning/STATE.md (if no path provided)
@.ace/project-types.json

**Load:**
Target PLAN.md file
</context>

<process>

## 1. Locate Plan File

```
if $ARGUMENTS provided:
    plan_path = $ARGUMENTS
else:
    Read STATE.md for current plan path

if plan not found:
    Error: "No plan file found. Provide path or run /ace:plan-phase first"
```

## 2. Parse Plan Structure

Read the PLAN.md and extract:
- Header metadata (Plan ID, Phase, Name)
- Task blocks
- Checkpoint definitions (if any)

```
+==============================================================+
|                    PLAN VALIDATION                           |
+==============================================================+

Plan: [plan_path]
Parsing structure...
```

## 3. Validate Required Fields

For each task block, check required fields:

### Required Task Fields
| Field       | Required | Format                          |
|-------------|----------|---------------------------------|
| Zone        | YES      | ALPHA, BETA, or GAMMA           |
| Files       | YES      | List of file patterns           |
| Action      | YES      | Description of what to do       |
| Verify      | YES      | How to verify completion        |
| Done when   | YES      | Completion criteria             |

### Validation Process

```
FIELD VALIDATION:

Task 1: "Create user model"
  Line 15: [*] Zone: ALPHA
  Line 16: [*] Files: src/models/user.ts
  Line 17: [*] Action: Present
  Line 20: [*] Verify: Present
  Line 23: [*] Done when: Present

Task 2: "Add auth service"
  Line 30: [*] Zone: BETA
  Line 31: [X] Files: MISSING
  Line 32: [*] Action: Present
  Line 35: [X] Verify: MISSING
  Line 38: [*] Done when: Present

+==============================================================+
```

Report errors with line numbers:

```
ERRORS FOUND:

Line 31: Task 2 missing required field "Files"
         Expected: Files: <list of file patterns>

Line 35: Task 2 missing required field "Verify"
         Expected: Verify: <verification steps>

+==============================================================+
```

## 4. Validate Zone Assignments

Load project-types.json and verify:

1. All zones are valid (ALPHA, BETA, GAMMA)
2. No invalid zone names used

```
ZONE VALIDATION:

Task 1: Zone ALPHA - VALID
Task 2: Zone BETA - VALID
Task 3: Zone DELTA - INVALID

ERROR Line 45: Invalid zone "DELTA"
               Valid zones: ALPHA, BETA, GAMMA

+==============================================================+
```

## 5. Check Zone Conflicts

Verify no file pattern appears in multiple task zones:

```
ZONE CONFLICT CHECK:

Checking file patterns across tasks...

Task 1 (ALPHA): src/models/**
Task 2 (BETA):  src/services/**
Task 3 (GAMMA): src/routes/**

Conflict detected!
  Task 1 (ALPHA): src/utils/helpers.ts
  Task 2 (BETA):  src/utils/**

  File src/utils/helpers.ts matched by both ALPHA and BETA

ERROR: Zone conflict at lines 18, 33
       Same files assigned to multiple zones

+==============================================================+
```

Cross-reference with project-types.json zones:

```
PROJECT TYPE ZONE CHECK:

Project type: backend

Task 1 files vs ALPHA zone:
  src/models/user.ts -> ALPHA owns src/models/** [OK]

Task 2 files vs BETA zone:
  src/routes/auth.ts -> BETA forbidden src/routes/** [ERROR]

ERROR Line 33: File pattern src/routes/auth.ts
               Assigned to BETA but BETA has src/routes/** in forbidden list
               Should be assigned to: GAMMA

+==============================================================+
```

## 6. Validate Checkpoint Syntax

If plan contains checkpoints, validate format:

### Valid Checkpoint Formats
```markdown
<!-- VERIFY: Description here -->
<!-- DECISION: Question here -->
```

### Checkpoint Validation
```
CHECKPOINT VALIDATION:

Line 50: <!-- VERIFY: Test auth flow --> [VALID]
Line 75: <!-- DECISION: Use JWT or sessions --> [VALID]
Line 90: <!-- CHECKPOINT: Review --> [INVALID]

ERROR Line 90: Invalid checkpoint syntax
               Expected: <!-- VERIFY: ... --> or <!-- DECISION: ... -->
               Found: <!-- CHECKPOINT: ... -->

+==============================================================+
```

Check checkpoint placement:
- VERIFY should come after a set of related tasks
- DECISION should come before tasks that depend on the choice

## 7. Additional Validations

### Task Count
```
TASK COUNT: 3 tasks

[OK] Within recommended limit (max 3 per plan)
```

Or if exceeded:
```
WARNING: 5 tasks in plan
         Recommended maximum is 3 tasks per plan
         Consider splitting into multiple plans
```

### File Pattern Validity
```
FILE PATTERN CHECK:

Task 1:
  src/models/user.ts - [OK] Valid path
  src/models/*.ts - [OK] Valid glob
  models/user - [WARN] Missing extension

WARNING Line 18: File pattern "models/user" has no extension
                 Consider: models/user.ts or models/user.*

+==============================================================+
```

## 8. Validation Summary

```
+==============================================================+
|                    VALIDATION SUMMARY                        |
+==============================================================+

Plan: [plan_id] - [plan name]
File: [plan_path]

RESULTS:
+------------------+--------+--------+--------+
| Check            | Pass   | Warn   | Fail   |
+------------------+--------+--------+--------+
| Required Fields  |   4    |   0    |   2    |
| Zone Validity    |   3    |   0    |   0    |
| Zone Conflicts   |   2    |   0    |   1    |
| Checkpoints      |   2    |   0    |   1    |
| File Patterns    |   5    |   1    |   0    |
+------------------+--------+--------+--------+
| TOTAL            |  16    |   1    |   4    |
+------------------+--------+--------+--------+

STATUS: FAILED (4 errors)

+==============================================================+
```

## 9. Error Report

If errors found:

```
ERRORS TO FIX:

1. Line 31: Missing required field "Files" in Task 2
   Fix: Add "Files:" field with target file patterns

2. Line 35: Missing required field "Verify" in Task 2
   Fix: Add "Verify:" field with verification steps

3. Line 33: Zone conflict - src/routes/auth.ts assigned to BETA
   Fix: Move to Task 3 (GAMMA) or reassign zone

4. Line 90: Invalid checkpoint syntax
   Fix: Change to <!-- VERIFY: Review --> or <!-- DECISION: Review -->

Run /ace:plan-phase [N] --fix to auto-correct issues
Or edit manually and re-run /ace:validate-plan

+==============================================================+
```

## 10. Success Report

If all validations pass:

```
+==============================================================+
|                    VALIDATION PASSED                         |
+==============================================================+

Plan: [plan_id] - [plan name]
Tasks: 3
Checkpoints: 2

All validations passed:
[*] Required fields present
[*] Valid zone assignments
[*] No zone conflicts
[*] Valid checkpoint syntax
[*] File patterns valid

Ready for execution.

Next: /ace:execute-plan

+==============================================================+
```

</process>

<validation_rules>

## Required Field Patterns

```regex
Zone:\s*(ALPHA|BETA|GAMMA)
Files:\s*.+
Action:\s*.+
Verify:\s*.+
Done when:\s*.+
```

## Checkpoint Patterns

```regex
<!--\s*(VERIFY|DECISION):\s*.+\s*-->
```

## Zone Ownership Rules

Files can only be assigned to zones that:
1. Have the pattern in their "owns" list
2. Do NOT have the pattern in their "forbidden" list

</validation_rules>

<success_criteria>
- [ ] Plan file located and parsed
- [ ] All required fields checked with line numbers
- [ ] Zone assignments validated against project type
- [ ] No zone conflicts between tasks
- [ ] Checkpoint syntax validated
- [ ] Clear error report with fix suggestions
- [ ] Pass/fail status clearly indicated
</success_criteria>
