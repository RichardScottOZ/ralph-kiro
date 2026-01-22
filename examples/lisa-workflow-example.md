# Lisa Plan - Example Workflow

This example demonstrates how to use Lisa to create a comprehensive specification for a feature, then use Ralph to implement it.

## Scenario: Building a Task Management API

### Step 1: Start the Lisa Interview

```bash
kiro-cli chat --agent lisa-plan
```

**You say:**
> "I want to spec out a REST API for task management"

**Lisa responds:**
> "Starting specification interview for 'REST API for task management'.
> 
> I'll ask detailed questions to build a complete spec. Say 'done' when you're ready to finalize.
> 
> **First question:** What's your primary use case for this API? Is this for a mobile app, web app, or will it be consumed by multiple clients? And what's driving the need for a new API versus using an existing solution?"

### Step 2: Answer Lisa's Questions

The interview continues with Lisa asking probing questions across different categories:

**Scope Questions:**
- "What specific task operations are in scope? (Create, read, update, delete, search, filter, sort?)"
- "Are subtasks or task hierarchies needed, or just flat task lists?"
- "What's explicitly OUT of scope? (e.g., team collaboration, real-time sync, file attachments?)"

**Technical Questions:**
- "What database are you planning to use, and is there a reason for that choice?"
- "Do you need authentication on all endpoints, or should some be public?"
- "How should the API handle task updates from different clients at the same time?"

**User Experience Questions:**
- "Walk me through the exact flow when a user creates a task - what fields are required vs optional?"
- "What happens when a user tries to delete a task that doesn't exist?"
- "Should completed tasks be deleted or archived? What's the retention policy?"

**Performance & Scale Questions:**
- "How many tasks per user do you expect? Dozens, hundreds, thousands?"
- "What's your latency requirement? Must list endpoints respond under 200ms?"
- "Should the API support pagination, and if so, offset-based or cursor-based?"

**Implementation Questions:**
- "Can we break this into phases? For example: Phase 1 (basic CRUD), Phase 2 (filtering/search), Phase 3 (advanced features)?"
- "What test framework are you using, and what's the testing strategy?"
- "How will you verify each phase is complete? What commands should succeed?"

### Step 3: Lisa Updates the Draft

Throughout the interview, Lisa updates `.kiro/lisa-draft.md` after every 2-3 questions, accumulating all the information:

```markdown
# Specification Draft: REST API for Task Management

*Interview in progress - Started: 2024-01-15*

## Overview
A RESTful API for managing tasks in a todo application. Primary consumers are a web app and mobile app.

## Scope

### In Scope
- CRUD operations for tasks (create, read, update, delete)
- Task filtering by status and due date
- Task search by title/description
- Pagination for task lists
- Authentication via JWT

### Out of Scope
- Team collaboration features
- Real-time synchronization
- File attachments
- Task sharing

## Technical Design

### Data Model
```
tasks
- id: uuid (PK)
- user_id: uuid (FK to users)
- title: string (required)
- description: text (optional)
- status: enum ('todo', 'in_progress', 'done')
- due_date: date (optional)
- created_at: timestamp
- updated_at: timestamp
```

[... continues with more details ...]
```

### Step 4: Finalize the Specification

After 20-30 questions, you say:

**You say:**
> "I think we have enough. Let's finalize this."

**Lisa responds:**
> [Creates final files]
> 
> "✅ SPEC COMPLETE - Specification saved to docs/specs/rest-api-for-task-management.md
> 
> Next step: Use Ralph to implement the spec."

### Generated Files

**1. `docs/specs/rest-api-for-task-management.md`** - Full markdown spec (see example below)

**2. `docs/specs/rest-api-for-task-management.json`** - Structured JSON:

