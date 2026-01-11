# Summary Template

Template for `.ace/planning/phases/{phase}/{phase}-{plan}-SUMMARY.md`

---

## File Template

```markdown
# Summary: [Plan Name]

**Phase:** [X] - [Phase Name]
**Plan:** [Y] of [Z]
**Duration:** [X] minutes
**Status:** Complete

## Tasks Completed

### Task 1: [Task Name]
**Zone:** ALPHA
**Commit:** `abc1234`
**Files:**
- Created: `src/models/user.ts`
- Modified: `src/types/index.ts`

**What was done:**
[Brief description of implementation]

---

### Task 2: [Task Name]
**Zone:** BETA
**Commit:** `def5678`
**Files:**
- Created: `src/services/auth.ts`

**What was done:**
[Brief description]

---

### Task 3: [Task Name]
**Zone:** GAMMA
**Commit:** `ghi9012`
**Files:**
- Created: `src/routes/auth.ts`

**What was done:**
[Brief description]

---

## Deviations

[Any changes from the original plan]

- **Auto-fixed:** [Description of bug fixed]
- **Added:** [Description of critical addition]
- **Deferred:** [What was logged to ISSUES.md]

## Quality Gates

| Check | Status |
|-------|--------|
| TypeScript | PASS |
| Build | PASS |
| Lint | SKIP |
| Tests | SKIP |

## Commits

| Task | Type | Hash | Message |
|------|------|------|---------|
| 1 | feat | abc1234 | feat(01-02): create user model |
| 2 | feat | def5678 | feat(01-02): add auth service |
| 3 | feat | ghi9012 | feat(01-02): create auth routes |
| docs | docs | jkl3456 | docs(01-02): complete auth plan |

## Next Steps

- [ ] Run `/ace:verify-work` for UAT
- [ ] Continue with `/ace:plan-phase 2`
```

---

## Purpose

SUMMARY.md records what was actually done during execution.

**Contains:**
- Task completion records with commit hashes
- Files created/modified
- Deviations from plan
- Quality gate results

**Created:** By Team Leads during `/ace:execute-plan`

---

## Commit Traceability

Every task maps to a commit:
- Hash recorded for `git bisect` / `git blame`
- Enables independent revert per task
- Git history becomes project context
