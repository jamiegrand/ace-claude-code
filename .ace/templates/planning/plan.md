# Plan Template

Template for `.ace/planning/phases/{phase}/{phase}-{plan}-PLAN.md`

---

## File Template

```markdown
# Plan: [Plan Name]

**Phase:** [X] - [Phase Name]
**Plan:** [Y] of [Z] in phase
**Status:** [Ready / In Progress / Complete]

## Objective

[What this plan accomplishes - 1-2 sentences]

## Tasks

### Task 1: [Task Name]
**Zone:** [ALPHA / BETA / GAMMA]
**Files:**
- [file/path/1.ts]
- [file/path/2.ts]

**Action:**
[Detailed description of what to implement]

**Verify:**
- [ ] [Verification step 1]
- [ ] [Verification step 2]

**Done when:**
[Clear completion criteria]

---

### Task 2: [Task Name]
**Zone:** [ALPHA / BETA / GAMMA]
**Files:**
- [file/path/1.ts]

**Action:**
[Detailed description]

**Verify:**
- [ ] [Verification step]

**Done when:**
[Completion criteria]

---

### Task 3: [Task Name]
**Zone:** [ALPHA / BETA / GAMMA]
**Files:**
- [file/path/1.ts]

**Action:**
[Detailed description]

**Verify:**
- [ ] [Verification step]

**Done when:**
[Completion criteria]

---

## Checkpoints

[Optional - only if needed]

- [ ] **VERIFY** after Task 2: [What to verify with user]
- [ ] **DECISION** before Task 3: [Decision needed from user]

## Success Criteria

- [ ] All tasks completed
- [ ] All verifications pass
- [ ] Quality gates pass (TypeScript, build)
```

---

## Purpose

PLAN.md defines the atomic work to be executed.

**Rules:**
- Maximum 3 tasks per plan (context budget)
- Each task assigned to exactly one zone (ALPHA/BETA/GAMMA)
- Tasks should be independently committable
- Clear verification and completion criteria

---

## Task Structure

Each task must have:

| Field | Required | Purpose |
|-------|----------|---------|
| Zone | Yes | Assigns to Team Lead |
| Files | Yes | Scope of changes |
| Action | Yes | What to implement |
| Verify | Yes | How to validate |
| Done when | Yes | Completion criteria |

---

## Checkpoints

Two types:
- **VERIFY**: Pause for user to check work
- **DECISION**: Pause for user to make a choice

Use sparingly - most plans should be fully autonomous.

---

## Execution Strategy

Plans are executed by spawning Team Leads:

```
PLAN.md
   |
   +---> Task 1 (Zone: ALPHA) --> ALPHA Lead
   +---> Task 2 (Zone: BETA)  --> BETA Lead
   +---> Task 3 (Zone: GAMMA) --> GAMMA Lead
```

All Team Leads spawn in parallel for maximum efficiency.
