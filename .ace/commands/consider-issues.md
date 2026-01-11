---
name: ace:consider-issues
description: Review deferred issues for potential inclusion
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - AskUserQuestion
---

<objective>
Review deferred issues from ISSUES.md and decide which to address in upcoming plans. This command helps prioritize accumulated issues, identify quick wins, and integrate selected issues into the planning workflow.
</objective>

<context>
**Required:**
@.ace/planning/ISSUES.md
@.ace/planning/STATE.md
</context>

<issues_md_format>

## Understanding ISSUES.md

### Origin
ISSUES.md is created and updated during plan execution when agents encounter situations that deviate from the plan. This happens when:
- A task cannot be completed as specified
- An agent discovers a problem outside their current task scope
- Edge cases are found that weren't anticipated
- Technical debt is identified during implementation
- Enhancement opportunities are spotted but out of scope

Agents log issues using the `log-issue` command, which appends to ISSUES.md.

### File Structure

```markdown
# Deferred Issues

**Last Updated:** [timestamp]
**Total Issues:** [N]

---

## ISS-001: [Title]
- **Type:** Enhancement | Bug | Tech Debt | Missing Feature | Optimization
- **Priority:** Critical | High | Medium | Low
- **Effort:** Small (< 1 hour) | Medium (1-4 hours) | Large (> 4 hours)
- **Source:** [Phase X, Plan Y, Task Z] or [Agent: ALPHA/BETA/GAMMA]
- **Logged:** [timestamp]
- **Description:**
  [Detailed description of the issue]
- **Context:**
  [Where this was discovered, what was being worked on]
- **Suggested Approach:**
  [Optional: How the discovering agent suggests fixing it]
- **Affected Files:**
  - [file1.ts]
  - [file2.ts]

---

## ISS-002: [Title]
...
```

Each issue is separated by `---` and contains structured metadata for categorization.

</issues_md_format>

<process>

## 1. Load and Parse Issues

