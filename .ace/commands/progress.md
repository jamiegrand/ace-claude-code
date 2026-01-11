---
name: ace:progress
description: Show project status and suggest next steps
argument-hint: ""
allowed-tools:
  - Read
  - Glob
---

<objective>
Display current project status and intelligently route to the appropriate next action.

This is the "where am I?" command for any session.
</objective>

<context>
**Check for:**
@.ace/planning/STATE.md
@.ace/planning/PROJECT.md
@.ace/planning/ROADMAP.md
</context>

<process>

## 1. Check Project State

### No Project Initialized
```
if .ace/planning/PROJECT.md does not exist:

+==============================================================+
|                    NO PROJECT FOUND                          |
+==============================================================+

No Ace project initialized in this directory.

Options:
- /ace:new-project     Start a new project
- /ace:map-codebase    Analyze existing code first

+==============================================================+
```

### No Roadmap
```
if PROJECT.md exists but ROADMAP.md does not:

+==============================================================+
|                    PROJECT INITIALIZED                       |
+==============================================================+

Project: [name from PROJECT.md]
Status: Needs roadmap

Next: /ace:create-roadmap

+==============================================================+
```

### Active Project
```
if STATE.md exists:

Read STATE.md and display:

+==============================================================+
|                    ACE STATUS                           |
+==============================================================+

Project: [name]
Core Value: [one-liner]

Current Position:
  Phase: [X] of [Y] ([Phase Name])
  Plan:  [A] of [B]
  Status: [Ready to plan / In progress / Complete]

Progress: [##########..........] 50%

Last Activity: [date] - [description]

+==============================================================+

Performance:
  Plans completed: [N]
  Average duration: [X] min

Open Issues: [N] (see /ace:consider-issues)
Blockers: [None / List]

+==============================================================+

## Suggest Next Action

Based on status:
- "Ready to plan" -> /ace:plan-phase [N]
- "Ready to execute" -> /ace:execute-plan
- "In progress" -> /ace:resume-work
- "Phase complete" -> /ace:plan-phase [N+1] or /ace:verify-work

+==============================================================+
```

## 2. Check for Resume File

```
if .continue-here*.md exists:
    Add to output:

    Resume file found: [path]
    Run /ace:resume-work to continue

```

## 3. Display Roadmap Overview

```
+==============================================================+
|                    ROADMAP OVERVIEW                          |
+==============================================================+

| Phase | Name           | Status      | Plans |
|-------|----------------|-------------|-------|
| 1     | [Foundation]   | [Complete]  | 2/2   |
| 2     | [Core]         | [In Progress] | 1/3 |
| 3     | [Integration]  | [Not Started] | 0/2 |

+==============================================================+
```

</process>

<routing_logic>
Based on project state, suggest:

| State | Next Action |
|-------|-------------|
| No project | /ace:new-project |
| No roadmap | /ace:create-roadmap |
| Ready to plan | /ace:plan-phase [N] |
| Ready to execute | /ace:execute-plan |
| Has continue file | /ace:resume-work |
| Phase complete | /ace:verify-work or next phase |
| All complete | Congratulations! |
</routing_logic>

<success_criteria>
- [ ] Current state accurately displayed
- [ ] Appropriate next action suggested
- [ ] Resume file detected if present
</success_criteria>