```json
{
  "project": "rest-api-for-task-management",
  "branchName": "feature/rest-api-for-task-management",
  "description": "RESTful API for managing tasks with CRUD operations, filtering, and authentication",
  "userStories": [
    {
      "id": "US-001",
      "category": "setup",
      "title": "Database schema and migrations",
      "description": "As a developer, I want the database schema created so I can store tasks",
      "acceptanceCriteria": [
        "Migration creates tasks table with all required fields",
        "Foreign key constraint on user_id",
        "Migration runs successfully with npm run migrate"
      ],
      "passes": false,
      "notes": ""
    },
    {
      "id": "US-002",
      "category": "core",
      "title": "Create task endpoint",
      "description": "As a user, I want to create tasks via API so I can add new todos",
      "acceptanceCriteria": [
        "POST /api/tasks accepts title, description, status, due_date",
        "Returns 201 with created task object including generated id",
        "Returns 400 if title is missing",
        "Returns 401 if not authenticated",
        "Task is persisted in database"
      ],
      "passes": false,
      "notes": ""
    },
    {
      "id": "US-003",
      "category": "core",
      "title": "List tasks endpoint",
      "description": "As a user, I want to list my tasks so I can see what needs to be done",
      "acceptanceCriteria": [
        "GET /api/tasks returns array of user's tasks",
        "Returns 200 with empty array if user has no tasks",
        "Returns 401 if not authenticated",
        "Tasks ordered by created_at DESC",
        "Response time < 200ms for up to 100 tasks"
      ],
      "passes": false,
      "notes": ""
    }
  ]
}
```

**3. `docs/specs/rest-api-for-task-management-progress.txt`** - Empty file for Ralph to track progress

---

## Step 5: Review and Adjust the Spec

Review the generated spec at `docs/specs/rest-api-for-task-management.md`. Make any edits needed directly in the file.

---

## Step 6: Use Ralph to Implement

Now that Lisa has created the specification, use Ralph to implement it:

### Option A: Create PROMPT.md manually

Create a PROMPT.md that references the Lisa spec:

```markdown
# PROMPT.md

## Project
Implement the REST API for task management as specified in docs/specs/rest-api-for-task-management.md

## Requirements
Read the full specification at docs/specs/rest-api-for-task-management.md

Follow the implementation phases defined in the spec:
1. Phase 1: Database setup and migrations
2. Phase 2: Core CRUD endpoints
3. Phase 3: Filtering and pagination
4. Phase 4: Testing and polish

## Instructions

1. Read docs/specs/rest-api-for-task-management.md for complete requirements
2. Implement one user story at a time from the JSON spec
3. After each story, run verification commands
4. Update the JSON spec's "passes" field to true when complete
5. Continue until all user stories pass

## Signs (Guardrails)

- Always read the spec before starting a new story
- Run tests after each change
- Never skip failing tests
- Update the JSON spec as you complete stories
- If stuck for 3 attempts, document the issue and ask for help

## Completion

When all user stories in the JSON spec have "passes": true and all tests pass, output:

DONE
```

### Option B: Use ralph-plan to generate PROMPT.md

Alternatively, you can adapt `ralph-plan` to read Lisa's spec and generate execution files:

```bash
kiro-cli chat --agent ralph-plan
```

Then tell it: "Generate PROMPT.md and TODO.md from the spec at docs/specs/rest-api-for-task-management.md"

### Run the Ralph Loop

```bash
# Basic loop
while :; do 
  output=$(cat PROMPT.md | kiro-cli chat --no-interactive -a)
  echo "$output"
  if echo "$output" | grep -q "DONE"; then
    break
  fi
done
```

---

## Complete Example Spec

Here's an excerpt from the generated `docs/specs/rest-api-for-task-management.md`:

