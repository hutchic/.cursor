---
name: validate-new-api-routes
description: "When adding new API or server routes: document manual validation, add an automated check (smoke or test) that hits the route, wire it into the suite, and run that verification before marking the task complete. Use when adding new Nuxt/API routes, server endpoints, or similar."
---

# Validate New API Routes Skill

When you add new API or server routes, add both manual validation (docs + curl) and an automated check, wire the check into the existing suite, and **run** that verification and report the result before marking the task complete.

## When to Use

- Use when adding new API routes (e.g. Nuxt server API, `/api/...` endpoints)
- Use when adding new server-side routes that should be manually testable and covered by smoke or tests
- Use whenever the user asks to "validate" or "verify" new routes and you add docs or automation

## Steps

### 1. Document manual validation

- Add or update a doc (e.g. in `docs/`) with a **Manual validation** (or similar) section.
- Include: base URL (e.g. `http://localhost:3000` or `SITE_URL`), and for each new route:
  - Exact URL and method (e.g. `GET /api/auth/get-session`).
  - Example: `curl -s http://localhost:3000/api/auth/get-session`.
  - Expected status (e.g. 200) and expected response shape (e.g. `null` or `{}` when not logged in).
- Mention how to run the app (e.g. `make dev` or `make up`) so someone can run the curls.

### 2. Add an automated check

- Add a smoke or test script that hits the new route(s) and asserts status (and optionally body).
- Examples: `tests/smoke/20-auth-api.sh` that calls `GET /api/auth/get-session` and expects 200.
- If the route depends on a service (e.g. Postgres), use the same skip logic as similar scripts (e.g. exit 0 when that service is not in the stack).

### 3. Wire into the suite

- Add the new script to the Makefile (or equivalent) so the smoke/test target runs it (e.g. add `20-auth-api.sh` to the list run by `make test/smoke`).

### 4. Run verification before marking done

- Run the new check (e.g. `make test/smoke` or the specific script) and report pass or fail.
- Do not document verification or add a script without running it and reporting the outcome. See [Verify-Before-Done Rule](.cursor/rules/meta/verify-before-done.mdc) and the "When You Add New Verification" guideline.

## Notes

- Prefer one script per logical group of routes (e.g. one "auth API" script) unless the suite is organized per-route.
- If the app must be running (e.g. `make up` or `make dev`), the doc and the suite should state that; run the suite with the stack up so the new check is executed.

## Related Artifacts

- [Verify-Before-Done Rule](.cursor/rules/meta/verify-before-done.mdc) – Run verification and report before marking done
- [Reproduce-Before-Fix Rule](.cursor/rules/meta/reproduce-before-fix.mdc) – Reproduce failures before fixing
- [Process Chat Command](.cursor/commands/meta/process-chat.md)
