# Architecture Analysis Template

Template for `.ace/planning/codebase/ARCHITECTURE.md`

---

## File Template

```markdown
# System Architecture

## Overview

[High-level description of the system architecture]

## Architecture Pattern

**Pattern:** [Monolith / Microservices / Serverless / Hybrid]
**Style:** [MVC / Clean Architecture / Hexagonal / etc.]

## System Diagram

```
[ASCII diagram showing major components and their relationships]

+-------------+     +-------------+     +-------------+
|   Client    | --> |     API     | --> |  Database   |
+-------------+     +-------------+     +-------------+
                          |
                          v
                    +-------------+
                    |  Services   |
                    +-------------+
```

## Layers

### Presentation Layer
- **Location:** [src/app/, src/components/]
- **Responsibility:** [UI rendering, user interaction]
- **Key patterns:** [Component composition, hooks]

### Business Logic Layer
- **Location:** [src/services/, src/lib/]
- **Responsibility:** [Business rules, domain logic]
- **Key patterns:** [Service classes, pure functions]

### Data Access Layer
- **Location:** [src/db/, prisma/]
- **Responsibility:** [Database operations]
- **Key patterns:** [Repository pattern, ORM]

## Data Flow

```
User Action
    |
    v
Component (UI)
    |
    v
Hook/Action (Client Logic)
    |
    v
API Route (Server)
    |
    v
Service (Business Logic)
    |
    v
Repository (Data Access)
    |
    v
Database
```

## Key Boundaries

| Boundary | Separation | Communication |
|----------|------------|---------------|
| Client/Server | [HTTP] | [REST API / tRPC / GraphQL] |
| Server/Database | [ORM] | [Prisma queries] |
| Services | [Interfaces] | [Direct calls / Events] |

## State Management

- **Client State:** [React state / Zustand / Redux]
- **Server State:** [React Query / SWR / Server Components]
- **Persistence:** [Database / LocalStorage / Sessions]

## Notes

[Any architectural decisions, trade-offs, or technical debt]
```

---

## Purpose

ARCHITECTURE.md documents how the system is organized and how components interact.

**Created by:** Agent 2 during `/ace:map-codebase`
