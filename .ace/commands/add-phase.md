---
name: ace:add-phase
description: Append new phase to roadmap
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

<objective>
Add a new phase to the end of the roadmap.
</objective>

<context>
**Required:**
@.ace/planning/ROADMAP.md
@.ace/planning/STATE.md
</context>

<process>

## 1. Load Current Roadmap

Read ROADMAP.md to understand:
- Current phases
- Total count
- Dependencies

## 2. Gather Phase Info

Use AskUserQuestion:
- "What is the goal of this new phase?"
- "How many plans do you estimate?"
- "Any dependencies on other phases?"

## 3. Create Phase Entry

Add to ROADMAP.md:
```markdown
### Phase [N+1]: [Phase Name]
**Goal:** [Description]
**Status:** Not Started

Plans:
- [ ] [phase]-01: [Plan name]
- [ ] [phase]-02: [Plan name]

Dependencies: Phase [N]
```

## 4. Update STATE.md

Update total phase count.

## 5. Git Commit

Commit the roadmap changes:

```bash
git add .ace/planning/ROADMAP.md
git add .ace/planning/STATE.md
git commit -m "docs: add phase [N] - [phase-name]"
```

## 6. Confirm

```
+==============================================================+
|                    PHASE ADDED                               |
+==============================================================+

Phase [N+1]: [Name] added to roadmap.

Total Phases: [N+1]

+==============================================================+
```

</process>

<success_criteria>
- [ ] New phase added to ROADMAP.md
- [ ] STATE.md updated
- [ ] Changes committed to git
- [ ] User confirmed
</success_criteria>
