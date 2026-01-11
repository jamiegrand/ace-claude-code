---
name: ace:resume-work
description: Restore context from last session
argument-hint: ""
allowed-tools:
  - Read
  - Glob
---

<objective>
Restore full context from the last session and continue where we left off.

This is the primary session restoration command.
</objective>

<context>
**Required:**
@.ace/planning/STATE.md

**Check for:**
.ace/planning/.continue-here*.md
</context>

<process>

## 1. Load State

Read STATE.md to understand:
- Current position
- Last activity
- Resume file path (if any)

## 2. Check for Continue-Here File

```
glob: .ace/planning/.continue-here*.md
```

If found:
- Read the most recent one
- Load context from it

## 3. Display Restoration

```
+==============================================================+
|                    SESSION RESTORED                          |
+==============================================================+

Welcome back!

Last Session: [YYYY-MM-DD HH:MM]
Duration Since: [X] hours/days

## Current Position

Phase: [X] of [Y] ([Phase Name])
Plan: [A] of [B]
Status: [Status from STATE.md]

Progress: [##########..........] 50%

## Where You Left Off

[Content from continue-here file]

## Next Actions

1. [From continue-here or inferred]
2. [Following step]

+==============================================================+
```

## 4. Suggest Next Command

Based on status:

| Status | Suggestion |
|--------|------------|
| Ready to plan | /ace:plan-phase [N] |
| Ready to execute | /ace:execute-plan |
| In progress (task) | /ace:resume-task [id] |
| Needs verification | /ace:verify-work |

```
SUGGESTED NEXT:

  /ace:[appropriate-command]

Or run /ace:progress for full status.

+==============================================================+
```

## 5. Clean Up (Optional)

If work resumed successfully, offer to archive continue-here file:
- Move to `.ace/state/archived/`
- Or delete

</process>

<success_criteria>
- [ ] STATE.md loaded
- [ ] Continue-here file found and read (if exists)
- [ ] Context displayed to user
- [ ] Appropriate next action suggested
</success_criteria>
