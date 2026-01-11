---
name: ace:config
description: View or modify Ace configuration settings
argument-hint: "[setting.path value] or empty to view all"
allowed-tools:
  - Read
  - Write
  - Glob
  - AskUserQuestion
---

<objective>
View and modify Ace configuration settings.

Without arguments: display current configuration.
With arguments: modify specific settings with validation.
</objective>

<context>
Configuration file: @.ace/config.json

**Modifiable settings:**
- workflow.mode (interactive | yolo)
- qualityGates.typescript.enabled (true | false)
- qualityGates.lint.enabled (true | false)
- qualityGates.build.enabled (true | false)
- qualityGates.test.enabled (true | false)
- qualityGates.*.command (string)
- git.enabled (true | false)
- git.autoInit (true | false)
- git.perTaskCommits (true | false)
- projectType.current (frontend | backend | fullstack | automation | agentic | library | monorepo | custom)
- orchestration.maxTeamLeads (1-5)
- orchestration.maxTasksPerPlan (1-10)
</context>

<process>

## 1. Parse Arguments

```
if $ARGUMENTS is empty:
    MODE = "view"
else:
    Parse: setting.path value
    Example: "workflow.mode yolo"
    MODE = "modify"
```

## 2. View Mode (No Arguments)

```
Read config.json and display:

+==============================================================+
|                    ACE CONFIGURATION                    |
+==============================================================+

Orchestration:
  Mode:           [parallel]
  Max Team Leads: [3]
  Max Tasks/Plan: [3]

Workflow:
  Mode: [interactive]  (interactive | yolo)

Quality Gates:
  TypeScript: [enabled]  - npx tsc --noEmit
  Lint:       [disabled] - npm run lint
  Build:      [enabled]  - npm run build
  Test:       [disabled] - npm run test

Git:
  Enabled:          [true]
  Auto Init:        [true]
  Per-Task Commits: [true]

Project Type:
  Current: [agentic]

+==============================================================+

Modify: /ace:config <setting.path> <value>
Example: /ace:config workflow.mode yolo

+==============================================================+
```

## 3. Modify Mode (With Arguments)

### 3.1 Validate Setting Path

```
validPaths = [
    "workflow.mode",
    "qualityGates.typescript.enabled",
    "qualityGates.lint.enabled",
    "qualityGates.build.enabled",
    "qualityGates.test.enabled",
    "qualityGates.typescript.command",
    "qualityGates.lint.command",
    "qualityGates.build.command",
    "qualityGates.test.command",
    "git.enabled",
    "git.autoInit",
    "git.perTaskCommits",
    "projectType.current",
    "orchestration.maxTeamLeads",
    "orchestration.maxTasksPerPlan"
]

if setting.path not in validPaths:
    Display error: "Invalid setting path: [path]"
    List valid paths
    EXIT
```

### 3.2 Validate Value

```
Validation rules:
- workflow.mode: must be "interactive" or "yolo"
- *.enabled: must be "true" or "false"
- *.command: any non-empty string
- projectType.current: must be in supported list
- orchestration.maxTeamLeads: integer 1-5
- orchestration.maxTasksPerPlan: integer 1-10

if validation fails:
    Display error with allowed values
    EXIT
```

### 3.3 Apply Change

```
Read current config.json
Extract current value at path
Apply new value

Display before/after comparison:

+==============================================================+
|                    CONFIGURATION UPDATED                     |
+==============================================================+

Setting: [workflow.mode]

Before: interactive
After:  yolo

+==============================================================+

Write updated config.json
```

## 4. Special Handling

### Quality Gates Toggle

```
if changing qualityGates.*.enabled to true:
    Check if command exists
    if command is empty:
        Ask for command or use default
```

### Workflow Mode Change

```
if changing to "yolo" mode:
    Display warning:
    "YOLO mode enables autonomous execution with minimal interruption.
     Ace will make decisions without asking. Continue? (y/n)"
```

</process>

<success_criteria>
- [ ] View mode shows all relevant settings clearly
- [ ] Modify mode validates setting path
- [ ] Modify mode validates value
- [ ] Before/after comparison shown for changes
- [ ] Config file updated correctly
- [ ] Invalid inputs produce helpful error messages
</success_criteria>
