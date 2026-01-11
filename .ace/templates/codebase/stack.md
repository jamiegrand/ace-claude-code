# Stack Analysis Template

Template for `.ace/planning/codebase/STACK.md`

---

## File Template

```markdown
# Technology Stack

## Languages

| Language | Version | Usage |
|----------|---------|-------|
| [TypeScript] | [5.x] | [Primary] |
| [JavaScript] | [ES2022] | [Config files] |

## Frameworks

| Framework | Version | Purpose |
|-----------|---------|---------|
| [Next.js] | [14.x] | [Full-stack framework] |
| [React] | [18.x] | [UI library] |

## Key Dependencies

### Production

| Package | Version | Purpose |
|---------|---------|---------|
| [prisma] | [5.x] | [ORM] |
| [zod] | [3.x] | [Validation] |
| [tailwindcss] | [3.x] | [Styling] |

### Development

| Package | Version | Purpose |
|---------|---------|---------|
| [typescript] | [5.x] | [Type checking] |
| [eslint] | [8.x] | [Linting] |
| [vitest] | [1.x] | [Testing] |

## Runtime

- **Node.js:** [20.x]
- **Package Manager:** [pnpm / npm / yarn]
- **Build Tool:** [Next.js built-in / Vite / etc.]

## Database

- **Type:** [PostgreSQL / SQLite / MongoDB]
- **ORM:** [Prisma / Drizzle / TypeORM]
- **Migrations:** [Prisma migrate / custom]

## External Services

| Service | Purpose | Integration |
|---------|---------|-------------|
| [Auth0] | [Authentication] | [SDK] |
| [Stripe] | [Payments] | [API] |

## Notes

[Any special considerations about the stack]
```

---

## Purpose

STACK.md documents the technology foundation of the codebase.

**Used by:**
- `/ace:new-project` to inform technical decisions
- Phase planning to understand constraints
- Team Leads to know available tools

**Created by:** Agent 1 during `/ace:map-codebase`
