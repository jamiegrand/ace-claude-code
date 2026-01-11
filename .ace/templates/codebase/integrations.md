# Integrations Analysis Template

Template for `.ace/planning/codebase/INTEGRATIONS.md`

---

## File Template

```markdown
# External Integrations

## APIs

### [Service Name]
- **Purpose:** [What it does]
- **Type:** [REST / GraphQL / gRPC]
- **Authentication:** [API Key / OAuth / JWT]
- **Client Location:** [src/lib/serviceName.ts]
- **Environment Variables:**
  - `SERVICE_API_KEY`
  - `SERVICE_URL`

### [Another Service]
- **Purpose:** [What it does]
- **Type:** [REST]
- **Authentication:** [API Key]
- **Client Location:** [src/lib/another.ts]
- **Environment Variables:**
  - `ANOTHER_API_KEY`

## Databases

### Primary Database
- **Type:** [PostgreSQL / MySQL / MongoDB]
- **Connection:** [Prisma / Drizzle / Native]
- **Location:** [prisma/schema.prisma]
- **Environment Variables:**
  - `DATABASE_URL`

### Cache
- **Type:** [Redis / In-memory]
- **Purpose:** [Session / Cache / Queue]
- **Environment Variables:**
  - `REDIS_URL`

## Authentication

- **Provider:** [Auth0 / Clerk / NextAuth / Custom]
- **Strategy:** [JWT / Session / OAuth]
- **Configuration:** [src/lib/auth.ts]
- **Environment Variables:**
  - `AUTH_SECRET`
  - `AUTH_PROVIDER_ID`
  - `AUTH_PROVIDER_SECRET`

## File Storage

- **Provider:** [S3 / Cloudflare R2 / Local]
- **Purpose:** [User uploads / Assets]
- **Client:** [src/lib/storage.ts]
- **Environment Variables:**
  - `STORAGE_BUCKET`
  - `STORAGE_ACCESS_KEY`

## Email

- **Provider:** [SendGrid / Resend / SES]
- **Purpose:** [Transactional / Marketing]
- **Client:** [src/lib/email.ts]
- **Environment Variables:**
  - `EMAIL_API_KEY`

## Payments

- **Provider:** [Stripe / PayPal]
- **Features:** [Subscriptions / One-time / Invoices]
- **Webhook:** [/api/webhooks/stripe]
- **Environment Variables:**
  - `STRIPE_SECRET_KEY`
  - `STRIPE_WEBHOOK_SECRET`

## Analytics

- **Provider:** [Vercel Analytics / Posthog / Mixpanel]
- **Events:** [Page views / Custom events]
- **Client:** [src/lib/analytics.ts]

## Environment Variables Summary

| Variable | Service | Required |
|----------|---------|----------|
| DATABASE_URL | Database | Yes |
| AUTH_SECRET | Auth | Yes |
| STRIPE_SECRET_KEY | Payments | Production |
| ... | ... | ... |

## Notes

[Integration-specific considerations, rate limits, or known issues]
```

---

## Purpose

INTEGRATIONS.md documents all external service connections.

**Created by:** Agent 1 during `/ace:map-codebase`