```markdown
# Specification: REST API for Task Management

*Generated by Lisa - 2024-01-15*

## Overview

A RESTful API that provides CRUD operations for managing tasks in a todo application. The API will be consumed by a web application and mobile app, supporting user authentication, task filtering, and pagination.

## Problem Statement

Users need a reliable backend API to manage their tasks across multiple devices. The current solution lacks proper authentication, filtering, and doesn't handle concurrent updates well. This API will provide a solid foundation for task management with proper security and performance.

## Scope

### In Scope
- Create, read, update, delete tasks
- User authentication via JWT
- Task filtering by status and due date
- Task search by title/description
- Pagination for task lists (cursor-based)
- Basic task validation

### Out of Scope
- Team collaboration features (future enhancement)
- Real-time synchronization (future enhancement)
- File attachments (future enhancement)
- Task sharing between users
- Task templates or recurring tasks
- Task categories/tags (future enhancement)

## User Stories

### US-1: Database Schema Setup

**Description:** As a developer, I want the database schema created so I can store tasks and user associations.

**Acceptance Criteria:**
- [ ] Migration creates `tasks` table with id, user_id, title, description, status, due_date, created_at, updated_at
- [ ] Foreign key constraint on user_id references users table
- [ ] Indexes on user_id and status columns for query performance
- [ ] Migration runs successfully: `npm run migrate`
- [ ] Rollback works: `npm run migrate:rollback`

### US-2: Create Task Endpoint

**Description:** As a user, I want to create tasks via the API so I can add new items to my todo list.

**Acceptance Criteria:**
- [ ] POST /api/tasks endpoint accepts JSON payload with title, description, status, due_date
- [ ] Returns 201 with created task object including generated id and timestamps
- [ ] Returns 400 if title is missing or empty
- [ ] Returns 400 if status is not one of: 'todo', 'in_progress', 'done'
- [ ] Returns 401 if authentication token is missing or invalid
- [ ] Task is persisted in database with correct user_id
- [ ] Test passes: `npm test -- create-task.test.js`

[... more user stories ...]

## Technical Design

### Data Model

**Tasks Table:**
```sql
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'todo',
  due_date DATE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_tasks_user_id ON tasks(user_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_due_date ON tasks(due_date) WHERE due_date IS NOT NULL;
```

### API Endpoints

#### POST /api/tasks
**Purpose:** Create a new task

**Authentication:** Required (JWT in Authorization header)

**Request:**
```json
{
  "title": "Buy groceries",
  "description": "Milk, eggs, bread",
  "status": "todo",
  "due_date": "2024-01-20"
}
```

**Response (201):**
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "user_id": "user-uuid",
  "title": "Buy groceries",
  "description": "Milk, eggs, bread",
  "status": "todo",
  "due_date": "2024-01-20",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

**Error Responses:**
- 400 Bad Request: Missing or invalid fields
- 401 Unauthorized: Invalid or missing token
- 500 Internal Server Error: Database error

[... more endpoints ...]

## Implementation Phases

### Phase 1: Foundation (Est. 2-3 hours)

**Goals:** Set up database schema and basic project structure

- [ ] Install dependencies: express, pg, jsonwebtoken, bcrypt
- [ ] Set up database connection with connection pooling
- [ ] Create tasks table migration
- [ ] Create seed data for testing
- [ ] Set up TypeScript types for Task model

**Verification:** `npm run migrate && npm run typecheck`

**Success Criteria:**
- Database connects successfully
- Migrations run without errors
- TypeScript compiles without errors
- Can insert/query tasks manually via psql

### Phase 2: Core CRUD (Est. 4-5 hours)

**Goals:** Implement basic task operations

- [ ] POST /api/tasks - Create task
- [ ] GET /api/tasks/:id - Get single task
- [ ] GET /api/tasks - List user's tasks
- [ ] PUT /api/tasks/:id - Update task
- [ ] DELETE /api/tasks/:id - Delete task
- [ ] Add request validation middleware
- [ ] Add authentication middleware

**Verification:** `npm test -- --grep "CRUD" && npm run lint`

**Success Criteria:**
- All CRUD operations work correctly
- Authentication is enforced
- Invalid inputs return proper error codes
- All unit tests pass

[... more phases ...]

## Definition of Done

- [ ] All user stories have passing acceptance criteria
- [ ] Unit tests pass: `npm test`
- [ ] Integration tests pass: `npm run test:integration`
- [ ] API tests pass: `npm run test:api`
- [ ] Types check: `npm run typecheck`
- [ ] Linter passes: `npm run lint`
- [ ] Build succeeds: `npm run build`
- [ ] No security vulnerabilities: `npm audit`
- [ ] API documentation is complete (Swagger/OpenAPI)
- [ ] README has setup instructions
```

---

## Key Takeaways

1. **Lisa conducts comprehensive interviews** - Unlike basic requirements gathering, Lisa asks probing questions that reveal edge cases, technical constraints, and implementation details.

2. **Adaptive questioning** - Lisa adjusts questions based on your answers, diving deeper into areas that need clarity.

3. **Complete specifications** - The output is a ready-to-implement spec with user stories, acceptance criteria, technical design, and implementation phases.

4. **Seamless handoff to Ralph** - The spec format is designed to be consumed by Ralph for autonomous implementation.

5. **Lisa plans. Ralph does.** - Separate planning from execution for better results.
