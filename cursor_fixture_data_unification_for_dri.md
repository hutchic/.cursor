# Fixture data unification for drizzle migrations
_Exported on 07/04/2026 at 8:42:53 GMT-4 from Cursor (3.0.12)_

---

**User**

let's continue to unify all fixture data to the drizzle migrations. For example what is @shared/hockeymind/teams.ts ?

---

**Cursor**

Got it. I’m going to inspect `shared/hockeymind/teams.ts` and the surrounding schema/fixture wiring, then explain exactly what it is today (source-of-truth, who imports it, and how it relates to Drizzle migrations) and outline the concrete next migration step to fold it into SQL fixtures.

Next I’m going to find where `TEAM_OPTIONS` / `FIXTURE_TEAM_SEED_SLUGS` are imported, so we can decide whether this file is acting as a second “fixture source” (bad) or just a UI convenience that can be derived from DB rows (preferred) before we migrate/delete it.

## What is `shared/hockeymind/teams.ts`?

It’s a **small “fixture selector” module** that hard-codes:

- **`FIXTURE_TEAM_SEED_SLUGS`**: the ordered list of team **seed slugs** (stable keys that match `hockey_team.slug`) that the app considers part of the _fixture library_.
- **`TEAM_OPTIONS`**: a parallel list of `{ slug, name }` used as **human-facing labels** (and referenced by tests).
- **`TeamSeedSlug`**: a TS type derived from `TEAM_OPTIONS`.

You can see the intent right in the header:

```1:33:shared/hockeymind/teams.ts
/**
 * Team compositions available in the tracer UI (seed keys match `hockey_team.slug`).
 * Public URLs and chat `teamId` use `hockey_team.id` (UUID); `slug` is the stable seed key.
 * Keep in sync with fixture rows delivered by migrations — see integration tests.
 */
export const FIXTURE_TEAM_SEED_SLUGS = [
  'balanced',
  'fast-defense',
  'fast-forwards',
  'weak-passing'
] as const

export const TEAM_OPTIONS = [
  { slug: 'balanced', name: 'Eastgate U15 — Balanced depth' },
  { slug: 'fast-defense', name: 'Northside U15 — Structure first' },
  { slug: 'fast-forwards', name: 'River Valley U15 — Pace offense' },
  { slug: 'weak-passing', name: 'South County U13 — Weak passing' }
] as const
```

### Why it matters for “unify fixtures into migrations”

Right now this file is effectively a **second source of truth for “which fixture teams exist” and “what their names are”**, because it’s used in **runtime routing** and **tests**:

- **Runtime API uses it to filter DB rows**:

```3:41:server/api/teams/fixture-library.get.ts
import { FIXTURE_TEAM_SEED_SLUGS } from '../../../shared/hockeymind/teams'
// ...
.where(inArray(hockeyTeam.slug, [...FIXTURE_TEAM_SEED_SLUGS]))
```

- **Unit test imports `TEAM_OPTIONS`** (`tests/hockeymind-teams.test.ts`)
- **E2E test hard-codes labels that “match `TEAM_OPTIONS[...]`”** (`e2e/j2_team_switch_clears_session.test.ts`)

So even if migrations are the _only_ writer, we still have a **parallel “catalog”** living in TS that can drift from what migrations insert.

### The direction to finish the unification

To make migrations the single authoritative place, the app should **derive** these lists from the database fixture rows (and/or query by an explicit DB flag like “is_fixture_library”), rather than enumerating slugs in TS.

If you want, next I can implement the first slice: replace `FIXTURE_TEAM_SEED_SLUGS` usage in `server/api/teams/fixture-library.get.ts` with a DB-driven query (then update the tests that currently depend on those TS constants).

---

**User**

draft a plan to nuke those ts fixture files. This data should be seeded via drizzle sql migrations and the application should use the database as it's source of truth.

---

**Cursor**

I’ll inventory all TS-based fixture sources (like `shared/hockeymind/teams.ts`), map who imports them (API/UI/tests), and then propose a migration-first replacement plan (DB-driven queries + updated tests) so we can delete those files without losing functionality.

Next I’ll read the other TS “fixture-ish” modules (`drillLibraryV1`, `tracerContext`, `teamRosterStatic`) plus the existing SQL fixture seed(s). That will let us define exactly what gets migrated into SQL and what becomes DB-driven queries so we can delete TS catalogs cleanly.

**Fixture unification decisions**

