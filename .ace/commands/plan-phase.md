---
name: ace:plan-phase
description: Generate PLAN.md for specified phase
argument-hint: "[phase number]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - AskUserQuestion
---

<objective>
Create a PLAN.md with maximum 3 atomic tasks for the specified phase.

Each task is assigned to a zone (ALPHA/BETA/GAMMA) for parallel execution.
</objective>

<context>
Phase number: $ARGUMENTS (required)

**Required:**
@.ace/planning/STATE.md
@.ace/planning/PROJECT.md
@.ace/planning/ROADMAP.md

**Load:**
@.ace/config.json (for project type)
@.ace/project-types.json (for zone definitions)

**Optional:**
@.ace/planning/codebase/ (if exists)
@.ace/planning/ISSUES.md (for deferred items to address)

**Template:**
@.ace/templates/planning/plan.md
</context>

<process>

## 1. Validate Phase Number

```
if $ARGUMENTS is empty:
    Error: "Specify phase number: /ace:plan-phase 1"

if phase $ARGUMENTS not in ROADMAP.md:
    Error: "Phase $ARGUMENTS not found in ROADMAP.md"
```

## 2. Load Context

Read and understand:
- Current phase goal from ROADMAP.md
- Project requirements from PROJECT.md
- Current state from STATE.md
- Project type and zone definitions
- Any open issues to potentially address

## 3. Determine Plan Number

```
count existing plans in .ace/planning/phases/{phase}/
next_plan = count + 1
plan_id = "{phase:02d}-{next_plan:02d}"
```

## 4. Design Tasks

Create maximum 3 tasks based on:
- Phase goal
- Zone ownership (project-types.json)
- Dependencies between tasks

Each task must:
- Be assigned to exactly one zone
- Have clear file scope
- Be independently committable
- Have verification criteria

## 5. Display Visual Plan

```
+==============================================================+
|                    ACE PLAN                             |
+==============================================================+
|  Phase: [X] - [Phase Name]                                   |
|  Plan: [Y] of [estimated]                                    |
+==============================================================+

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
+--------+     +--------+     +--------+

+==============================================================+
|  Execution: PARALLEL (3 Team Leads)                          |
|  Estimated commits: 4 (3 tasks + 1 docs)                     |
+==============================================================+
```

## 6. Get Approval

Use AskUserQuestion:
- "Ready to create this plan?"
- Options: "Yes, create PLAN.md" / "Adjust tasks"

## 7. Create PLAN.md

Create directory if needed:
```bash
mkdir -p .ace/planning/phases/{phase:02d}-{phase-name}/
```

Write to `.ace/planning/phases/{phase}/{plan_id}-PLAN.md`

## 8. Update STATE.md

```
Status: Ready to execute
Current plan: {plan_id}
```

## 9. Next Steps

Display:
```
PLAN.md created: .ace/planning/phases/{phase}/{plan_id}-PLAN.md

Next: /ace:execute-plan
```

</process>

<task_rules>
**Maximum 3 tasks per plan** - Prevents context degradation

**Zone assignment:**
- Each task to exactly one zone (ALPHA/BETA/GAMMA)
- Based on file patterns from project-types.json
- No file conflicts between zones

**Task structure:**
- Zone: Which Team Lead owns this
- Files: Exact files to create/modify
- Action: What to implement
- Verify: How to validate
- Done when: Completion criteria
</task_rules>

<success_criteria>
- [ ] Phase exists in ROADMAP.md
- [ ] PLAN.md created with max 3 tasks
- [ ] Each task assigned to a zone
- [ ] STATE.md updated
- [ ] User informed of next steps (/ace:execute-plan)
</success_criteria>
