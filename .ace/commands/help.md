---
name: ace:help
description: Display all Ace commands
argument-hint: ""
allowed-tools:
  - Read
---

<objective>
Display comprehensive help for all Ace commands with quick reference and categorized listings.
</objective>

<process>

Display:

```
+==============================================================+
|                    ACE HELP                             |
+==============================================================+

Ace - Unified Multi-Agent Orchestration System

+--------------------------------------------------------------+
|                    QUICK REFERENCE                           |
+--------------------------------------------------------------+

QUICK START:
  /ace:init           # Fast setup (or new-project + create-roadmap)
  /ace:plan-phase 1   # Plan first phase
  /ace:execute-plan   # Run the plan
  /ace:verify-work    # Test results

COMMON WORKFLOWS:
  /ace:progress       # Where am I?
  /ace:list-phases    # See all phases
  /ace:show-plan      # View current plan
  /ace:resume-work    # Continue after break

+--------------------------------------------------------------+
|                    PROJECT LIFECYCLE (4)                     |
+--------------------------------------------------------------+

/ace:new-project [name]
    Initialize project with PROJECT.md
    Creates: .ace/planning/PROJECT.md

/ace:create-roadmap
    Build ROADMAP.md and STATE.md
    Requires: PROJECT.md exists

/ace:map-codebase [area]
    Analyze existing code (7 documents)
    Creates: .ace/planning/codebase/
    Use for: Brownfield projects

/ace:init
    Fast project setup (combines new-project + create-roadmap)
    For quick starts without detailed planning

+--------------------------------------------------------------+
|                    PHASE MANAGEMENT (7)                      |
+--------------------------------------------------------------+

/ace:plan-phase [N]
    Create PLAN.md for phase N
    Max 3 tasks per plan

/ace:execute-plan [path]
    Run current plan with parallel Team Leads
    Creates atomic commits per task

/ace:add-phase
    Append new phase to roadmap

/ace:insert-phase [N]
    Insert urgent phase at position N

/ace:remove-phase [N]
    Remove phase N from roadmap

/ace:discuss-phase [N]
    Pre-planning context gathering
    Use before plan-phase for complex phases

/ace:research-phase [N]
    Deep ecosystem research
    Use for phases needing external knowledge

+--------------------------------------------------------------+
|                    VALIDATION (3)                            |
+--------------------------------------------------------------+

/ace:validate-plan [path]
    Validate PLAN.md before execution
    Checks zone conflicts, file patterns, dependencies

/ace:validate-zones
    Verify zone definitions match project type
    Checks for overlapping file patterns

/ace:recover-execution [plan_id]
    Recover from failed or interrupted execution
    Identifies incomplete tasks and resumes

+--------------------------------------------------------------+
|                    PROGRESS & DISPLAY (4)                    |
+--------------------------------------------------------------+

/ace:progress
    Show status and suggest next steps
    Alias: "Ace status"

/ace:status
    Quick status check (alias for progress)

/ace:list-phases
    Display all phases at a glance
    Shows progress, dependencies, statistics

/ace:show-plan [plan_id]
    Display current plan without executing
    Visual task distribution and details

+--------------------------------------------------------------+
|                    VERIFICATION (3)                          |
+--------------------------------------------------------------+

/ace:verify-work [plan_id]
    User acceptance testing
    Captures issues for fix planning

/ace:plan-fix [plan_id]
    Plan fixes for UAT issues
    Creates fix plan from UAT-ISSUES.md

/ace:consider-issues
    Review deferred issues from ISSUES.md
    Decide which to address in next plan

+--------------------------------------------------------------+
|                    SESSION MANAGEMENT (3)                    |
+--------------------------------------------------------------+

/ace:pause-work
    Create handoff document
    Saves context for later resume

/ace:resume-work
    Restore from last session
    Alias: "Ace resume"

/ace:resume-task [id]
    Resume specific interrupted task
    For targeted task recovery

+--------------------------------------------------------------+
|                    CONFIGURATION (2)                         |
+--------------------------------------------------------------+

/ace:config [key] [value]
    View or modify Ace settings
    Examples: config workflow.mode yolo

/ace:help
    Show this help (you're here!)

+--------------------------------------------------------------+
|                    COMMAND COUNT: 26                         |
+--------------------------------------------------------------+

+==============================================================+
|                    WORKFLOWS                                 |
+==============================================================+

NEW PROJECT (Greenfield):
  1. /ace:new-project "My App"
  2. /ace:create-roadmap
  3. /ace:plan-phase 1
  4. /ace:execute-plan
  5. /ace:verify-work

EXISTING PROJECT (Brownfield):
  1. /ace:map-codebase
  2. /ace:new-project "My App"
  3. Continue as greenfield...

FAST START:
  1. /ace:init
  2. /ace:plan-phase 1
  3. /ace:execute-plan

RESUME SESSION:
  /ace:progress      # See where you are
  /ace:resume-work   # Restore context

PHASE ITERATION:
  /ace:list-phases         # Overview
  /ace:plan-phase [N]      # Plan
  /ace:show-plan           # Review
  /ace:execute-plan        # Execute
  /ace:verify-work         # Test

FIX ISSUES:
  /ace:verify-work         # Find issues
  /ace:plan-fix            # Plan fixes
  /ace:execute-plan        # Apply fixes

+==============================================================+
|                    LEGACY ACTIVATION                         |
+==============================================================+

These also work:
  "Ace"         - Auto-detect and start
  "Ace [type]"  - Start with project type
  "Ace status"  - Show progress
  "Ace resume"  - Resume work

+==============================================================+
|                    ARCHITECTURE                              |
+==============================================================+

                   ORCHESTRATOR
                        |
        +---------------+---------------+
        |               |               |
     ALPHA           BETA            GAMMA
     Lead            Lead            Lead
        |               |               |
     mini            mini            mini
    agents          agents          agents

Team Leads execute in parallel.
Each commits atomically to their zone.
Main context stays lean (~5% usage).

+==============================================================+
|                    MORE INFO                                 |
+==============================================================+

Documentation:
  .ace/SKILL.md           Full system documentation
  .ace/config.json        Configuration settings
  .ace/commands/*.md      Individual command definitions
  .ace/templates/         Document templates

+==============================================================+
```

</process>
