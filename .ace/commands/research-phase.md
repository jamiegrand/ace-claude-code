---
name: ace:research-phase
description: Deep ecosystem research before planning
argument-hint: "[phase number]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Task
  - WebSearch
  - WebFetch
  - AskUserQuestion
---

<objective>
Conduct deep research on technologies, patterns, and best practices relevant to a phase.

Use when the phase involves:
- Unfamiliar technologies
- Complex integrations
- Industry best practices needed
- Multiple competing solutions to evaluate
</objective>

<context>
Phase number: $ARGUMENTS (required)

**Required:**
@.ace/planning/STATE.md
@.ace/planning/PROJECT.md
@.ace/planning/ROADMAP.md

**Optional:**
@.ace/planning/codebase/STACK.md (for tech context)
</context>

<process>

## 1. Identify Research Topics

Read phase goal and identify:
- Technologies mentioned
- Integration patterns needed
- Unknown areas requiring research

```
+==============================================================+
|                    RESEARCH PHASE [N]                        |
+==============================================================+

Phase: [N] - [Phase Name]
Goal: [Phase goal]

Identified Research Topics:
1. [Topic 1] - [Why it needs research]
2. [Topic 2] - [Why it needs research]
3. [Topic 3] - [Why it needs research]

+==============================================================+
```

## 2. Confirm Research Scope

Use AskUserQuestion:
"I've identified these topics for research. Any to add or remove?"
- Options: "Proceed with these" / "Add topics" / "Remove some"

## 3. Spawn Research Agents

Launch parallel Explore agents for each topic:

**CRITICAL:** Send ALL Task calls in ONE message.

### For Each Topic:
```
Research [Topic] for Phase [N] of [Project Name].

Context:
- Project type: [From config.json]
- Stack: [From STACK.md or PROJECT.md]
- Goal: [Phase goal]

Research:
1. Best practices and patterns
2. Common pitfalls to avoid
3. Recommended libraries/tools
4. Example implementations

Return structured findings.
```

## 4. Collect Research Results

Wait for all agents to complete.

Aggregate findings into sections:
- Technologies evaluated
- Recommended approaches
- Risks and mitigations
- Code examples found

## 5. Create Research Document

Write to `.ace/references/phase-[N]-research.md`:

```markdown
# Research: Phase [N] - [Phase Name]

**Date:** [YYYY-MM-DD]
**Topics:** [List of topics researched]

## Technology Evaluation

### [Technology 1]
**Purpose:** [Why it's relevant]
**Recommendation:** [Use / Avoid / Consider]
**Notes:** [Key findings]

### [Technology 2]
...

## Best Practices

1. [Practice 1]
2. [Practice 2]
3. [Practice 3]

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | [H/M/L] | [H/M/L] | [How to handle] |

## Recommended Approach

[Summary of recommended technical approach based on research]

## Code Examples

### [Example 1: Description]
```[language]
[code snippet]
```

## Sources

- [Source 1 URL or reference]
- [Source 2 URL or reference]
```

## 6. Present Findings

```
+==============================================================+
|                    RESEARCH COMPLETE                         |
+==============================================================+

Phase [N] Research Summary:

Topics Researched: [N]
Document: .ace/references/phase-[N]-research.md

Key Findings:
1. [Finding 1]
2. [Finding 2]
3. [Finding 3]

Recommended Approach:
[Brief summary]

+==============================================================+

Ready to plan with this context?
  /ace:plan-phase [N]

Want to discuss first?
  /ace:discuss-phase [N]

+==============================================================+
```

</process>

<research_sources>
Research agents may use:
- WebSearch for current best practices
- WebFetch for documentation
- Grep/Glob for similar patterns in codebase
- Codebase map documents for context
</research_sources>

<when_to_use>
**Use research-phase when:**
- Implementing unfamiliar technology
- Evaluating multiple solutions
- Need industry best practices
- Complex integration requirements

**Skip research-phase when:**
- Familiar technology stack
- Repeating established patterns
- User already knows approach
- Simple feature implementation
</when_to_use>

<success_criteria>
- [ ] Research topics identified
- [ ] Parallel research agents spawned
- [ ] Findings documented
- [ ] Research document created
- [ ] User informed of findings
</success_criteria>
