# Conventions Analysis Template

Template for `.ace/planning/codebase/CONVENTIONS.md`

---

## File Template

```markdown
# Code Conventions

## Formatting

- **Indentation:** [2 spaces / 4 spaces / tabs]
- **Line Length:** [80 / 100 / 120]
- **Quotes:** [single / double]
- **Semicolons:** [yes / no]
- **Trailing Commas:** [es5 / all / none]

**Tool:** [Prettier / ESLint / Biome]

## Naming

| Entity | Convention | Example |
|--------|------------|---------|
| Variables | camelCase | `userName` |
| Constants | UPPER_SNAKE | `MAX_RETRIES` |
| Functions | camelCase | `getUserById` |
| Classes | PascalCase | `UserService` |
| Interfaces | PascalCase with I | `IUserProps` |
| Types | PascalCase | `UserType` |
| Files | kebab-case / PascalCase | `user-service.ts` |
| Folders | kebab-case | `user-management` |

## TypeScript

- **Strict Mode:** [yes / no]
- **Type Imports:** [type-only imports / mixed]
- **Null Handling:** [strictNullChecks / optional chaining]
- **Enums:** [string enums / const objects]

Example patterns:
```typescript
// Preferred type definition style
type User = {
  id: string;
  name: string;
};

// Preferred function style
const getUser = async (id: string): Promise<User> => {
  // ...
};
```

## React

- **Component Style:** [Function / Arrow function]
- **Props:** [Destructured / Props object]
- **State:** [useState / useReducer]
- **Effects:** [useEffect patterns]

Example:
```tsx
// Component pattern
export function UserCard({ user }: UserCardProps) {
  return <div>{user.name}</div>;
}
```

## Imports

**Order:**
1. External packages
2. Internal modules (absolute)
3. Relative imports
4. Types
5. Styles

**Aliases:**
- `@/` = `src/`
- `@components/` = `src/components/`

## Error Handling

- **Try/Catch:** [Pattern used]
- **Error Types:** [Custom errors / Built-in]
- **Logging:** [Console / Logger service]

## Comments

- **JSDoc:** [When used]
- **TODO:** [Format: `// TODO: description`]
- **FIXME:** [Format: `// FIXME: description`]

## Notes

[Any project-specific conventions not covered above]
```

---

## Purpose

CONVENTIONS.md documents the coding style and patterns used in the codebase.

**Created by:** Agent 3 during `/ace:map-codebase`