> **To eliminate hard-coded slug lists in TS, should we add a DB marker on `hockey_team` (e.g. `is_fixture_library` + optional `fixture_sort_index`) and update the seed + grants trigger to use that, instead of `WHERE slug IN (...)`?**
> - Yes — add `is_fixture_library` + `fixture_sort_index` and make app/SQL query by those columns.
> - No — keep the list hard-coded in SQL migrations/triggers, just remove TS usage from the app. ✔
>
> **Scope-wise, are we only deleting TS fixture catalogs (like `shared/hockeymind/teams.ts`), or do you also want to remove the canonical JSON inputs under `data/teams/v1/` and `data/drills/v1/` (meaning fixtures would be authored directly as SQL)?**
> - Delete TS fixture files only; keep JSON inputs (they’re not runtime sources).
> - Move authoring fully to SQL; delete/stop using the JSON fixture inputs too. ✔

---

**User**

Implement the plan as specified, it is attached for your reference. Do NOT edit the plan file itself.

To-do's from the plan have already been created. Do not create them again. Mark them as in_progress as you work, starting with the first one. Don't stop until you have completed all the to-dos.

---

**Cursor**

I’m going to implement this in three slices: first add the DB view and wire `0015` to it, then switch the runtime endpoint/tests off `shared/hockeymind/teams.ts` and delete that file, then finish the “SQL-only authoring” work by updating docs/provenance scripts and replacing the team offline snapshot with a DB-derived exporter.

Next I’ll register these migrations in `drizzle/meta/_journal.json` so `drizzle-kit migrate` can pick them up, then I’ll move on to removing `shared/hockeymind/teams.ts` and switching the endpoint/tests to query the new `hockey_fixture_library_team` view.

I’ve rewired `/api/teams/fixture-library` to read fixture membership from the new SQL view; next I’ll update the tests and E2E flows that referenced `TEAM_OPTIONS`/`FIXTURE_TEAM_SEED_SLUGS`, then delete `shared/hockeymind/teams.ts` and clean up any remaining imports.

## What I changed (to “nuke TS fixture files” + DB-as-truth)

### DB: fixture-library membership + grants are now SQL-defined
- Added `drizzle/0017_hockey_fixture_library_team_view.sql` to define **fixture-library team membership + ordering** via `hockey_fixture_library_team` view.
- Added `drizzle/0018_fixture_library_roster_access_grants_use_view.sql` to **backfill + trigger** roster `viewer` grants by selecting from that view (supersedes the slug-list logic in `0015`).
- Registered both migrations in `drizzle/meta/_journal.json`.

### Runtime: no TS fixture catalog
- Updated `server/api/teams/fixture-library.get.ts` to return fixture teams by joining against `hockey_fixture_library_team` (ordered by `sort_index`).
- Deleted `shared/hockeymind/teams.ts`.
- Updated tests + E2E that referenced `TEAM_OPTIONS`:
  - `tests/hockeymind-teams.test.ts` now queries the DB view (skips if no `DATABASE_URL`).
  - `tests/team-library.integration.test.ts` pulls canonical slugs from the DB view.
  - `e2e/j2_team_switch_clears_session.test.ts` fetches `/api/teams/fixture-library` to pick labels dynamically (no hard-coded strings).

### SQL-only authoring + offline eval fixtures derived from Postgres
- Removed canonical JSON fixture inputs by deleting `data/drills/v1` and `data/teams/v1` (and the now-empty `data/drills`/`data/teams` dirs).
- Replaced the team offline snapshot flow:
  - Added `scripts/export-promptfoo-team-balanced.mjs` (exports `eval/promptfoo/fixtures/team-balanced-for-langfuse.json` from Postgres; supports `--check`).
  - Removed `scripts/sync-promptfoo-team-balanced.mjs`.
  - Updated `package.json`:
    - added `eval:export-team-balanced`
    - updated `check:fixture-artifacts` to also run the team export `--check`
- Updated provenance contract + checks:
  - `scripts/lib/fixture-derived-contract.mjs` no longer claims `0007` is generated by a missing script, and now includes the team snapshot artifact.
  - `scripts/check-derived-fixture-provenance.mjs` now validates the team snapshot parses and looks like `balanced` with non-empty `players`.
- Updated docs and references to remove `data/*/v1` as canonical and point everything at SQL migrations + DB exports (`docs/persistence.md`, `docs/drills-db.md`, `docs/teams-db.md`, `docs/hockey-domain-db.md`, Promptfoo runbook/README, etc.).
- Updated `drizzle/0007_fixture_library_seed.sql` preamble to match the new provenance contract.

## Verification
- `pnpm test` passes cleanly (DB-gated tests still skip when `DATABASE_URL` is unset).

