# Structure Analysis Template

Template for `.ace/planning/codebase/STRUCTURE.md`

---

## File Template

```markdown
# Directory Structure

## Root Layout

```
project/
├── src/                    # Source code
├── public/                 # Static assets
├── prisma/                 # Database schema
├── tests/                  # Test files
├── .ace/              # Ace config
└── [config files]          # Root configs
```

## Source Directory

```
src/
├── app/                    # Next.js app router
│   ├── layout.tsx          # Root layout
│   ├── page.tsx            # Home page
│   ├── api/                # API routes
│   └── [feature]/          # Feature routes
│
├── components/             # React components
│   ├── ui/                 # Base UI components
│   ├── forms/              # Form components
│   └── [feature]/          # Feature components
│
├── lib/                    # Utilities
│   ├── utils.ts            # General utilities
│   ├── db.ts               # Database client
│   └── auth.ts             # Auth utilities
│
├── services/               # Business logic
│   └── [domain].ts         # Domain services
│
├── types/                  # TypeScript types
│   └── index.ts            # Type exports
│
└── hooks/                  # React hooks
    └── use[Hook].ts        # Custom hooks
```

## Key Directories

| Directory | Purpose | Zone |
|-----------|---------|------|
| src/app/ | Routes & pages | GAMMA |
| src/components/ | UI components | BETA |
| src/services/ | Business logic | BETA |
| src/lib/ | Utilities | BETA |
| src/types/ | Type definitions | BETA |
| prisma/ | Database schema | ALPHA |

## File Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Component | PascalCase | `UserCard.tsx` |
| Hook | camelCase with use | `useAuth.ts` |
| Utility | camelCase | `formatDate.ts` |
| Type | PascalCase | `User.ts` |
| Route | lowercase | `api/users/route.ts` |

## Module Organization

[How code is organized within modules]

- Feature-based grouping
- Barrel exports (index.ts)
- Co-located tests

## Notes

[Any structural patterns or conventions specific to this codebase]
```

---

## Purpose

STRUCTURE.md maps the physical organization of the codebase.

**Created by:** Agent 2 during `/ace:map-codebase`
