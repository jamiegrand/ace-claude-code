# State Template

Template for `.ace/planning/STATE.md` - the project's living memory.

---

## File Template

```markdown
# Project State

## Project Reference

See: .ace/planning/PROJECT.md (updated [date])

**Core value:** [One-liner from PROJECT.md Core Value section]
**Current focus:** [Current phase name]

## Current Position

Phase: [X] of [Y] ([Phase name])
Plan: [A] of [B] in current phase
Status: [Ready to plan / Planning / Ready to execute / In progress / Phase complete]
Last activity: [YYYY-MM-DD] -- [What happened]

Progress: [##########..........] 50%

## Performance Metrics

**Velocity:**
- Total plans completed: [N]
- Average duration: [X] min
- Total execution time: [X.X] hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| - | - | - | - |

**Recent Trend:**
- Last 5 plans: [durations]
- Trend: [Improving / Stable / Degrading]

*Updated after each plan completion*

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- [Phase X]: [Decision summary]
- [Phase Y]: [Decision summary]

### Deferred Issues

[From ISSUES.md - list open items with phase of origin]

None yet.

### Blockers/Concerns

[Issues that affect future work]

None yet.

## Session Continuity

Last session: [YYYY-MM-DD HH:MM]
Stopped at: [Description of last completed action]
Resume file: [Path to .continue-here*.md if exists, otherwise "None"]
```

---

## Purpose

STATE.md is the project's short-term memory spanning all phases and sessions.

**Problem it solves:** Information is captured in summaries, issues, and decisions but not systematically consumed. Sessions start without context.

**Solution:** A single, small file that's:
- Read first in every workflow
- Updated after every significant action
- Contains digest of accumulated context
- Enables instant session restoration

---

## Lifecycle

**Creation:** After ROADMAP.md is created (during init)
- Reference PROJECT.md (read it for current context)
- Initialize empty accumulated context sections
- Set position to "Phase 1 ready to plan"

**Reading:** First step of every workflow
- progress: Present status to user
- plan: Inform planning decisions
- execute: Know current position
- transition: Know what's complete

**Writing:** After every significant action
- execute: After SUMMARY.md created
  - Update position (phase, plan, status)
  - Note new decisions (detail in PROJECT.md)
  - Update deferred issues list
  - Add blockers/concerns
- transition: After phase marked complete
  - Update progress bar
  - Clear resolved blockers
  - Refresh Project Reference date

---

## Size Constraint

Keep STATE.md under 100 lines.

It's a DIGEST, not an archive. If accumulated context grows too large:
- Keep only 3-5 recent decisions in summary (full log in PROJECT.md)
- Reference ISSUES.md instead of listing all: "12 open issues - see ISSUES.md"
- Keep only active blockers, remove resolved ones

The goal is "read once, know where we are" - if it's too long, that fails.

---

## Ace Integration

STATE.md sync points during Ace execution:

| Event | Update |
|-------|--------|
| Plan starts | `current_position.plan = "{phase}-{plan}"` |
| Task completes | `metrics.tasks_completed++` |
| Team Lead commits | Record commit hash |
| Quality gate fails | Add to blockers |
| Plan completes | Update progress bar |
| Pause triggered | Set resume file path |
