---
name: ace:status
description: Quick project status check with compact output
argument-hint: ""
allowed-tools:
  - Read
  - Glob
---

<objective>
Display a compact, fast project status overview.

This is a lightweight alternative to /ace:progress - same information, faster output.
</objective>

<context>
**Quick check files:**
@.ace/planning/STATE.md
@.ace/planning/PROJECT.md
@.ace/planning/ROADMAP.md
</context>

<process>

## 1. Quick State Check

```
if PROJECT.md does not exist:
    Display:
    [!] No project. Run /ace:new-project or /ace:init
    EXIT

if ROADMAP.md does not exist:
    Display:
    [!] No roadmap. Run /ace:create-roadmap
    EXIT
```

## 2. Compact Status Display

```
Read STATE.md and display:

+----------------------------------------------+
|  [Project Name]                              |
+----------------------------------------------+
  Phase: [X]/[Y] - [Phase Name]
  Plan:  [A]/[B] - [Plan Name]
  Status: [Ready/In Progress/Complete]

  [##########..........] 50%

  Next: /ace:[suggested-command]
+----------------------------------------------+
```

## 3. Progress Bar Calculation

```
Calculate overall progress:
- Count completed phases
- Count completed plans in current phase
- Show as visual bar: [####........] XX%

Formula:
  completedPhases = phases marked complete
  currentPhasePlans = plans completed in current phase / total plans
  overallProgress = (completedPhases + currentPhasePlans) / totalPhases * 100
```

## 4. Quick Next Action

Based on STATUS field in STATE.md:
| Status | Suggestion |
|--------|------------|
| needs-roadmap | /ace:create-roadmap |
| ready-to-plan | /ace:plan-phase [N] |
| ready-to-execute | /ace:execute-plan |
| in-progress | /ace:resume-work |
| phase-complete | /ace:plan-phase [N+1] |
| all-complete | Project finished! |

## 5. Resume File Detection

```
if .continue-here*.md exists:
    Add to output:
    [i] Resume file found - run /ace:resume-work
```

</process>

<success_criteria>
- [ ] Status displayed in 5 lines or less
- [ ] Progress bar shown
- [ ] Next action clearly suggested
- [ ] Executes quickly (minimal file reads)
</success_criteria>
