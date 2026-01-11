---
name: ace:pause-work
description: Create handoff document for session pause
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Bash
---

<objective>
Create a continue-here document that enables seamless session resumption.

Captures current state and context for the next session.
</objective>

<context>
**Required:**
@.ace/planning/STATE.md

**Check for:**
- Active plan in progress
- Uncommitted changes
</context>

<process>

## 1. Capture Current State

Read STATE.md and determine:
- Current phase and plan
- Last completed task
- Any in-progress work

## 2. Check for Uncommitted Changes

```bash
git status --porcelain
```

If uncommitted changes exist:
- List them
- Ask if they should be committed or stashed

## 3. Create Continue-Here Document

Write to `.ace/planning/.continue-here-{timestamp}.md`:

```markdown
# Continue Here

**Paused:** [YYYY-MM-DD HH:MM]

## Current Position

Phase: [X] of [Y] ([Phase Name])
Plan: [A] of [B]
Task: [Last completed / In progress]

## What Was Happening

[Description of current work state]

## Uncommitted Changes

[List of uncommitted files, if any]

## Next Actions

1. [Immediate next step]
2. [Following step]

## Context Notes

[Any important context for resumption]

## To Resume

Run: /ace:resume-work
```

## 4. Update STATE.md

Set:
- Session continuity: paused
- Resume file: path to continue-here

## 5. Git Commit (WIP)

If there's uncommitted planning work:

```bash
git add .ace/planning/
git commit -m "wip: [phase-name] paused at task [X]/[Y]

[Brief description]
"
```

## 6. Confirmation

```
+==============================================================+
|                    WORK PAUSED                               |
+==============================================================+

Handoff created: .ace/planning/.continue-here-[timestamp].md

Current State:
  Phase: [X] - [Name]
  Plan: [A] of [B]
  Progress: [##########..........] 50%

To continue later:
  /ace:resume-work

+==============================================================+
```

</process>

<success_criteria>
- [ ] Continue-here document created
- [ ] STATE.md updated with resume file path
- [ ] WIP committed if applicable
- [ ] User informed how to resume
</success_criteria>