Read ISSUES.md and extract all issue entries. For each issue, capture:
- ID and title
- Type, priority, and effort estimates
- Source (which phase/plan/task created it)
- Age (how long it's been deferred)

Build an in-memory index of all issues for categorization.

## 2. Categorize Issues

Apply categorization logic to organize issues for decision-making:

**By Type:**
| Type | Description | Typical Action |
|------|-------------|----------------|
| Bug | Something is broken | Address soon, especially if user-facing |
| Tech Debt | Code quality issue | Batch with related work |
| Enhancement | Nice-to-have improvement | Consider for future phases |
| Missing Feature | Gap in functionality | Prioritize based on roadmap |
| Optimization | Performance improvement | Batch after functionality stable |

**By Priority Matrix:**
```
                    EFFORT
              Small    Medium    Large
         +----------+----------+----------+
  High   | DO NOW   | PLAN     | EVALUATE |
Priority |  (QW)    | NEXT     | CAREFULLY|
         +----------+----------+----------+
  Medium | BATCH    | SCHEDULE | DEFER    |
         | TOGETHER | LATER    |          |
         +----------+----------+----------+
  Low    | IF TIME  | BACKLOG  | PROBABLY |
         | PERMITS  |          | NEVER    |
         +----------+----------+----------+

QW = Quick Win (High priority + Small effort)
```

**By Age:**
- Fresh (< 1 phase old): Normal consideration
- Aging (1-2 phases old): Bump priority consideration
- Stale (> 2 phases old): Evaluate if still relevant

## 3. Display Categorized Summary

```
+==============================================================+
|                    DEFERRED ISSUES                           |
+==============================================================+

Issues by Category:
  Bugs: [N]  |  Tech Debt: [N]  |  Enhancements: [N]  |  Other: [N]

Quick Wins (High Priority + Small Effort):
+------+------------------+--------+--------------------------------+
| ID   | Type             | Age    | Description                    |
+------+------------------+--------+--------------------------------+
| ISS-003 | Bug           | Fresh  | Login validation missing       |
| ISS-007 | Tech Debt     | Aging  | Remove deprecated imports      |
+------+------------------+--------+--------------------------------+

All Issues:
+------+-------------+----------+--------+--------+-----------------+
| ID   | Type        | Priority | Effort | Age    | Description     |
+------+-------------+----------+--------+--------+-----------------+
| ISS-001 | Enhancement | Medium | Small  | Fresh  | Add tooltips    |
| ISS-002 | Tech Debt   | Low    | Medium | Stale  | Refactor utils  |
| ISS-003 | Bug         | High   | Small  | Fresh  | Login issue     |
| ISS-004 | Missing     | High   | Large  | Aging  | Export feature  |
+------+-------------+----------+--------+--------+-----------------+

Summary:
  Total: [N] issues
  High Priority: [N]
  Quick Wins: [N]
  Stale (may need review): [N]

+==============================================================+
```

## 4. Generate Recommendations

Based on current project state and issue analysis, provide recommendations:

**Recommendation Logic:**
1. **Always recommend:** Critical bugs and high-priority + small-effort items
2. **Suggest if capacity:** Medium priority bugs, aging issues
3. **Batch together:** Related tech debt items
4. **Defer explicitly:** Large effort + low priority items
5. **Flag for review:** Stale issues that may no longer be relevant

Display recommendations:
```
RECOMMENDATIONS:

[RECOMMENDED] Address in next plan:
  - ISS-003: Login validation (Bug, High, Small) - Quick win
  - ISS-007: Remove deprecated imports (Tech Debt, High, Small) - Quick win

[SUGGESTED] Consider if capacity allows:
  - ISS-001: Add tooltips (Enhancement, Medium, Small)

[BATCH] Group these together when tackling:
  - ISS-002, ISS-005: Both involve utils refactoring

[DEFER] Not recommended for immediate action:
  - ISS-004: Export feature (Large effort, plan as separate phase)

[REVIEW] May be stale or resolved:
  - ISS-002: Tech debt from Phase 1 (check if still relevant)
```

## 5. Collect User Selection

Use AskUserQuestion to get user decision:

```
Which issues would you like to address?

Options:
1. All quick wins (ISS-003, ISS-007)
2. All high priority ([list])
3. Specific issues (enter IDs: ISS-001, ISS-003, ...)
4. None for now (continue with current plan)
5. Let me review the full list first

Your choice:
```

Validate selection:
- Check that selected issues exist
- Warn if selecting large-effort items (may impact timeline)
- Confirm if selecting stale issues (may need re-evaluation)

## 6. Flow Selected Issues to Next Plan

Once issues are selected, prepare them for integration into the next plan:

**Update ISSUES.md:**
- Mark selected issues as "SCHEDULED" with target plan reference
- Keep unselected issues as "DEFERRED"

**Create SELECTED-ISSUES.md (temporary file):**
```markdown
# Selected Issues for Next Plan

**Selection Date:** [timestamp]
**Target:** Phase [N], Plan [M]
**Selected By:** User via consider-issues

## Issues to Address

### From ISSUES.md:
- ISS-003: Login validation missing → Convert to task
- ISS-007: Remove deprecated imports → Convert to task

## Integration Notes
- These issues will be added as tasks in the next plan-phase execution
- Zone assignments will be determined during plan-phase
- Original issue IDs preserved for traceability
```

**Update STATE.md:**
Add entry tracking the selection:
```markdown
## Pending Issue Integration
- Selected: ISS-003, ISS-007
- Target: Next plan-phase execution
- Status: Awaiting plan creation
```

Display confirmation:
```
+==============================================================+
|                    ISSUES SELECTED                           |
+==============================================================+

Selected [N] issues for integration:
  - ISS-003: Login validation missing (Bug)
  - ISS-007: Remove deprecated imports (Tech Debt)

These will be added as tasks when you run:
  /ace:plan-phase [N]

The plan-phase command will:
1. Load selected issues from SELECTED-ISSUES.md
2. Convert them to tasks alongside new phase work
3. Assign to appropriate zones
4. Clear the selection after plan creation

Remaining deferred issues: [M]

+==============================================================+

Next: /ace:plan-phase [N] (will include selected issues)
  Or: /ace:consider-issues (to modify selection)
```

</process>

<success_criteria>
- [ ] ISSUES.md loaded and parsed successfully
- [ ] All issues categorized by type, priority, effort, and age
- [ ] Summary displayed with clear categorization
- [ ] Recommendations generated based on analysis
- [ ] User selection captured and validated
- [ ] Selected issues marked for integration in ISSUES.md
- [ ] SELECTED-ISSUES.md created with selection details
- [ ] STATE.md updated with pending integration note
- [ ] Next steps clearly communicated
</success_criteria>
