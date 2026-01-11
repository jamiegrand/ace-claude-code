---
name: ace:discuss-phase
description: Pre-planning context gathering for a phase
argument-hint: "[phase number]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - AskUserQuestion
---

<objective>
Gather context and discuss approach before creating a plan for a phase.

Use when you need to:
- Understand requirements better
- Explore technical options
- Get user preferences before planning
- Align on approach before execution
</objective>

<context>
Phase number: $ARGUMENTS (required)

**Required:**
@.ace/planning/STATE.md
@.ace/planning/PROJECT.md
@.ace/planning/ROADMAP.md

**Optional:**
@.ace/planning/codebase/ (if brownfield)
@.ace/planning/ISSUES.md (for context)
</context>

<process>

## 1. Load Phase Context

Read ROADMAP.md for:
- Phase goal
- Dependencies (what must be done first)
- Estimated scope

Read PROJECT.md for:
- Related requirements
- Technical constraints
- Previous decisions

## 2. Display Phase Overview

```
+==============================================================+
|                    DISCUSS PHASE [N]                         |
+==============================================================+

Phase: [N] - [Phase Name]
Goal: [Phase goal from ROADMAP.md]

Dependencies:
- Phase [X] (status: [Complete/In Progress])
- Phase [Y] (status: [Complete/In Progress])

Related Requirements:
- [Requirement 1 from PROJECT.md]
- [Requirement 2 from PROJECT.md]

+==============================================================+
```

## 3. Technical Context

If codebase/ exists, summarize:
```
Existing Code Context:
- Stack: [From STACK.md]
- Architecture: [From ARCHITECTURE.md]
- Relevant concerns: [From CONCERNS.md]
```

## 4. Discussion Prompts

Use AskUserQuestion to explore:

### Question 1: Scope Clarification
"Looking at Phase [N], here's what I understand the goal to be:
[Phase goal]

Is this accurate, or should we adjust the scope?"
- Options: "Accurate" / "Needs adjustment"

### Question 2: Technical Approach
"For implementing [goal], I see a few approaches:
1. [Approach A] - [brief description]
2. [Approach B] - [brief description]

Which direction do you prefer?"
- Options: Based on approaches identified

### Question 3: Priorities
"What's most important for this phase?"
- Options: "Speed" / "Quality" / "Simplicity" / "Flexibility"

### Question 4: Known Constraints
"Are there any constraints I should know about for this phase?"
- Options: "None" / "Let me explain"

## 5. Capture Discussion Notes

Create discussion notes (not persisted, just for context):

```
DISCUSSION NOTES - Phase [N]

Scope: [Confirmed/Adjusted]
Approach: [Chosen approach]
Priority: [Speed/Quality/Simplicity/Flexibility]
Constraints: [Listed constraints]

User notes:
[Any additional context provided]
```

## 6. Next Steps

```
+==============================================================+
|                    DISCUSSION COMPLETE                       |
+==============================================================+

Phase [N] context gathered.

Summary:
- Approach: [Chosen approach]
- Priority: [Priority]
- Constraints: [Any constraints]

Ready to plan?
  /ace:plan-phase [N]

Need more research?
  /ace:research-phase [N]

+==============================================================+
```

</process>

<when_to_use>
**Use discuss-phase when:**
- Starting a complex phase
- User seems uncertain about approach
- Multiple valid technical options exist
- Requirements are ambiguous

**Skip discuss-phase when:**
- Phase is straightforward
- User has already explained approach
- Continuing existing work pattern
</when_to_use>

<success_criteria>
- [ ] Phase context loaded
- [ ] User preferences captured
- [ ] Approach agreed upon
- [ ] Ready for plan-phase
</success_criteria>
