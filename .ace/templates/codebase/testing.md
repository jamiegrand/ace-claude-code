# Testing Analysis Template

Template for `.ace/planning/codebase/TESTING.md`

---

## File Template

```markdown
# Testing Strategy

## Overview

- **Framework:** [Vitest / Jest / Playwright]
- **Coverage:** [X%]
- **CI Integration:** [Yes / No]

## Test Types

### Unit Tests
- **Location:** [src/__tests__ / *.test.ts]
- **Framework:** [Vitest / Jest]
- **Coverage:** [X%]

### Integration Tests
- **Location:** [tests/integration/]
- **Framework:** [Vitest / Jest]
- **Database:** [Test DB / In-memory]

### E2E Tests
- **Location:** [tests/e2e/ / playwright/]
- **Framework:** [Playwright / Cypress]
- **Coverage:** [Key flows]

## Test Structure

```
tests/
├── unit/                   # Unit tests
│   ├── services/           # Service tests
│   └── utils/              # Utility tests
├── integration/            # Integration tests
│   └── api/                # API tests
└── e2e/                    # End-to-end tests
    └── flows/              # User flow tests
```

Or co-located:
```
src/
├── services/
│   ├── auth.ts
│   └── auth.test.ts        # Co-located test
```

## Test Patterns

### Mocking
```typescript
// Mock pattern used
vi.mock('@/lib/db', () => ({
  prisma: mockPrisma,
}));
```

### Fixtures
```typescript
// Fixture pattern
const mockUser = createMockUser({ name: 'Test' });
```

### Assertions
```typescript
// Assertion style
expect(result).toEqual(expected);
expect(fn).toHaveBeenCalledWith(args);
```

## Commands

| Command | Purpose |
|---------|---------|
| `npm test` | Run all tests |
| `npm run test:unit` | Unit tests only |
| `npm run test:e2e` | E2E tests |
| `npm run test:coverage` | With coverage |

## CI/CD

- **When:** [On PR / On push / On merge]
- **Required:** [Yes / No]
- **Minimum Coverage:** [X%]

## Notes

[Test-specific conventions, known gaps, or improvement areas]
```

---

## Purpose

TESTING.md documents the testing approach and infrastructure.

**Created by:** Agent 3 during `/ace:map-codebase`
