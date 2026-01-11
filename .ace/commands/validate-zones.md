---
name: ace:validate-zones
description: Check for zone conflicts in project-types.json
argument-hint: "[optional: project-type]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
---

<objective>
Validate zone configuration in project-types.json to prevent conflicts.

Ensures no overlapping ownership patterns between zones, no conflicts between
owns and forbidden lists, and that all source files are covered by some zone.
</objective>

<context>
Project type: $ARGUMENTS (optional - uses current project type from config.json)

**Required:**
@.ace/project-types.json
@.ace/config.json (for current project type)

**Scan:**
Project source files to check coverage
</context>

<process>

## 1. Load Zone Configuration

```
+==============================================================+
|                    ZONE VALIDATION                           |
+==============================================================+

Loading zone configuration...
```

Load project-types.json and determine target project type:

```
if $ARGUMENTS provided:
    project_type = $ARGUMENTS
else:
    Read config.json for project.type

if project_type not found in project-types.json:
    Error: "Unknown project type: [type]"
    Show available types
```

Display loaded configuration:

```
PROJECT TYPE: [type]
Name: [project name]

ZONES:
+--------+-------------------+--------------------------------+
| Zone   | Name              | Responsibility                 |
+--------+-------------------+--------------------------------+
| ALPHA  | [zone name]       | [responsibility]               |
| BETA   | [zone name]       | [responsibility]               |
| GAMMA  | [zone name]       | [responsibility]               |
+--------+-------------------+--------------------------------+

+==============================================================+
```

## 2. Check Ownership Overlaps

Compare "owns" patterns across all zones:

```
OWNERSHIP OVERLAP CHECK:

Comparing zone ownership patterns...

ALPHA owns:
  - src/models/**
  - src/schemas/**
  - src/types/**

BETA owns:
  - src/services/**
  - src/utils/**
  - src/middleware/**

GAMMA owns:
  - src/routes/**
  - src/controllers/**
  - src/app.ts

Checking for overlaps...
```

If overlaps found:

```
OVERLAP DETECTED!

Pattern: src/types/**
  Owned by: ALPHA
  Also matched by: BETA (src/types/** in owns)

Pattern: src/utils/types.ts
  Could match: ALPHA (src/types/**)
  Could match: BETA (src/utils/**)

+----------------------------------------------------------+
| CONFLICT: Same pattern owned by multiple zones           |
+----------------------------------------------------------+

Affected patterns:
1. src/types/** - ALPHA and BETA
2. src/utils/types.ts - ambiguous match

FIX SUGGESTIONS:

1. For src/types/**:
   - Remove from BETA owns list, OR
   - Add to BETA forbidden list, OR
   - Rename to avoid ambiguity (e.g., src/beta-types/**)

2. For src/utils/types.ts:
   - Add explicit pattern to one zone: src/utils/types.ts
   - Add to other zone's forbidden list

+==============================================================+
```

## 3. Check Owns vs Forbidden Conflicts

Verify no zone has patterns that appear in both owns and forbidden:

```
OWNS vs FORBIDDEN CHECK:

ALPHA:
  owns: src/models/**, src/schemas/**, src/types/**
  forbidden: src/routes/**, src/controllers/**
  [OK] No self-conflict

BETA:
  owns: src/services/**, src/utils/**
  forbidden: src/models/**, src/routes/**
  [OK] No self-conflict

GAMMA:
  owns: src/routes/**, src/controllers/**
  forbidden: src/models/**, src/services/**
  [OK] No self-conflict

+==============================================================+
```

If conflict found:

```
SELF-CONFLICT DETECTED!

Zone: BETA
  Pattern src/utils/helpers/** appears in BOTH:
    - owns: src/utils/**
    - forbidden: src/utils/helpers/**

This is contradictory - a zone cannot own and forbid the same files.

FIX: Remove src/utils/helpers/** from forbidden list
     OR change owns to exclude: src/utils/!(helpers)/**

+==============================================================+
```

## 4. Verify Cross-Zone Forbidden Rules

Check that each zone's "owns" patterns are in other zones' "forbidden":

```
CROSS-ZONE FORBIDDEN CHECK:

For proper isolation, each zone's owned files should be
forbidden to other zones.

ALPHA owns src/models/**
  BETA forbidden: [*] Contains src/models/**
  GAMMA forbidden: [*] Contains src/models/**

BETA owns src/services/**
  ALPHA forbidden: [X] MISSING src/services/**
  GAMMA forbidden: [*] Contains src/services/**

WARNING: ALPHA can modify BETA's files (src/services/**)
         Add src/services/** to ALPHA's forbidden list

+==============================================================+
```

## 5. Check Source File Coverage

Scan actual source files and verify each is covered by a zone:

```bash
# Get all source files
find src -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx"
```

