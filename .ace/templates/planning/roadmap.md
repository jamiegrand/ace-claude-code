# Roadmap Template

Template for `.ace/planning/ROADMAP.md` - the phase sequencing document.

---

## File Template

```markdown
# [Project Name] Roadmap

## Overview

Total Phases: [N]
Current Phase: [X] of [N]
Status: [In Progress / Complete]

## Phases

### Phase 1: [Foundation]
**Goal:** [What this phase accomplishes]
**Status:** [Not Started / In Progress / Complete]

Plans:
- [ ] 01-01: [Plan name]
- [ ] 01-02: [Plan name]

Dependencies: None

---

### Phase 2: [Core Features]
**Goal:** [What this phase accomplishes]
**Status:** [Not Started / In Progress / Complete]

Plans:
- [ ] 02-01: [Plan name]
- [ ] 02-02: [Plan name]

Dependencies: Phase 1

---

### Phase 3: [Integration]
**Goal:** [What this phase accomplishes]
**Status:** [Not Started / In Progress / Complete]

Plans:
- [ ] 03-01: [Plan name]
- [ ] 03-02: [Plan name]

Dependencies: Phase 2

---

## Phase Summaries

| Phase | Name | Plans | Status | Duration |
|-------|------|-------|--------|----------|
| 1 | [Foundation] | [X]/[Y] | [Status] | [Time] |
| 2 | [Core Features] | [X]/[Y] | [Status] | [Time] |
| 3 | [Integration] | [X]/[Y] | [Status] | [Time] |

## Notes

[Any additional context about the roadmap structure]
```

---

## Purpose

ROADMAP.md sequences the phases and tracks high-level progress.

**Contains:**
- Phase definitions with goals
- Plan listings per phase
- Dependencies between phases
- Completion status

**Does NOT contain:**
- Detailed task breakdowns (that's PLAN.md)
- Current execution state (that's STATE.md)

---

## Lifecycle

**Creation:** During `/ace:create-roadmap`
- Define phases based on PROJECT.md requirements
- Sequence phases with dependencies
- Estimate plans per phase

**Updates:**
- Plan checkboxes updated as plans complete
- Phase status updated as phases complete
- New phases added via `/ace:add-phase` or `/ace:insert-phase`

**Reading:**
- Consulted during `/ace:plan-phase` to understand context
- Referenced by STATE.md for position tracking
