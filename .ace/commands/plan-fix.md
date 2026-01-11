---
name: ace:plan-fix
description: Plan fixes for UAT issues
argument-hint: "[optional: plan_id]"
allowed-tools:
  - Read
  - Write
  - AskUserQuestion
---

<objective>
Create a fix plan to address issues found during verification. This command converts UAT failures and identified issues into actionable fix tasks, assigns them to the appropriate zones based on code ownership, and prepares a structured plan for execution.
</objective>

<context>
**Required:**
@.ace/planning/UAT-ISSUES.md (or ISSUES.md)

**Load:**
Related PLAN.md and SUMMARY.md
</context>

<process>

## 1. Load and Parse Issues

Read UAT-ISSUES.md or the specified issues file. Each issue entry follows this structure:

```
### ISS-XXX: [Title]
- **Type:** Bug | Regression | Missing Feature | Integration Failure
- **Severity:** Critical | High | Medium | Low
- **Source:** UAT test name or verification step
- **Affected Files:** List of files involved
- **Description:** What went wrong
- **Expected:** What should have happened
- **Actual:** What actually happened
```

Parse each issue and extract the key metadata for analysis.

## 2. Analyze Issues and Determine Zone Ownership

For each issue, determine which zone should own the fix:

**Zone Assignment Rules:**
| Issue Characteristics | Assigned Zone |
|----------------------|---------------|
| Core logic, algorithms, main entry points | ALPHA |
| UI components, user interactions, display | BETA |
| Data layer, API calls, external integrations | GAMMA |
| Cross-cutting (affects multiple zones) | ALPHA (coordinates) |
| Build/config issues | Orchestrator handles directly |

**Analysis checklist per issue:**
- Identify the root cause file(s)
- Check which zone originally created the affected code
- Estimate fix complexity (Simple: < 30 min, Medium: 30-90 min, Complex: > 90 min)
- Identify dependencies (does this fix require other fixes first?)
- Check for regression risk (will fixing this break other things?)

## 3. Convert Issues to Fix Tasks

Transform each issue into a structured task. The issue-to-task mapping follows this pattern:

**Issue-to-Task Mapping Examples:**

| Issue | Resulting Task |
|-------|----------------|
| `ISS-001: Login button not responding` | `BETA-FIX-001: Restore click handler on login button component` |
| `ISS-002: API returns 500 on /users endpoint` | `GAMMA-FIX-001: Fix error handling in users API controller` |
| `ISS-003: Calculation produces NaN for negative inputs` | `ALPHA-FIX-001: Add input validation to calculation engine` |
| `ISS-004: Modal doesn't close on ESC key` | `BETA-FIX-002: Add keyboard event listener to modal component` |
| `ISS-005: Cache not invalidating on update` | `GAMMA-FIX-002: Implement cache invalidation in data service` |

**Task format:**
```
### [ZONE]-FIX-[N]: [Action verb] + [specific fix description]
- **Source Issue:** ISS-XXX
- **Affected Files:** [List from issue]
- **Fix Approach:** [Brief technical approach]
- **Complexity:** Simple | Medium | Complex
- **Dependencies:** [Other fixes that must complete first, or "None"]
```

## 4. Create Fix Plan Document

Generate FIX-PLAN.md with structured content:

```markdown
# Fix Plan: Phase [N] - Plan [M] Issues

**Generated:** [timestamp]
**Source:** UAT-ISSUES.md
**Total Issues:** [N]
**Estimated Duration:** [X hours]

## Issue Summary

| Issue ID | Title | Zone | Complexity |
|----------|-------|------|------------|
| ISS-001 | ... | ALPHA | Medium |
| ISS-002 | ... | BETA | Simple |

## Zone Assignments

### ALPHA Tasks
- ALPHA-FIX-001: [Description]

### BETA Tasks
- BETA-FIX-001: [Description]

### GAMMA Tasks
- (No fixes assigned)

## Execution Order
1. [Task with no dependencies]
2. [Task dependent on #1]
3. [Parallel tasks...]

## Rollback Plan
If fixes introduce new issues:
1. Revert to commit [hash before fixes]
2. Re-run verification
3. Reassess approach
```

**Constraints:**
- Maximum 3 fixes per plan (create multiple fix plans for more issues)
- Critical/High severity issues get priority
- Group related fixes together when possible

## 5. Display Fix Plan

```
+==============================================================+
|                    FIX PLAN                                  |
+==============================================================+

Source: UAT-ISSUES.md
Issues to Address: [N] (of [total] total)
Estimated Duration: [X hours]

+------------------+------------------+------------------+
|      ALPHA       |       BETA       |      GAMMA       |
+------------------+------------------+------------------+
| FIX-001: [brief] | FIX-001: [brief] | (no fixes)       |
| Complexity: Med  | Complexity: Low  |                  |
| From: ISS-003    | From: ISS-001    |                  |
+------------------+------------------+------------------+

Execution Order:
1. BETA-FIX-001 (no dependencies)
2. ALPHA-FIX-001 (depends on BETA-FIX-001)

Commit type: fix(p{phase}-{plan}): [description]

+==============================================================+
```

## 6. Confirm and Commit Fix Plan

After user approval, commit the fix plan to version control:

```bash
git add .ace/planning/FIX-PLAN-{phase}-{plan}.md
git commit -m "plan(p{phase}): Create fix plan for {N} UAT issues

Issues addressed:
- ISS-XXX: [brief description]
- ISS-YYY: [brief description]

Zones assigned: ALPHA({n}), BETA({n}), GAMMA({n})"
```

Display confirmation:
```
Fix plan committed and ready.

Summary:
- Plan file: .ace/planning/FIX-PLAN-{phase}-{plan}.md
- Issues covered: [N]
- Remaining issues: [M] (will need additional fix plan)

Next: /ace:execute-plan FIX-PLAN-{phase}-{plan}
```

</process>

<success_criteria>
- [ ] All issues loaded and parsed correctly
- [ ] Each issue analyzed for zone ownership
- [ ] Issues converted to actionable fix tasks
- [ ] Fix plan document created with proper structure
- [ ] Zone assignments verified (no orphaned issues)
- [ ] Execution order determined (dependencies respected)
- [ ] Fix plan committed to git
- [ ] User informed of next steps
</success_criteria>
