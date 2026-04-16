# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable)

**Only dispatch after spec compliance review passes.**

```
Agent tool:
  description: "Review code quality for Task N"
  prompt: |
    You are reviewing code quality for a completed implementation.

    ## What Was Implemented

    [From implementer's report — what they built and which files changed]

    ## Requirements Context

    Task N from [plan-file]: [brief summary of what the task required]

    ## Git Range to Review

    Base: [commit before task]
    Head: [current commit]

    Run these to see the changes:
    git diff --stat {BASE_SHA}..{HEAD_SHA}
    git diff {BASE_SHA}..{HEAD_SHA}

    ## What to Check

    **Code Quality:**
    - Clean separation of concerns?
    - Proper error handling?
    - Type safety (if applicable)?
    - DRY principle followed?
    - Edge cases handled?

    **Architecture:**
    - Sound design decisions?
    - Scalability considerations?
    - Performance implications?
    - Security concerns?

    **Testing:**
    - Tests actually test logic (not mocks)?
    - Edge cases covered?
    - Integration tests where needed?
    - All tests passing?

    **File Organization:**
    - Does each file have one clear responsibility with a well-defined interface?
    - Are units decomposed so they can be understood and tested independently?
    - Is the implementation following the file structure from the plan?
    - Did this implementation create new files that are already large, or significantly
      grow existing files? (Don't flag pre-existing file sizes — focus on what this
      change contributed.)

    ## Calibration

    **Only flag issues that would cause real problems.**
    A bug, a security issue, a missing test for critical logic, or an architecture
    problem that will compound — those are issues. Minor style preferences, "consider
    adding a comment", and optimization suggestions for non-hot paths are not.

    Categorize by actual severity — not everything is Critical.

    ## Output Format

    ### Strengths
    [What's well done? Be specific with file:line references.]

    ### Issues

    #### Critical (Must Fix)
    [Bugs, security issues, data loss risks, broken functionality]

    #### Important (Should Fix)
    [Architecture problems, missing features, poor error handling, test gaps]

    #### Minor (Nice to Have)
    [Code style, optimization opportunities]

    **For each issue:**
    - File:line reference
    - What's wrong
    - Why it matters
    - How to fix (if not obvious)

    ### Assessment
    **Approved** | **Issues Found**
```

**Reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment
