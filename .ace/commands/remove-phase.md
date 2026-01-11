---
name: ace:remove-phase
description: Remove phase from roadmap
argument-hint: "[phase number]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - AskUserQuestion
---

<objective>
Remove a phase from the roadmap and optionally archive its work.

Use for phases that are no longer needed or should be deferred indefinitely.
</objective>

<context>
Phase number: $ARGUMENTS (required)

**Required:**
@.ace/planning/ROADMAP.md
@.ace/planning/STATE.md
</context>

<process>

## 1. Validate Phase

```
if $ARGUMENTS is empty:
    Error: "Specify phase: /ace:remove-phase 3"

if phase $ARGUMENTS not in ROADMAP.md:
    Error: "Phase $ARGUMENTS not found"

if phase $ARGUMENTS is current or completed:
    Warning: "Phase [N] has work. Are you sure?"
```

## 2. Check for Existing Work

```
if phases/{phase}/ directory exists:
    List all PLAN.md and SUMMARY.md files
    Show: "[X] plans exist for this phase"
```

## 3. Display Impact

```
+==============================================================+
|                    REMOVE PHASE IMPACT                       |
+==============================================================+

Removing: Phase [N] - [Name]

Existing work:
- [X] plans created
- [Y] plans executed
- [Z] commits made

Subsequent phases will be renumbered:
  Phase [N+1] -> Phase [N]
  Phase [N+2] -> Phase [N+1]

+==============================================================+
```

## 4. Get Confirmation

Use AskUserQuestion:
- "How should we handle this phase?"
- Options:
  - "Archive and remove" (move to .ace/archived/)
  - "Delete permanently" (no recovery)
  - "Cancel"

## 5. Archive or Delete

### If Archive:
```bash
mkdir -p .ace/archived/
mv .ace/planning/phases/{phase}/ .ace/archived/phase-{N}-{name}/
```

### If Delete:
```bash
rm -rf .ace/planning/phases/{phase}/
```

## 6. Update ROADMAP.md

1. Remove the phase entry
2. Renumber subsequent phases
3. Update plan IDs in remaining phases

## 7. Update STATE.md

If current phase > removed phase:
- Decrement current phase number
- Update progress calculations

If current phase == removed phase:
- Set to previous phase or "Phase 1 ready to plan"

## 8. Update Remaining Plans

Rename plan files and update IDs:
```bash
# Example: removing phase 2
mv phases/03-integration/ phases/02-integration/
```

## 9. Git Commit

```bash
git add .ace/
git commit -m "docs: remove phase [N] - [phase-name]

[Archived to .ace/archived/ | Deleted permanently]
Renumbered phases [N+1]+ accordingly.
"
```

## 10. Confirmation

```
+==============================================================+
|                    PHASE REMOVED                             |
+==============================================================+

Phase [N]: [Name] has been [archived/deleted].

Updated:
- ROADMAP.md (phase removed, others renumbered)
- STATE.md (position adjusted)
- [X] plan files renamed

Total Phases: [N-1]

+==============================================================+
```

</process>

<safety_rules>
**Cannot remove:**
- The only remaining phase
- A phase with uncommitted work (must commit or stash first)

**Warnings required:**
- Removing completed phases (work will be orphaned in git)
- Removing current phase (state will jump)
</safety_rules>

<success_criteria>
- [ ] Phase removed from ROADMAP.md
- [ ] Work archived or deleted as chosen
- [ ] Subsequent phases renumbered
- [ ] STATE.md updated
- [ ] Git commit created
</success_criteria>
