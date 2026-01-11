---
name: ace:init
description: Fast project initialization with sensible defaults
argument-hint: "[project name]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
---

<objective>
Quickly initialize a new project with minimal questions and sensible defaults.

Combines /ace:new-project + /ace:create-roadmap into a single fast command.
Go from zero to ready-to-plan in one step.
</objective>

<context>
Project name: $ARGUMENTS (optional, will prompt if not provided)

**Templates:**
@.ace/templates/planning/project.md
@.ace/templates/planning/roadmap.md
@.ace/templates/planning/state.md

**Check for:**
- Existing PROJECT.md (offer to reinitialize)
- package.json, Cargo.toml, pyproject.toml (detect project type)
- .ace/planning/codebase/ (existing analysis)
</context>

<process>

## 0. Pre-Flight Check

```
if .ace/planning/PROJECT.md exists:
    Ask: "Project already exists. Reinitialize? (y/n)"
    if no: EXIT with /ace:status suggestion
```

## 1. Auto-Detect Project Type

```
Scan for indicators:
- package.json with "next" -> frontend/fullstack
- package.json with "express" or "fastify" -> backend
- package.json with "react" only -> frontend
- Cargo.toml -> backend (Rust)
- pyproject.toml -> backend (Python)
- mcp/agent patterns -> agentic
- multiple package.json files -> monorepo
- tsconfig with "lib" -> library

If detected:
    projectType = [detected]
    Display: "Detected project type: [type]"
else:
    projectType = "fullstack" (default)
```

## 2. Quick Questions (Minimal)

```
if $ARGUMENTS is empty:
    Ask: "Project name?"
else:
    projectName = $ARGUMENTS

Ask: "One sentence - what does this project do?"
    -> coreValue
```

That's it for questions. Everything else uses smart defaults.

## 3. Generate PROJECT.md

```
Create .ace/planning/PROJECT.md:

# [Project Name]

## Core Value
[coreValue from question]

## Overview
[Auto-generated based on project type and coreValue]

## Requirements

### Must Have
- Core functionality based on project type
- (To be refined during planning)

### Should Have
- (To be defined)

### Nice to Have
- (To be defined)

## Technical Stack
[Auto-filled from detected files or project type defaults]

## Constraints
- (None specified - to be added as discovered)

## Success Criteria
- Project successfully delivers core value
- All must-have requirements implemented
- Quality gates pass
```

## 4. Generate ROADMAP.md (Standard 3 Phases)

```
Based on projectType, create standard roadmap:

# [Project Name] Roadmap

## Phase 1: Foundation
**Objective**: Establish core infrastructure and base setup
**Deliverables**:
- [Project type specific foundations]

## Phase 2: Core Features
**Objective**: Implement primary functionality
**Deliverables**:
- [Core value implementation]

## Phase 3: Integration & Polish
**Objective**: Connect components and refine
**Deliverables**:
- Integration and testing
- Polish and optimization
```

### Project Type Specific Foundations

| Type | Phase 1 Focus |
|------|---------------|
| frontend | Component library, routing, state management |
| backend | API structure, database, authentication |
| fullstack | Both frontend + backend foundations |
| agentic | Agent framework, tools, orchestration |
| library | Core API, types, build setup |
| automation | CLI structure, commands, configuration |
| monorepo | Workspace setup, shared packages |

## 5. Initialize STATE.md

```
Create .ace/planning/STATE.md:

# Project State

## Current Position
- Phase: 1 of 3
- Plan: 0 of 0 (not yet planned)
- Status: ready-to-plan

## Progress
- Phases Complete: 0
- Plans Complete: 0

## Last Activity
[timestamp] - Project initialized with /ace:init

## Blockers
None

## Notes
Project initialized with quick-start defaults.
Run /ace:plan-phase 1 to begin detailed planning.
```

## 6. Create Directory Structure

```
Ensure directories exist:
- .ace/planning/
- .ace/planning/phases/
- .ace/planning/phases/phase-1/
- .ace/planning/phases/phase-2/
- .ace/planning/phases/phase-3/
```

## 7. Git Initialization (if enabled)

```
Read config.json for git.autoInit

if git.autoInit AND .git does not exist:
    Run: git init
    Run: git add .ace/ CLAUDE.md
    Run: git commit -m "docs: initialize [project-name] (3 phases)"
```

## 8. Success Output

```
+==============================================================+
|                    PROJECT INITIALIZED                       |
+==============================================================+

Project: [Project Name]
Type:    [projectType]
Phases:  3 (Foundation -> Core -> Integration)

Created:
  [check] .ace/planning/PROJECT.md
  [check] .ace/planning/ROADMAP.md
  [check] .ace/planning/STATE.md
  [check] Phase directories

+==============================================================+

Ready to plan! Next steps:
  1. /ace:plan-phase 1  - Create detailed Phase 1 plan
  2. /ace:execute-plan  - Start building

Or refine first:
  - Edit PROJECT.md to add requirements
  - Edit ROADMAP.md to adjust phases
  - /ace:config to adjust settings

+==============================================================+
```

</process>

<success_criteria>
- [ ] Project type auto-detected or defaulted
- [ ] PROJECT.md created with core value
- [ ] ROADMAP.md created with 3 standard phases
- [ ] STATE.md initialized correctly
- [ ] Phase directories created
- [ ] Git initialized (if enabled)
- [ ] Ready for /ace:plan-phase 1
- [ ] Completed with minimal user input (2 questions max)
</success_criteria>
