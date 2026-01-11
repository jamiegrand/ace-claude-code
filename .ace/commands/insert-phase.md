---
name: ace:insert-phase
description: Insert urgent phase at specific position
argument-hint: "[position number]"
allowed-tools:
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

<objective>
Insert a new phase at a specific position in the roadmap, shifting subsequent phases.

Use for urgent work that must happen before planned phases.
</objective>

<context>
Position: $ARGUMENTS (required - where to insert)

**Required:**
@.ace/planning/ROADMAP.md
@.ace/planning/STATE.md
</context>

<process>

## 1. Validate Position

```
if $ARGUMENTS is empty:
    Error: "Specify position: /ace:insert-phase 2"

if $ARGUMENTS > total_phases + 1:
    Error: "Position [N] invalid. Roadmap has [X] phases."
```

## 2. Gather Phase Info

Use AskUserQuestion:
- "What is the goal of this urgent phase?"
- "Why must it come before Phase [N]?"
- "How many plans do you estimate?"

## 3. Display Impact

```
+==============================================================+
|                    INSERT PHASE IMPACT                       |
+==============================================================+

Current Roadmap:
  Phase 1: [Name] -> stays Phase 1
  Phase 2: [Name] -> becomes Phase 3
  Phase 3: [Name] -> becomes Phase 4

NEW Phase 2: [New Name]

+==============================================================+
```

## 4. Get Confirmation

Use AskUserQuestion:
- "This will renumber all subsequent phases. Continue?"
- Options: "Yes, insert phase" / "Cancel"

## 5. Update ROADMAP.md

1. Parse existing phases
2. Renumber phases at and after position
3. Insert new phase at position
4. Update all plan IDs (02-01 becomes 03-01, etc.)

## 6. Update STATE.md

If current phase >= insert position:
- Increment current phase number
- Update progress calculations

## 7. Update Existing Plans

Rename plan files in phases/ directory:
```bash
# Example: inserting at position 2
mv phases/02-core/ phases/03-core/
mv phases/03-integration/ phases/04-integration/
```

Update plan IDs in each PLAN.md and SUMMARY.md file.

## 8. Git Commit

```bash
git add .ace/planning/
git commit -m "docs: insert phase [N] - [phase-name]

Renumbered phases [N]+ to accommodate urgent work.
"
```

## 9. Confirmation

```
+==============================================================+
|                    PHASE INSERTED                            |
+==============================================================+

Phase [N]: [Name] inserted successfully.

Updated:
- ROADMAP.md (phases renumbered)
- STATE.md (position adjusted)
- [X] plan files renamed

Total Phases: [N+1]

+==============================================================+
```

</process>

<success_criteria>
- [ ] New phase inserted at correct position
- [ ] Subsequent phases renumbered
- [ ] Plan files renamed correctly
- [ ] STATE.md updated
- [ ] Git commit created
</success_criteria>
