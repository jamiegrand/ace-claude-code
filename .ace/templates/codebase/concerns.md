# Concerns Analysis Template

Template for `.ace/planning/codebase/CONCERNS.md`

---

## File Template

```markdown
# Technical Concerns

## Technical Debt

### High Priority

#### TD-001: [Issue Title]
**Location:** [file/path.ts]
**Impact:** [High / Medium / Low]
**Effort:** [Small / Medium / Large]

[Description of the technical debt]

**Recommendation:** [How to address it]

---

#### TD-002: [Issue Title]
**Location:** [file/path.ts]
**Impact:** [High]
**Effort:** [Medium]

[Description]

**Recommendation:** [How to address]

---

### Medium Priority

#### TD-003: [Issue Title]
**Location:** [various]
**Impact:** [Medium]
**Effort:** [Small]

[Description]

---

### Low Priority

#### TD-004: [Issue Title]
**Location:** [file/path.ts]
**Impact:** [Low]
**Effort:** [Small]

[Description]

---

## Security Concerns

### SEC-001: [Issue Title]
**Severity:** [Critical / High / Medium / Low]
**Location:** [file/path.ts]

[Description of security concern]

**Recommendation:** [How to address]

---

## Performance Issues

### PERF-001: [Issue Title]
**Location:** [file/path.ts]
**Impact:** [User-facing / Backend / Build time]

[Description of performance issue]

**Recommendation:** [How to address]

---

## Architectural Risks

### ARCH-001: [Issue Title]
**Impact:** [Scalability / Maintainability / Flexibility]

[Description of architectural concern]

**Recommendation:** [How to address]

---

## Missing Features

### MISS-001: [Feature]
**Priority:** [High / Medium / Low]

[Description of what's missing and why it matters]

---

## Summary

| Category | Count | High Priority |
|----------|-------|---------------|
| Technical Debt | [N] | [N] |
| Security | [N] | [N] |
| Performance | [N] | [N] |
| Architecture | [N] | [N] |
| Missing | [N] | [N] |

## Notes

[Overall assessment of codebase health]
```

---

## Purpose

CONCERNS.md documents risks, debt, and issues discovered during analysis.

**Created by:** Agent 4 during `/ace:map-codebase`

**Use for:**
- Informing project planning
- Prioritizing technical improvements
- Understanding risk areas before making changes
