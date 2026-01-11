# Example: Simple TODO API

This example demonstrates the Ralph Wiggum workflow for building a simple REST API for managing TODO items.

## Scenario

You want to build a REST API with the following features:
- Create, read, update, and delete TODO items
- Each TODO has: title, description, completed status
- Store data in-memory (no database required)
- Use Node.js and Express

## Phase 1: Clarify Session Results

See `clarify-session-example.md` for the full question/answer session.

**Key Requirements:**
- Language: Node.js with Express
- Storage: In-memory array
- Endpoints: GET, POST, PUT, DELETE for /todos
- Testing: Basic tests with Jest
- No authentication required (for simplicity)

## Phase 2: Generated Files

### PROMPT.md

```markdown
# PROMPT.md

## Project
Build a REST API for managing TODO items using Node.js and Express with in-memory storage.

## Requirements
Read clarify-session-example.md for full requirements. Key points:
- RESTful API with GET, POST, PUT, DELETE endpoints
- In-memory storage (no database)
- Each TODO has: id, title, description, completed (boolean)
- Return proper HTTP status codes
- Basic input validation

## Instructions

1. Read TODO.md to see current tasks
2. Pick the highest priority incomplete task (top `- [ ]` item)
3. Read any files before editing them
4. Implement the task completely
5. Run tests with `npm test` after changes
6. If tests fail, fix them before continuing
7. Mark task complete in TODO.md by changing `- [ ]` to `- [x]`
8. Commit changes: `git add -A && git commit -m "descriptive message"`
9. Continue to next task

## Signs (Guardrails)

- Always read files before editing
- Never skip failing tests
- If tests fail 3 times on same issue, output: STUCK - [describe issue]
- Use ES6+ syntax (const/let, arrow functions, async/await)
- Return proper HTTP status codes (200, 201, 404, 400, etc.)
- Validate request body before processing
- Keep routes simple and RESTful

## Completion

When all tasks in TODO.md are marked `[x]` and all tests pass, output:

DONE
```

### TODO.md

```markdown
# TODO

## Critical (MVP - Must Complete)
- [ ] Initialize Node.js project with package.json
- [ ] Install Express and required dependencies
- [ ] Create basic Express server setup in server.js
- [ ] Implement in-memory data store (array) for TODOs
- [ ] Create GET /todos endpoint (return all TODOs)
- [ ] Create POST /todos endpoint (add new TODO)
- [ ] Create GET /todos/:id endpoint (get single TODO)
- [ ] Create PUT /todos/:id endpoint (update TODO)
- [ ] Create DELETE /todos/:id endpoint (delete TODO)
- [ ] Add basic input validation for POST and PUT
- [ ] **HARD STOP** - Verify all endpoints work with manual testing

## High Priority
- [ ] Install Jest and supertest for testing
- [ ] Create test file tests/todos.test.js
- [ ] Write tests for GET /todos
- [ ] Write tests for POST /todos
- [ ] Write tests for GET /todos/:id
- [ ] Write tests for PUT /todos/:id
- [ ] Write tests for DELETE /todos/:id
- [ ] Ensure all tests pass

## Medium Priority
- [ ] Add error handling middleware
- [ ] Return proper error messages for validation failures
- [ ] Add 404 handler for unknown routes
- [ ] **HARD STOP** - Review error handling

## Low Priority / Nice-to-Have
- [ ] Add README with API documentation
- [ ] Add example requests in examples/ folder
- [ ] Add CORS support
- [ ] Add request logging

---
## Completed
(Completed tasks will be moved here)
```

## Phase 3: Execution

Run the Ralph loop:

```bash
# Safe loop with max 30 iterations
max_iterations=30
iteration=0

while [ $iteration -lt $max_iterations ]; do
  echo "Iteration $((iteration + 1))/$max_iterations"
  output=$(cat PROMPT.md | kiro-cli chat --mode script)
  echo "$output"
  
  if echo "$output" | grep -q "DONE"; then
    echo "✅ Task completed at iteration $((iteration + 1))!"
    break
  fi
  
  iteration=$((iteration + 1))
done

if [ $iteration -eq $max_iterations ]; then
  echo "⚠️  Reached max iterations. Review progress and adjust."
fi
```

## Expected Output

After execution completes, you should have:
- `server.js` - Express server with all CRUD endpoints
- `package.json` - Project dependencies
- `tests/todos.test.js` - Comprehensive test suite
- All tests passing
- Git history showing incremental progress

## Estimated Iterations

This simple project typically completes in 15-25 iterations depending on:
- Complexity of error handling
- Test coverage thoroughness
- Initial prompt clarity

## Learning Points

1. **Task Granularity**: Each task in TODO.md is small and specific
2. **HARD STOPS**: Review points prevent over-engineering
3. **Guardrails**: Specific coding standards prevent common mistakes
4. **Testing**: Tests are built incrementally with features
5. **Git History**: Each iteration commits working code

## Try It Yourself

1. Copy this example to a new directory
2. Run the clarify phase manually or use the provided clarify-session-example.md
3. Run the plan phase to generate PROMPT.md and TODO.md
4. Execute the loop and observe the autonomous development
5. Review git history to see the incremental progress

## Debugging Tips

If Ralph gets stuck:
- Check the error message in the output
- Review the last commit to see what was attempted
- Add a more specific guardrail to PROMPT.md
- Break down the current task into smaller subtasks in TODO.md
- Restart from the current state
