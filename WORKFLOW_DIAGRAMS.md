# Ralph Wiggum Workflow Diagram

## Overview Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│                        SETUP PHASE (One-time)                       │
│                                                                     │
│  Clone ralph-kiro → Run setup-ralph.sh → Create new project        │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│                   PHASE 1: CLARIFY (20-40 mins)                     │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────┐      │
│  │  $ kiro-cli chat --agent ralph-clarify                   │      │
│  └──────────────────────────────────────────────────────────┘      │
│                                                                     │
│  Agent asks questions:                                              │
│  ┌──────────────────┐                                               │
│  │ Q: What language?│ → A: Node.js                                  │
│  │ Q: What database?│ → A: PostgreSQL                               │
│  │ Q: What features?│ → A: CRUD + Auth                              │
│  │ ... (40-70 more) │                                               │
│  └──────────────────┘                                               │
│                                                                     │
│  Output: clarify-session.md (Comprehensive requirements)            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│                    PHASE 2: PLAN (2-5 mins)                         │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────┐      │
│  │  $ kiro-cli chat --agent ralph-plan                      │      │
│  └──────────────────────────────────────────────────────────┘      │
│                                                                     │
│  Agent reads: clarify-session.md                                    │
│                                                                     │
│  Agent generates:                                                   │
│  ┌──────────────────────────────────────────────────────────┐      │
│  │  PROMPT.md   → Instructions + Guardrails                 │      │
│  │  TODO.md     → Prioritized task checklist                │      │
│  └──────────────────────────────────────────────────────────┘      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│              PHASE 3: EXECUTE (Varies: 30min-2hrs)                  │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────┐      │
│  │  $ ./ralph-execute.sh --max-iterations 50                │      │
│  └──────────────────────────────────────────────────────────┘      │
│                                                                     │
│  Autonomous Loop:                                                   │
│  ┌──────────────────────────────────────────────────────────┐      │
│  │  Iteration 1: Read PROMPT.md → Do Task 1 → Commit        │      │
│  │  Iteration 2: Read PROMPT.md → Do Task 2 → Commit        │      │
│  │  Iteration 3: Read PROMPT.md → Do Task 3 → Commit        │      │
│  │  ...                                                      │      │
│  │  Iteration N: All done → Output "DONE" → Exit            │      │
│  └──────────────────────────────────────────────────────────┘      │
│                                                                     │
│  Output: Working software + Git history + Tests                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
                           ✅ COMPLETE!
```

## Detailed Phase 1: Clarify

```
┌──────────────────────────────────────────────────────────────────┐
│                         Ralph Clarify Agent                      │
└──────────────────────────────────────────────────────────────────┘
                                │
                                ▼
        ┌───────────────────────────────────────┐
        │   Ask 3-5 questions from category:    │
        │                                       │
        │   1. Core Requirements                │
        │   2. Users & Context                  │
        │   3. Technical Choices                │
        │   4. Integration Points               │
        │   5. Edge Cases                       │
        │   6. Quality Attributes               │
        │   7. Existing Patterns                │
        │   8. Preferences                      │
        └───────────────────────────────────────┘
                                │
                                ▼
        ┌───────────────────────────────────────┐
        │      User answers questions           │
        └───────────────────────────────────────┘
                                │
                                ▼
        ┌───────────────────────────────────────┐
        │   Update clarify-session.md:          │
        │   - Questions Asked                   │
        │   - Answers Received                  │
        │   - Emerging Requirements             │
        └───────────────────────────────────────┘
                                │
                                ▼
        ┌───────────────────────────────────────┐
        │   More questions needed?              │
        │   Yes → Loop back                     │
        │   No → Done (40-70 questions total)   │
        └───────────────────────────────────────┘
```

## Detailed Phase 2: Plan

```
┌──────────────────────────────────────────────────────────────────┐
│                          Ralph Plan Agent                        │
└──────────────────────────────────────────────────────────────────┘
                                │
                                ▼
        ┌───────────────────────────────────────┐
        │   Read clarify-session.md             │
        │   - Extract requirements              │
        │   - Identify priorities               │
        │   - Note constraints                  │
        └───────────────────────────────────────┘
                                │
                                ▼
        ┌───────────────────────────────────────┐
        │   Generate PROMPT.md:                 │
        │   - Project description               │
        │   - Requirements summary              │
        │   - Step-by-step instructions         │
        │   - Guardrails (signs)                │
        │   - Completion criteria               │
        └───────────────────────────────────────┘
                                │
                                ▼
        ┌───────────────────────────────────────┐
        │   Generate TODO.md:                   │
        │   - Critical tasks (MVP)              │
        │   - High priority tasks               │
        │   - Medium priority tasks             │
        │   - Low priority / Nice-to-have       │
        │   - HARD STOP checkpoints             │
        └───────────────────────────────────────┘
                                │
                                ▼
                    Files ready for execution!