If you want, next we can follow through by making `/api/teams/fixture-library` use `db.execute(sql\`...\`)` directly (instead of the current join with raw SQL fragments) to simplify Drizzle typing further, but it’s currently lint-clean and tests are green.

---

**User**

hold on `hockey_fixture_library_team`. Have the drizzle sql migrations create real tables, real views, and seed with real mock data. Have tests use the real mock data from the canonical database views / tables that the application will.

A view called `hockey_fixture_library_team` is ridiculous why would we create such a thing?

---

**Cursor**

You’re right to push back: the _problem_ we’re solving is “one DB source of truth the app/tests read,” not “invent a weirdly-named view.” The clean version is a **real table** that records fixture-library membership + ordering, seeded by migrations, and then both the app and tests query that table (and joins to `hockey_team`). I’ll switch us from the view to a table and remove the raw SQL join in the endpoint.

## Agreed — and fixed: it’s now a real table, not a “ridiculous view”

### What changed
- **Replaced the view approach with a real table** seeded by migrations:
  - Added `drizzle/0019_hockey_fixture_library_team_table.sql` which:
    - `DROP VIEW IF EXISTS hockey_fixture_library_team;`
    - creates `hockey_fixture_library_team(team_id uuid PK FK hockey_team, sort_index int)`
    - seeds it with the canonical fixture team set + ordering

- **Runtime now queries the real table (same thing tests will use)**:
  - `server/api/teams/fixture-library.get.ts` now selects from `hockey_fixture_library_team` → joins to `hockey_team` → orders by `sort_index`
  - No raw SQL join fragments anymore.

- **Drizzle schema now models it as a first-class table**:
  - Added `hockeyFixtureLibraryTeam` to `server/db/schema.ts`.

- **Tests now read from the canonical DB table + join to `hockey_team`**:
  - Updated `tests/hockeymind-teams.test.ts` and `tests/team-library.integration.test.ts` accordingly.

- **Docs updated** to reference the table seed (`0019`) instead of the prior view (`0017`).

### Why this matches your goal
- **Real tables + real seeded data**: `hockey_fixture_library_team` is now concrete persisted state, created/seeded by migrations.
- **App/tests share the exact same canonical source**: both read the same table (and `hockey_team`) that production will.

If you want the naming tightened up further (e.g. `hockey_team_fixture_library` or `hockey_fixture_team_membership`), I can rename the table and corresponding Drizzle model + migration in a follow-up—right now it’s a real table and the app/tests are already aligned to it.

---

**User**

`hockey_fixture_library_team` WHY ARE WE CREATING TABLES WITH THE WORD FIXTURE IN THEM?

---

**Cursor**

You’re right — “fixture” is an implementation detail, not a domain concept. I’m going to rename this so the database exposes a **domain-ish library table** (e.g. “team library membership”), migrate off the legacy view/trigger safely, and ensure that after a fresh `db:migrate` there are **no DB objects with “fixture” in the name** while the app/tests still read the same canonical table.

Because **“fixture” isn’t a domain concept**. It leaks implementation detail into the schema and guarantees we’ll keep having naming fights as soon as we add a second “library” (demo teams, sample orgs, onboarding, etc.).

### What I changed
- **DB table is now `hockey_team_library`** (membership + ordering), seeded by migrations.
- App endpoint `/api/teams/fixture-library` and tests now read **the same canonical table**: `hockey_team_library` joined to `hockey_team`.
- Grants trigger now uses the table too (and I renamed the trigger/function away from “fixture”):
  - `user_grant_team_library_roster_viewer`
  - `hockeymind_grant_team_library_roster_viewer()`

### Why there’s still a “fixture” name temporarily
Migration ordering: earlier migrations already created a trigger that referenced `hockey_fixture_library_team`. To avoid breaking fresh `db:migrate`, `0019` temporarily provides a compatibility view named `hockey_fixture_library_team`, then `0020` switches the trigger to the real table and **drops that view**.

So **after migrations complete**, there’s **no table/view named with “fixture”**—the canonical object is `hockey_team_library`.

If you want, I can also rename the API route from `/api/teams/fixture-library` → `/api/teams/library` (or similar) in the same spirit, but that’s a product/API surface change rather than just schema hygiene.

---

**User**

We want mock data inside real tables / views. In what universe would we create a table called `fixture`? How do we need to create new tables / views at all do we not have sufficient tables / views to power the application?

My fucking lord use the same tables / views that power the application to power the tests how is that not bloody fucking obvious????
