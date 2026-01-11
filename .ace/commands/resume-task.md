---
name: ace:resume-task
description: Resume a specific interrupted task
argument-hint: "[task-id, e.g., 01-02-1]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Task
---

<objective>
Resume execution of a specific task that was interrupted.

Used when execution stopped mid-task (not between tasks).
</objective>

<context>
Task ID: $ARGUMENTS (required - format: {phase}-{plan}-{task})

**Required:**
@.ace/planning/STATE.md
PLAN.md for the specified plan
</context>

<process>

## 1. Parse Task ID

```
if $ARGUMENTS is empty or invalid format:
    Error: "Specify task: /ace:resume-task 01-02-1"
```

Extract: phase, plan, task number

## 2. Load Task Context

Read PLAN.md for that task:
- Task description
- Zone assignment
- Files involved
- Verification criteria

## 3. Check Git State

```bash
git status --porcelain
git log --oneline -5
```

Determine:
- What commits exist for this plan
- What files have uncommitted changes
- What work was already done

## 4. Display Resume Context

```
+==============================================================+
|                    RESUME TASK                               |
+==============================================================+

Task: [task_id] - [task name]
Zone: [ALPHA/BETA/GAMMA]

Previous Work:
- [Files already created/modified]
- [Commits already made]

Remaining:
- [What still needs to be done]

+==============================================================+
```

## 5. Resume Execution

Spawn Team Lead for just this task:
- Provide context of what's already done
- Complete remaining work
- Commit when done

## 6. Update State

After completion:
- Update STATE.md
- Continue with remaining tasks if any

</process>

<success_criteria>
- [ ] Task context loaded
- [ ] Previous work identified
- [ ] Task completed
- [ ] Properly committed
</success_criteria>
