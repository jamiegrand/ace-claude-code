---
name: ace:map-codebase
description: Analyze codebase with parallel Explore agents
argument-hint: "[optional: specific area to focus on]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Task
---

<objective>
Analyze existing codebase using 4 parallel Explore agents to produce 7 structured documents.

This enables informed planning for brownfield projects.

Output: `.ace/planning/codebase/` with:
- STACK.md
- ARCHITECTURE.md
- STRUCTURE.md
- CONVENTIONS.md
- TESTING.md
- INTEGRATIONS.md
- CONCERNS.md
</objective>

<context>
Focus area: $ARGUMENTS (optional - if provided, agents focus on specific subsystem)

**Load templates:**
@.ace/templates/codebase/stack.md
@.ace/templates/codebase/architecture.md
@.ace/templates/codebase/structure.md
@.ace/templates/codebase/conventions.md
@.ace/templates/codebase/testing.md
@.ace/templates/codebase/integrations.md
@.ace/templates/codebase/concerns.md
</context>

<when_to_use>
**Use map-codebase for:**
- Brownfield projects before initialization
- Refreshing codebase map after significant changes
- Onboarding to unfamiliar codebase
- Before major refactoring

**Skip map-codebase for:**
- Greenfield projects with no code yet
- Trivial codebases (<5 files)
</when_to_use>

<process>

## 1. Check Prerequisites

```
if .ace/planning/codebase/ exists:
    Ask: "Codebase map exists. Refresh it?"
    Options: "Yes, refresh" / "Skip"
```

## 2. Create Directory

```bash
mkdir -p .ace/planning/codebase/
```

## 3. Spawn 4 Parallel Explore Agents

**CRITICAL:** Send ALL 4 Task calls in ONE message for maximum parallelism.

### Agent 1: Stack + Integrations (Technology Focus)
```
Analyze this codebase for technology stack and external integrations.

Produce findings for:
1. STACK.md - Languages, frameworks, key dependencies
2. INTEGRATIONS.md - APIs, databases, external services

Use templates from .ace/templates/codebase/
Focus area: $ARGUMENTS (if provided)
```

### Agent 2: Architecture + Structure (Organization Focus)
```
Analyze this codebase for architecture and structure.

Produce findings for:
1. ARCHITECTURE.md - System design, patterns, data flow
2. STRUCTURE.md - Directory layout, module organization

Use templates from .ace/templates/codebase/
Focus area: $ARGUMENTS (if provided)
```

### Agent 3: Conventions + Testing (Quality Focus)
```
Analyze this codebase for coding conventions and testing practices.

Produce findings for:
1. CONVENTIONS.md - Code style, naming, patterns
2. TESTING.md - Test structure, coverage, practices

Use templates from .ace/templates/codebase/
Focus area: $ARGUMENTS (if provided)
```

### Agent 4: Concerns (Issues Focus)
```
Analyze this codebase for technical concerns and risks.

Produce findings for:
1. CONCERNS.md - Technical debt, security issues, performance problems

Use templates from .ace/templates/codebase/
Focus area: $ARGUMENTS (if provided)
```

## 4. Collect Results

Wait for all 4 agents to complete.

## 5. Write Documents

Write each document to `.ace/planning/codebase/`:
- STACK.md
- ARCHITECTURE.md
- STRUCTURE.md
- CONVENTIONS.md
- TESTING.md
- INTEGRATIONS.md
- CONCERNS.md

## 6. Display Summary

```
+==============================================================+
|                    CODEBASE MAPPED                           |
+==============================================================+

Documents Created:
[*] STACK.md        - [N] technologies identified
[*] ARCHITECTURE.md - [Pattern] architecture detected
[*] STRUCTURE.md    - [N] key directories mapped
[*] CONVENTIONS.md  - [N] conventions documented
[*] TESTING.md      - [Coverage]% test coverage
[*] INTEGRATIONS.md - [N] external services
[*] CONCERNS.md     - [N] issues identified

Next: /ace:new-project (informed by this analysis)

+==============================================================+
```

</process>

<success_criteria>
- [ ] .ace/planning/codebase/ directory created
- [ ] All 7 codebase documents written
- [ ] Documents follow template structure
- [ ] Parallel agents completed without errors
- [ ] User knows next steps
</success_criteria>