```

## Detailed Phase 3: Execute

```
┌──────────────────────────────────────────────────────────────────┐
│                       Execution Loop                             │
└──────────────────────────────────────────────────────────────────┘
                                │
                ┌───────────────┴────────────────┐
                │   Start Iteration N            │
                └───────────────┬────────────────┘
                                │
                                ▼
                ┌───────────────────────────────────────┐
                │   Read PROMPT.md                      │
                │   - See instructions                  │
                │   - See guardrails                    │
                │   - See completion criteria           │
                └───────────────┬───────────────────────┘
                                │
                                ▼
                ┌───────────────────────────────────────┐
                │   Read TODO.md                        │
                │   - Find first incomplete task        │
                │   - Check for HARD STOP               │
                └───────────────┬───────────────────────┘
                                │
                                ▼
                ┌───────────────────────────────────────┐
                │   Read relevant files                 │
                └───────────────┬───────────────────────┘
                                │
                                ▼
                ┌───────────────────────────────────────┐
                │   Implement the task                  │
                └───────────────┬───────────────────────┘
                                │
                                ▼
                ┌───────────────────────────────────────┐
                │   Run tests                           │
                │   Pass? → Continue                    │
                │   Fail? → Fix and retry               │
                │   Fail 3x? → Output "STUCK"           │
                └───────────────┬───────────────────────┘
                                │
                                ▼
                ┌───────────────────────────────────────┐
                │   Mark task complete in TODO.md       │
                │   Change [ ] to [x]                   │
                └───────────────┬───────────────────────┘
                                │
                                ▼
                ┌───────────────────────────────────────┐
                │   Git commit changes                  │
                │   git add -A && git commit -m "..."   │
                └───────────────┬───────────────────────┘
                                │
                                ▼
                ┌───────────────────────────────────────┐
                │   All tasks done?                     │
                │   Yes → Output "DONE" → Exit          │
                │   No → Next iteration                 │
                └───────────────────────────────────────┘
```

## File Relationships

```
┌─────────────────────────────────────────────────────────────────┐
│                        Project Files                            │
└─────────────────────────────────────────────────────────────────┘

clarify-session.md
    │
    │ (read by ralph-plan)
    ▼
PROMPT.md + TODO.md
    │
    │ (read by execution loop every iteration)
    ▼
Agent reads both files → Implements task → Updates TODO.md → Commits

Git History:
    Commit 1: Task 1 complete
    Commit 2: Task 2 complete
    Commit 3: Task 3 complete
    ...
    Commit N: All tasks complete
```

## Decision Flow in Execute Phase

```
                    Read PROMPT.md
                          │
                          ▼
                    Read TODO.md
                          │
                          ▼
    ┌─────────────────────────────────────┐
    │  Any incomplete tasks?              │
    └─────────────┬───────────────────────┘
                  │
        Yes ──────┴────── No
         │                 │
         ▼                 ▼
    Do next task      Output "DONE"
         │                 │
         ▼                 ▼
    Tests pass?        Exit loop
         │
    Yes──┴──No
     │       │
     ▼       ▼
  Commit  Fix issue
     │       │
     ▼       │
  Continue───┘
```

## Monitoring Progress

```
During Execution:

Terminal Output           TODO.md Status        Git History
─────────────────        ──────────────        ────────────
Iteration 1...     →     [x] Task 1       →    Commit: Task 1
Iteration 2...     →     [x] Task 2       →    Commit: Task 2
Iteration 3...     →     [x] Task 3       →    Commit: Task 3
...                      ...                   ...
Iteration N...     →     [x] All done     →    Commit: Task N
DONE!                    ✓ Complete            ✓ Complete
```

## Error Handling Flow

```
                    Task Execution
                          │
                          ▼
                    ┌──────────┐
                    │  Error?  │
                    └────┬─────┘
                         │
              ┌──────────┴──────────┐
              │                     │
            Yes                    No
              │                     │
              ▼                     ▼
      ┌──────────────┐       Continue to
      │ Retry count? │       next task
      └──────┬───────┘
             │
    ┌────────┴────────┐
    │                 │
  < 3              ≥ 3
    │                 │
    ▼                 ▼
  Fix and     Output "STUCK"
  retry       + description
    │                 │
    └─────────────────┘
```

---

These diagrams illustrate the complete Ralph Wiggum workflow adapted for Kiro CLI!
