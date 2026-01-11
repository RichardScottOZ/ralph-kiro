# PROMPT.md

## Project
[One-line description of what you're building]

## Requirements
Read clarify-session.md for full requirements. Key points:
- [Most critical requirement]
- [Second most critical requirement]
- [Third most critical requirement]

## Instructions

1. Read TODO.md to see current tasks
2. Pick the highest priority incomplete task (top `- [ ]` item)
3. Read any files before editing them
4. Implement the task completely
5. Run tests/validation relevant to the task
6. If tests fail, fix them before continuing
7. Mark task complete in TODO.md by changing `- [ ]` to `- [x]`
8. Commit changes: `git add -A && git commit -m "descriptive message"`
9. Continue to next task

## Signs (Guardrails)

- Always read files before editing
- Never skip failing tests
- If tests fail 3 times on same issue, output: STUCK - [describe issue]
- Don't refactor unrelated code
- Keep changes focused on current task
- Update TODO.md immediately after completing each task

## Completion

When all tasks in TODO.md are marked `[x]` and all tests pass, output:

DONE
