---
name: ace:next
description: Auto-continue to the next logical workflow command
argument-hint: ""
allowed-tools:
  - Read
  - Glob
---

<objective>
Determine the project's current state and automatically run the next logical Ace command.

This is the "smart continuation" entry point for users who say "next" or press Enter.
</objective>

<context>
**Check for:**
@.ace/planning/PROJECT.md
@.ace/planning/ROADMAP.md
@.ace/planning/STATE.md
</context>

<process>

## 1. Resolve Current State

```
if .ace/planning/PROJECT.md does not exist:
    nextCommand = "/ace:new-project"
    Go to step 4

if .ace/planning/ROADMAP.md does not exist:
    nextCommand = "/ace:create-roadmap"
    Go to step 4

if .ace/planning/STATE.md does not exist:
    nextCommand = "/ace:create-roadmap"
    Go to step 4
```

## 2. Read Status From STATE.md

```
Read STATE.md and extract:
- Status: line starting with "Status:"
- Current phase: parse "Phase: X of Y" to get currentPhase and totalPhases

Normalize status to title case for matching.
```

## 3. Determine Next Command

```
if status == "Ready to plan":
    nextCommand = "/ace:plan-phase [currentPhase]"

if status == "Ready to execute":
    nextCommand = "/ace:execute-plan"

if status == "Phase Complete":
    nextCommand = "/ace:verify-work"

if status == "Verified":
    nextPhase = currentPhase + 1
    if nextPhase <= totalPhases:
        nextCommand = "/ace:plan-phase [nextPhase]"
    else:
        nextCommand = "All phases verified! 🎉"
```

## 4. Auto-Execute

```
Display:
  "Auto-executing: [nextCommand]..."

If nextCommand starts with "/ace:":
    Run it immediately.
Else:
    Display nextCommand as a completion message.
```

</process>

<success_criteria>
- [ ] Correctly detects missing PROJECT.md or ROADMAP.md
- [ ] Reads Status from STATE.md and routes to the right command
- [ ] Auto-executes the next command when available
</success_criteria>
