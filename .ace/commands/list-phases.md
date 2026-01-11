---
name: ace:list-phases
description: Display all phases at a glance with progress overview
argument-hint: ""
allowed-tools:
  - Read
  - Glob
---

<objective>
Display a comprehensive overview of all project phases, their status, dependencies, and progress.

This is the "big picture" command for understanding project structure.
</objective>

<context>
**Required:**
@.ace/planning/ROADMAP.md
@.ace/planning/STATE.md

**Optional:**
@.ace/planning/PROJECT.md (for project name)
</context>

<process>

## 1. Check Project Exists

```
if .ace/planning/ROADMAP.md does not exist:

+==============================================================+
|                    NO ROADMAP FOUND                          |
+==============================================================+

No roadmap exists for this project.

Options:
- /ace:new-project     Start a new project
- /ace:create-roadmap  Create roadmap (if PROJECT.md exists)

+==============================================================+
```

## 2. Load Phase Data

Read ROADMAP.md and STATE.md to extract:
- All phases with names and goals
- Status of each phase (Not Started / In Progress / Complete)
- Plans completed vs total per phase
- Dependencies between phases
- Current phase indicator

## 3. Display Phase Overview

```
+==============================================================+
|                    PROJECT PHASES                            |
+==============================================================+
|  Project: [Name from PROJECT.md]                             |
|  Total Phases: [N]                                           |
|  Overall Progress: [##########..........] 50%                |
+==============================================================+

PHASE OVERVIEW:

| # | Phase Name       | Status       | Plans    | Deps    |
|---|------------------|--------------|----------|---------|
| 1 | [Foundation]     | [Complete]   | 2/2 [**] | None    |
| 2 | [Core Features]  | [In Progress]| 1/3 [*-] | 1       |
| 3 | [Integration]    | [Not Started]| 0/2 [--] | 2       |
| 4 | [Polish]         | [Not Started]| 0/1 [-]  | 3       |

Legend: [*] = Complete, [-] = Pending

+==============================================================+
```

## 4. Highlight Current Phase

```
CURRENT PHASE: [2] - [Core Features]
+--------------------------------------------------------------+
|                                                              |
|  Goal: [Phase goal from ROADMAP.md]                          |
|                                                              |
|  Progress:                                                   |
|  - [x] 02-01: [Plan name] (verified)                         |
|  - [ ] 02-02: [Plan name] (current)                          |
|  - [ ] 02-03: [Plan name]                                    |
|                                                              |
+--------------------------------------------------------------+
```

## 5. Show Dependency Graph

```
DEPENDENCY FLOW:

    [1: Foundation]
          |
          v
    [2: Core Features] <-- YOU ARE HERE
          |
          v
    [3: Integration]
          |
          v
    [4: Polish]

+==============================================================+
```

## 6. Show Phase Statistics

```
PHASE STATISTICS:

| Phase | Plans | Duration | Avg/Plan |
|-------|-------|----------|----------|
| 1     | 2     | 45 min   | 22 min   |
| 2     | 1/3   | 18 min   | 18 min   |
| 3     | -     | -        | -        |
| 4     | -     | -        | -        |

Total Time: 1.05 hours
Estimated Remaining: ~1.5 hours (based on avg)

+==============================================================+
```

## 7. Suggest Next Action

Based on current state:

```
NEXT ACTIONS:

- /ace:plan-phase 2    Continue current phase
- /ace:show-plan       View current plan details
- /ace:progress        Detailed status check

+==============================================================+
```

</process>

<output_format>
The display should be scannable and informative:

1. **Header** - Project name and overall progress
2. **Phase Table** - Quick view of all phases with status indicators
3. **Current Phase** - Detailed view of active phase with plan checklist
4. **Dependency Graph** - Visual flow showing phase relationships
5. **Statistics** - Time metrics per phase
6. **Next Actions** - Context-aware suggestions
</output_format>

<success_criteria>
- [ ] All phases displayed with status
- [ ] Current phase highlighted
- [ ] Dependencies shown visually
- [ ] Progress percentages accurate
- [ ] Next action suggested based on state
</success_criteria>
