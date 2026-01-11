# Project Template

Template for `.ace/planning/PROJECT.md` - the project specification.

---

## File Template

```markdown
# [Project Name]

## Core Value

[One sentence describing the primary value this project delivers]

## Overview

[2-3 paragraphs describing what this project is and why it exists]

## Requirements

### Must Have
- [ ] [Requirement 1]
- [ ] [Requirement 2]
- [ ] [Requirement 3]

### Should Have
- [ ] [Requirement 1]
- [ ] [Requirement 2]

### Nice to Have
- [ ] [Requirement 1]

## Technical Stack

- **Framework:** [e.g., Next.js 14]
- **Language:** [e.g., TypeScript]
- **Database:** [e.g., PostgreSQL with Prisma]
- **Styling:** [e.g., Tailwind CSS]
- **Other:** [e.g., Auth0, Stripe]

## Architecture

[Brief description of the system architecture]

```
[ASCII diagram if helpful]
```

## Key Decisions

| Date | Decision | Rationale | Phase |
|------|----------|-----------|-------|
| YYYY-MM-DD | [What was decided] | [Why] | [Phase] |

## Constraints

- [Constraint 1 - e.g., Must work offline]
- [Constraint 2 - e.g., Must support mobile]
- [Constraint 3 - e.g., Budget limit]

## Success Criteria

- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]

## Out of Scope

- [What this project will NOT do]
- [Features explicitly deferred]

## References

- [Link to design mockups]
- [Link to API documentation]
- [Link to similar projects]
```

---

## Purpose

PROJECT.md is the single source of truth for what we're building and why.

**Contains:**
- Project vision and core value
- Requirements (prioritized)
- Technical decisions and rationale
- Constraints and success criteria

**Does NOT contain:**
- Current status (that's STATE.md)
- Execution details (that's PLAN.md)
- Historical summaries (that's SUMMARY.md)

---

## Lifecycle

**Creation:** During `/ace:new-project`
- Extract requirements through questioning
- Document technical stack
- Set initial constraints

**Updates:**
- Key Decisions table updated after significant choices
- Requirements updated if scope changes
- Architecture updated after major structural decisions

**Reading:**
- Referenced by STATE.md
- Read during planning to inform task breakdown
- Consulted when making technical decisions
