---
name: develop-api
description: API endpoint creation, modification, or refactoring
---

# SKILL: Create API Endpoint

## Trigger
When asked to create, add, or scaffold a new API route, handler,
controller, or REST/GraphQL/RPC endpoint.

## Process — follow in order, no skipping
1. **Identify the API protocol**: REST, GraphQL, gRPC, WebSocket, message queue
2. Read at least 2 existing endpoint files to extract patterns
3. Identify the router/resolver/service registration pattern used
4. Identify the middleware chain (auth, validation, logging, etc.)
5. Identify the request/response type conventions
6. Identify error response format and error code conventions
7. Propose the endpoint signature and ask for confirmation
8. Implement following exact existing patterns
9. Write corresponding tests for the endpoint:
   - Test happy path with valid input
   - Test error cases and edge cases
   - Follow existing test patterns in the test directory
   - Ensure all tests pass before submission

## Protocol-Specific Structure

### For REST APIs — match existing, but default to:
```
router registration
  → auth middleware
  → input validation
  → handler function
    → parse & validate input
    → call service layer (never DB directly from handler)
    → return typed response
  → error middleware
```

### For GraphQL — match existing, but default to:
```
schema definition (SDL or code-first)
  → type definitions
  → resolver function
    → auth check (context-based)
    → input validation (arguments)
    → call service layer (never DB directly from resolver)
    → return typed response
  → error handling (GraphQL errors)
```

### For gRPC — match existing, but default to:
```
proto file definition
  → service definition
  → handler implementation
    → auth check (metadata/interceptors)
    → input validation (message fields)
    → call service layer
    → return typed response
  → error handling (gRPC status codes)
```

### For Message Queues — match existing, but default to:
```
consumer registration
  → message handler
    → parse message
    → validate payload
    → call service layer
    → acknowledge/reject message
  → dead letter handling
```

## Standards (Protocol-Agnostic)
- Handlers/resolvers MUST NOT contain business logic — delegate to service layer
- Handlers/resolvers MUST NOT query the database directly
- All inputs MUST be validated before use
- All responses MUST use the existing response wrapper/shape
- Error codes/status codes MUST follow protocol semantics (HTTP, GraphQL, gRPC)
- Authentication MUST be applied unless endpoint is explicitly public
- Rate limiting MUST be applied to all public endpoints

## Error Handling
- Use existing error class hierarchy — do not invent new error types
- All errors must be caught and passed to error middleware
- Never leak stack traces or internal details to the response
- Log errors with context (request ID, user ID if available)

## Naming Conventions
- Route path: kebab-case, plural nouns (`/user-profiles`, `/api-keys`)
- Handler function: camelCase verb+noun (`getUserProfile`, `createApiKey`)
- File: kebab-case matching route (`user-profiles.ts`, `api-keys.ts`)

## Hard Rules
- No business logic in route handlers
- No raw SQL in handlers or controllers
- No unauthenticated mutation endpoints
- No endpoints without input validation
- No new middleware without justification

## Pre-Submit Check
- [ ] Route registered correctly
- [ ] Auth middleware applied
- [ ] Input validated
- [ ] Response shape matches existing pattern
- [ ] Error cases handled and tested
- [ ] Tests written and passing
