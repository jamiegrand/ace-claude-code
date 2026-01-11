---
name: ace:new-project
description: Initialize a new project with PROJECT.md
argument-hint: "[optional: project name]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
---

<objective>
Create PROJECT.md by extracting requirements through structured questioning.

This establishes the project specification that guides all subsequent work.
</objective>

<context>
Project name: $ARGUMENTS (optional)

**Check for existing project:**
- If .ace/planning/PROJECT.md exists, offer to update or skip
- If .ace/planning/codebase/ exists, use it to inform questioning

**Load templates:**
@.ace/templates/planning/project.md
</context>

<process>

## 0. Pre-Flight: Git Initialization

```
Read config.json for git.enabled and git.autoInit

if git.enabled AND git.autoInit:
    Check if .git directory exists
    if not exists:
        Run: git init
        Run: git add .ace/ CLAUDE.md .gitignore
        Run: git commit -m "chore: initialize ace orchestration system"
        Display: "Git repository initialized"
```

This ensures all projects have version control from the start.

## 1. Check Existing State

```
if .ace/planning/PROJECT.md exists:
    Ask: "PROJECT.md already exists. Update it or skip?"
    Options: "Update existing" / "Skip to /ace:create-roadmap"
```

## 2. Gather Project Information

Use AskUserQuestion to extract:

### Core Value
"What is the ONE primary value this project delivers?"
- Keep to one sentence
- Focus on user benefit

### Overview
"Describe what you're building and why (2-3 sentences)"

### Requirements
"What are the must-have features? (List 3-5)"

For each must-have, ask:
"Any should-have or nice-to-have features?"

### Technical Stack
If codebase/ exists, pre-fill from STACK.md
Otherwise ask:
"What's your preferred tech stack?"
- Framework (Next.js, React, Express, etc.)
- Language (TypeScript, JavaScript)
- Database (PostgreSQL, MongoDB, SQLite)
- Styling (Tailwind, CSS Modules, etc.)

### Constraints
"Any constraints I should know about?"
- Time constraints
- Technical limitations
- Compatibility requirements

### Success Criteria
"How will you know this project is successful?"

## 3. Create PROJECT.md

Write to `.ace/planning/PROJECT.md` using template.

## 4. Initialize Planning Directory

Create if not exists:
- `.ace/planning/`
- `.ace/planning/phases/`

## 5. Next Steps

Display:
```
PROJECT.md created!

Next: /ace:create-roadmap to plan your phases
```

</process>

<success_criteria>
- [ ] Git initialized (if autoInit enabled and not already a repo)
- [ ] .ace/planning/ directory exists
- [ ] PROJECT.md created with all sections
- [ ] User informed of next steps (/ace:create-roadmap)
</success_criteria>
