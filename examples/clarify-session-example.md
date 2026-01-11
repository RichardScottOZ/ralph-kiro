# Discovery: Simple TODO API

Started: 2024-01-10

## Questions Asked

1. What is the primary goal of this project? → Build a REST API for managing TODO items
2. Who will use this API? → Developers integrating it into their applications
3. What programming language should be used? → Node.js
4. What framework would you prefer? → Express.js
5. What database should be used? → In-memory storage (no database for simplicity)
6. What are the core features? → CRUD operations for TODO items
7. What fields should a TODO have? → id, title, description, completed status, created date
8. Should there be authentication? → No, keep it simple for this example
9. What about authorization? → Not needed for this simple example
10. What HTTP methods should be supported? → GET, POST, PUT, DELETE
11. What endpoints are needed? → /todos (list all, create), /todos/:id (get, update, delete)
12. What status codes should be returned? → Standard REST codes (200, 201, 404, 400, 500)
13. Should there be input validation? → Yes, validate required fields
14. What validation rules? → Title is required, title max 100 chars, description max 500 chars
15. How should errors be handled? → Return JSON error messages with appropriate status codes
16. Should there be request logging? → Nice to have, not critical
17. What about CORS? → Nice to have for frontend integration
18. Testing requirements? → Unit tests for all endpoints
19. What testing framework? → Jest with supertest
20. What should test coverage include? → All CRUD operations and error cases
21. Should there be API documentation? → Yes, in README
22. What about example requests? → Yes, include curl examples
23. Environment configuration? → Simple, just port configuration via env var
24. What port should the server run on? → 3000 (configurable via PORT env var)
25. Should there be a health check endpoint? → Yes, GET /health
26. What about request body size limits? → Default Express limits are fine
27. Should responses be paginated? → No, in-memory storage is small
28. What about filtering or sorting? → Not needed for MVP
29. Should completed TODOs be filterable? → Nice to have, but not MVP
30. What about unique ID generation? → Simple incrementing integer is fine
31. Should IDs be preserved across restarts? → No, in-memory resets on restart
32. What about concurrent requests? → Express handles this by default
33. Should there be rate limiting? → No, not needed
34. What about request timeouts? → Default Express timeouts are fine
35. Should the API be versioned? → No, keep it simple
36. What about partial updates (PATCH)? → No, just full PUT updates
37. Should there be bulk operations? → No, single item operations only
38. What about soft deletes? → No, hard delete is fine
39. Should there be audit logs? → No, too complex for this example
40. What about data validation on update? → Yes, same rules as create
41. Should empty title be allowed? → No, title is required
42. What about whitespace-only titles? → Should be rejected
43. Can description be optional? → Yes, description is optional
44. Default value for completed? → False
45. Should completed be required in requests? → No, it's optional
46. What date format for created? → ISO 8601 string
47. Should created date be editable? → No, set once on creation
48. What about last updated timestamp? → Nice to have, not critical
49. Error message format? → JSON with "error" field containing message
50. Should validation errors list all issues? → Yes, return array of validation errors

## Answers Received

### Core Functionality
- REST API for TODO management with full CRUD operations
- Endpoints: GET /todos, POST /todos, GET /todos/:id, PUT /todos/:id, DELETE /todos/:id
- Additional: GET /health for health checks
- In-memory storage (data lost on restart)

### Technical Stack
- Language: Node.js (ES6+)
- Framework: Express.js
- Storage: In-memory array
- Testing: Jest + supertest
- No database required

### Data Model
```javascript
{
  id: number,           // Auto-increment integer
  title: string,        // Required, max 100 chars
  description: string,  // Optional, max 500 chars
  completed: boolean,   // Default false
  createdAt: string     // ISO 8601 timestamp
}
```

### Users & Context
- Target users: Developers integrating the API
- Skill level: Intermediate developers familiar with REST APIs
- Environment: Development/testing (not production-ready)
- Use case: Learning example or prototype

### Integration Points
- None - standalone API
- Frontend integration possible with CORS support

### Quality Attributes
- Performance: No specific requirements (in-memory is fast)
- Security: No authentication (public API)
- Scalability: Not a concern (in-memory, single instance)
- Reliability: No persistence needed

### Validation Rules
- POST /todos:
  - title: required, non-empty, max 100 characters
  - description: optional, max 500 characters
  - completed: optional boolean (default false)
- PUT /todos/:id:
  - Same rules as POST
  - id must exist
- DELETE /todos/:id:
  - id must exist
- GET /todos/:id:
  - id must exist

### Error Handling
- 200: Successful GET, PUT, DELETE
- 201: Successful POST (created)
- 400: Validation error (return error details)
- 404: TODO not found
- 500: Server error
- Error format: `{ "error": "Error message" }` or `{ "errors": ["Error 1", "Error 2"] }`

### Testing Requirements
- Test all endpoints (GET, POST, PUT, DELETE)
- Test success cases
- Test error cases (validation, not found)
- Test edge cases (empty title, too long input)
- Aim for >80% code coverage

## Emerging Requirements

### Must Have (MVP)
- Express server setup on port 3000 (configurable via PORT env var)
- In-memory array to store TODOs
- GET /todos - List all TODOs
- POST /todos - Create new TODO (validate title required, max lengths)
- GET /todos/:id - Get single TODO (404 if not found)
- PUT /todos/:id - Update TODO (validate, 404 if not found)
- DELETE /todos/:id - Delete TODO (404 if not found)
- GET /health - Health check endpoint
- Input validation with proper error messages
- Jest test suite with supertest
- Tests for all endpoints and error cases

### Should Have
- CORS support for frontend integration
- Comprehensive error handling middleware
- 404 handler for unknown routes
- README with API documentation and examples
- Example curl requests

### Nice to Have
- Request logging (e.g., morgan)
- Filter TODOs by completed status
- Sort TODOs by creation date
- Last updated timestamp
- Prettier formatted code

### Explicitly Out of Scope
- Database persistence
- Authentication/authorization
- Pagination
- API versioning
- Rate limiting
- Bulk operations
- PATCH support (partial updates)
- Soft deletes
- Audit logging
- Production-ready features (monitoring, metrics)