```
SOURCE FILE COVERAGE CHECK:

Scanning src/ directory...
Found: 47 source files

Checking zone coverage...

COVERED FILES:
+----------------------------------+--------+
| File                             | Zone   |
+----------------------------------+--------+
| src/models/user.ts               | ALPHA  |
| src/models/product.ts            | ALPHA  |
| src/services/auth.ts             | BETA   |
| src/routes/api.ts                | GAMMA  |
| ...                              | ...    |
+----------------------------------+--------+

UNCOVERED FILES:
+----------------------------------+
| File                             |
+----------------------------------+
| src/config/database.ts           |
| src/config/app.ts                |
| src/scripts/migrate.ts           |
+----------------------------------+

WARNING: 3 files not covered by any zone

These files will not be assigned to any Team Lead during execution.

FIX SUGGESTIONS:

1. Add src/config/** to a zone:
   Recommended: ALPHA (configuration typically with models)

2. Add src/scripts/** to a zone:
   Recommended: GAMMA (scripts typically integration)

Or create explicit exclusions if intentional:
   Add to .ace/config.json:
   "excludeFromZones": ["src/config/**", "src/scripts/**"]

+==============================================================+
```

## 6. Check for Ambiguous Matches

Find files that could match multiple zone patterns:

```
AMBIGUOUS MATCH CHECK:

Checking for files that match multiple zones...

AMBIGUOUS:
+----------------------------------+------------------+
| File                             | Matching Zones   |
+----------------------------------+------------------+
| src/lib/utils/helpers.ts         | ALPHA, BETA      |
| src/shared/types/common.ts       | ALPHA, BETA      |
+----------------------------------+------------------+

These files match patterns in multiple zones.
During execution, the FIRST matching zone wins (ALPHA > BETA > GAMMA).

Actual assignments:
- src/lib/utils/helpers.ts -> ALPHA
- src/shared/types/common.ts -> ALPHA

If this is incorrect, add explicit forbidden rules.

+==============================================================+
```

## 7. Validation Summary

```
+==============================================================+
|                    ZONE VALIDATION SUMMARY                   |
+==============================================================+

Project Type: [type]

RESULTS:
+---------------------------+--------+--------+--------+
| Check                     | Pass   | Warn   | Fail   |
+---------------------------+--------+--------+--------+
| Ownership Overlaps        |   1    |   0    |   0    |
| Owns vs Forbidden         |   3    |   0    |   0    |
| Cross-Zone Forbidden      |   2    |   1    |   0    |
| Source File Coverage      |  44    |   3    |   0    |
| Ambiguous Matches         |   0    |   2    |   0    |
+---------------------------+--------+--------+--------+
| TOTAL                     |  50    |   6    |   0    |
+---------------------------+--------+--------+--------+

STATUS: PASSED with warnings

+==============================================================+
```

## 8. Detailed Fix Report

If issues found:

```
RECOMMENDED FIXES:

PRIORITY 1 (Errors - Must Fix):
[None]

PRIORITY 2 (Warnings - Should Fix):

1. Add src/services/** to ALPHA forbidden list
   File: .ace/project-types.json
   Location: projectTypes.[type].zones.alpha.forbidden
   Add: "src/services/**"

2. Add zone coverage for src/config/**
   File: .ace/project-types.json
   Location: projectTypes.[type].zones.alpha.owns
   Add: "src/config/**"

3. Resolve ambiguous match: src/lib/utils/helpers.ts
   Option A: Add to BETA forbidden: "src/lib/**"
   Option B: Move to explicit BETA owns: "src/lib/utils/**"

Apply fixes automatically? [Yes / No / Show diff]

+==============================================================+
```

## 9. Auto-Fix Option

If user selects auto-fix:

```
APPLYING FIXES:

[*] Added src/services/** to ALPHA forbidden
[*] Added src/config/** to ALPHA owns
[*] Added src/lib/** to BETA forbidden

Updated: .ace/project-types.json

Re-validating...

+==============================================================+
|                    VALIDATION PASSED                         |
+==============================================================+

All zone conflicts resolved.
Coverage: 47/47 files (100%)
Ambiguous: 0 files

+==============================================================+
```

## 10. Success Report

If all validations pass:

```
+==============================================================+
|                    ZONE VALIDATION PASSED                    |
+==============================================================+

Project Type: [type]

Zone Configuration:
[*] No ownership overlaps
[*] No owns/forbidden conflicts
[*] Proper cross-zone isolation
[*] 100% source file coverage
[*] No ambiguous matches

Zone Summary:
+--------+------------------+-------------+-------------+
| Zone   | Files Owned      | Owns Count  | Forbidden   |
+--------+------------------+-------------+-------------+
| ALPHA  | src/models/**    | 15 files    | 3 patterns  |
| BETA   | src/services/**  | 18 files    | 3 patterns  |
| GAMMA  | src/routes/**    | 14 files    | 2 patterns  |
+--------+------------------+-------------+-------------+

Ready for parallel execution.

+==============================================================+
```

</process>

<validation_rules>

## Overlap Detection

Two patterns overlap if:
1. They are identical
2. One is a subset of the other (e.g., src/** contains src/models/**)
3. They can match the same file (e.g., src/utils/** and src/**/helpers.ts)

## Coverage Requirements

A file is "covered" if it matches at least one zone's "owns" pattern
and does NOT match that zone's "forbidden" pattern.

## Priority Order

When multiple zones could own a file:
1. ALPHA (highest priority)
2. BETA
3. GAMMA (lowest priority)

</validation_rules>

<success_criteria>
- [ ] Project type zones loaded correctly
- [ ] No overlapping ownership patterns
- [ ] No owns/forbidden conflicts within zones
- [ ] Cross-zone forbidden rules verified
- [ ] All source files have zone coverage
- [ ] Ambiguous matches identified and reported
- [ ] Clear fix suggestions provided
- [ ] Auto-fix option available for simple issues
</success_criteria>
