---
name: ace:verify-work
description: User acceptance testing for completed work
argument-hint: "[optional: plan_id]"
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

<objective>
Guide user through acceptance testing of completed work.

Captures issues for fix planning if needed.
</objective>

<context>
Plan ID: $ARGUMENTS (optional - defaults to last completed plan)

**Required:**
@.ace/planning/STATE.md

**Load:**
Latest SUMMARY.md from phases/
</context>

<process>

## 1. Load Completed Work

Find most recent SUMMARY.md or use $ARGUMENTS.

Display what was built:
```
+==============================================================+
|                    VERIFY WORK                               |
+==============================================================+

Plan: [plan_id] - [plan name]
Completed: [date]

Files Created/Modified:
- src/models/user.ts
- src/services/auth.ts
- src/routes/auth.ts

+==============================================================+
```

## 2. Verification Checklist

Present from PLAN.md verification criteria:

```
VERIFICATION CHECKLIST:

Task 1: [Task Name]
- [ ] [Verification step 1]
- [ ] [Verification step 2]

Task 2: [Task Name]
- [ ] [Verification step 1]

Task 3: [Task Name]
- [ ] [Verification step 1]
- [ ] [Verification step 2]

+==============================================================+
```

## 3. Guide Testing

```
SUGGESTED TESTS:

1. Start the application:
   npm run dev

2. Test [Feature 1]:
   [How to test]

3. Test [Feature 2]:
   [How to test]

+==============================================================+
```

## 4. Collect Feedback

Use AskUserQuestion:

"Did everything work as expected?"
Options:
- "Yes, all good" -> Mark verified, continue
- "Found issues" -> Capture issues

If issues found:
"Describe the issues you found:"
[Free text capture]

## 5. Handle Results

### All Good
```
+==============================================================+
|                    VERIFICATION PASSED                       |
+==============================================================+

Plan [plan_id] verified successfully.

Next:
- /ace:plan-phase [N]  Continue development
- /ace:progress        Check overall status

+==============================================================+
```

Update STATE.md: Mark plan as verified.

### Issues Found

Capture to `.ace/planning/UAT-ISSUES.md`:
```markdown
# UAT Issues - [plan_id]

## Issue 1
**Severity:** [Critical / Major / Minor]
**Description:** [User's description]
**Expected:** [What should happen]
**Actual:** [What happened]

## Issue 2
...
```

Then:
```
+==============================================================+
|                    ISSUES CAPTURED                           |
+==============================================================+

[N] issues logged to UAT-ISSUES.md

Next: /ace:plan-fix to address these issues

+==============================================================+
```

</process>

<success_criteria>
- [ ] Verification checklist presented
- [ ] Testing guidance provided
- [ ] User feedback captured
- [ ] Issues logged if found
- [ ] STATE.md updated
- [ ] Next steps provided
</success_criteria>
