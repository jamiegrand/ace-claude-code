# Issues Template

Template for `.ace/planning/ISSUES.md` - deferred enhancements tracker.

---

## File Template

```markdown
# Issues & Enhancements

## Open Issues

### ISS-001: [Issue Title]
**Phase:** [X] - [Phase Name]
**Type:** [Enhancement / Bug / Tech Debt]
**Effort:** [Small / Medium / Large]
**Priority:** [Low / Medium / High]

[Description of the issue or enhancement]

**Context:** [Why this was deferred]

---

### ISS-002: [Issue Title]
**Phase:** [X] - [Phase Name]
**Type:** [Enhancement / Bug / Tech Debt]
**Effort:** [Small / Medium / Large]
**Priority:** [Low / Medium / High]

[Description]

**Context:** [Why deferred]

---

## Resolved Issues

### ISS-003: [Issue Title] - RESOLVED
**Resolved in:** Phase [X], Plan [Y]
**Resolution:** [How it was resolved]

---

## Summary

| Status | Count |
|--------|-------|
| Open | [N] |
| Resolved | [N] |
| Total | [N] |

| Type | Open | Resolved |
|------|------|----------|
| Enhancement | [N] | [N] |
| Bug | [N] | [N] |
| Tech Debt | [N] | [N] |
```

---

## Purpose

ISSUES.md captures work discovered during execution that should be deferred.

**Use for:**
- Nice-to-have enhancements
- Minor bugs not blocking progress
- Technical debt identified
- Ideas for future improvement

**Do NOT use for:**
- Critical bugs (fix immediately)
- Blockers (must resolve to continue)
- Architectural decisions (ask user)

---

## Lifecycle

**Creation:** After first deferred item during execution

**Updates:**
- New issues added during execution (deviation rule #5)
- Issues resolved during subsequent phases
- Reviewed via `/ace:consider-issues`

**Reference:**
- STATE.md summarizes open count
- Used during phase planning to decide what to address
