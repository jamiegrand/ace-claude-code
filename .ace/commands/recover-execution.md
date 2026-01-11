---
name: ace:recover-execution
description: Resume from mid-plan execution failures
argument-hint: "[optional: plan_id]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---

<objective>
Resume execution after a failure during plan execution.

Identifies completed vs failed tasks, offers recovery options, and restores
the execution context to a consistent state.
</objective>

<context>
Plan ID: $ARGUMENTS (optional - auto-detect from STATE.md if not provided)

**Required:**
@.ace/planning/STATE.md
@.ace/config.json

**Load:**
Current PLAN.md from phases/
Git status and log for partial commits
</context>

<process>

## 1. Detect Current State

```
+==============================================================+
|                    EXECUTION RECOVERY                        |
+==============================================================+

Analyzing execution state...
```

Run the following checks:
1. Read STATE.md for current plan info
2. Run `git status` to check for uncommitted changes
3. Run `git log --oneline -10` to find recent commits
4. Check if SUMMARY.md exists (partial or complete)

## 2. Identify Completed Tasks

Parse the PLAN.md and cross-reference with git log:

```
EXECUTION STATE ANALYSIS:

Plan: [plan_id] - [plan name]
Started: [timestamp from STATE.md]

TASK STATUS:
+--------+------------------+----------+------------+
| Zone   | Task             | Status   | Commit     |
+--------+------------------+----------+------------+
| ALPHA  | Create models    | COMPLETE | abc1234    |
| BETA   | Add services     | FAILED   | -          |
| GAMMA  | Create routes    | PENDING  | -          |
+--------+------------------+----------+------------+

UNCOMMITTED CHANGES:
- src/services/auth.ts (modified)
- src/services/user.ts (new file)

+==============================================================+
```

## 3. Diagnose Failure

Identify failure type:
- **Partial commit**: Some files staged/modified but not committed
- **Quality gate failure**: Build/lint/test failed
- **Zone conflict**: Files modified outside assigned zone
- **Timeout**: Agent timed out mid-task
- **Unknown**: Other failure

```
FAILURE DIAGNOSIS:

Type: [failure type]
Zone: BETA
Task: Add services

Details:
[Error message or symptoms]

Affected Files:
- src/services/auth.ts
- src/services/user.ts

+==============================================================+
```

## 4. Present Recovery Options

Use AskUserQuestion:

```
RECOVERY OPTIONS:

1. CONTINUE - Keep completed work, retry failed task
   - Preserves: abc1234 (ALPHA task)
   - Retries: BETA task from scratch
   - Then: Execute remaining tasks

2. ROLLBACK - Revert to pre-execution state
   - Reverts: All commits from this plan
   - Cleans: Uncommitted changes
   - Result: Clean state before plan

3. MANUAL FIX - Keep all changes, manual intervention
   - Keeps: All commits and changes
   - You: Fix issues manually
   - Then: Run /ace:resume-task

4. PARTIAL COMMIT - Commit what works, skip failed
   - Commits: Uncommitted valid changes
   - Skips: Failed task
   - Updates: STATE.md with partial completion

Select option (1-4):
```

## 5. Execute Recovery

### Option 1: CONTINUE

```bash
# Stash any uncommitted changes
git stash save "ace-recovery-stash"

# Note the stash for potential use
```

Update STATE.md:
- Mark completed tasks
- Set failed task as "retry"
- Clear pending tasks

Re-spawn Team Lead for failed zone:
```
Retrying BETA task...
[Spawn team lead with original task]
```

### Option 2: ROLLBACK

```bash
# Find first commit of this plan
FIRST_COMMIT=$(git log --oneline | grep "{plan_id}" | tail -1 | cut -d' ' -f1)

# Revert to before first commit
git reset --hard ${FIRST_COMMIT}^

# Clean untracked files in src/
git clean -fd src/
```

Update STATE.md:
- Reset plan status to "pending"
- Clear execution metrics

```
+==============================================================+
|                    ROLLBACK COMPLETE                         |
+==============================================================+

Reverted to pre-execution state.
All plan commits removed.

Next: /ace:execute-plan to retry

+==============================================================+
```

### Option 3: MANUAL FIX

```
+==============================================================+
|                    MANUAL FIX MODE                           |
+==============================================================+

Current state preserved. Please fix issues manually:

Failed Task: [task name]
Zone: BETA
Files to review:
- src/services/auth.ts
- src/services/user.ts

After fixing:
1. Stage your changes: git add [files]
2. Commit: git commit -m "fix({plan_id}): [description]"
3. Run: /ace:resume-task BETA

+==============================================================+
```

Update STATE.md:
- Status: "manual-fix"
- Failed zone noted

### Option 4: PARTIAL COMMIT

```bash
# Stage the working uncommitted files
git add [valid-files-only]

# Commit as partial
git commit -m "feat({plan_id}): partial - [completed tasks]

Note: Task [failed-task] skipped due to failure.
"
```

Update STATE.md:
- Mark plan as "partial"
- Note skipped tasks
- Update completion percentage

```
+==============================================================+
|                    PARTIAL COMMIT COMPLETE                   |
+==============================================================+

Committed: 2/3 tasks
Skipped: BETA - Add services (failed)

Next steps:
- /ace:plan-fix       Create fix plan for skipped task
- /ace:plan-phase [N] Continue to next plan

+==============================================================+
```

## 6. Update STATE.md

After any recovery option, update STATE.md:

```markdown
## Recovery Log

### [timestamp]
- Plan: [plan_id]
- Failure: [failure type]
- Recovery: [option chosen]
- Result: [outcome]
```

## 7. Completion Report

```
+==============================================================+
|                    RECOVERY COMPLETE                         |
+==============================================================+

Recovery Type: [CONTINUE/ROLLBACK/MANUAL FIX/PARTIAL]
Plan: [plan_id]

Result:
[Summary of what was recovered/reverted/fixed]

Next:
- [Appropriate next command based on recovery type]

+==============================================================+
```

</process>

<recovery_strategies>

## Failure Types and Recommended Actions

| Failure Type       | Recommended   | Alternative    |
|--------------------|---------------|----------------|
| Partial commit     | CONTINUE      | MANUAL FIX     |
| Quality gate fail  | MANUAL FIX    | CONTINUE       |
| Zone conflict      | ROLLBACK      | MANUAL FIX     |
| Timeout            | CONTINUE      | PARTIAL COMMIT |
| Unknown            | MANUAL FIX    | ROLLBACK       |

## Automatic Recovery (YOLO mode)

In YOLO mode, auto-select:
1. Timeout -> CONTINUE
2. Quality gate -> CONTINUE with fixes
3. Zone conflict -> ROLLBACK
4. Other -> MANUAL FIX

</recovery_strategies>

<success_criteria>
- [ ] Execution state accurately diagnosed
- [ ] Completed vs failed tasks identified
- [ ] Recovery options clearly presented
- [ ] Chosen recovery executed successfully
- [ ] STATE.md updated with recovery log
- [ ] Clear next steps provided
- [ ] No orphaned commits or changes
</success_criteria>
