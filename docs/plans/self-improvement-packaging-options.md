# Self-Improvement Bundle: Packaging / Release Options

Ways to make installing the self-improvement bundle into other projects easier. Tradeoffs and how each option fits the [standalone-repository](.cursor/rules/standalone-repository.mdc) rule are noted.

## Current Constraint (Standalone-Repository Rule)

This repo’s rule says:

- Share with other projects **only via symlink** (e.g. `~/.cursor/skills` → this repo’s `.cursor/skills`).
- **No** install scripts or Makefile targets that **copy/sync/deploy** rules/skills/commands beyond that symlink.
- One documented approach; no multiple “modes” of installation.

So any **in-repo** install script or “copy bundle here” Makefile would require changing or relaxing that rule. Options **outside** this repo (separate package, separate tool repo) don’t conflict.

---

## Option 1: Documented Symlink (Allowed Today)

**What:** Document how to symlink this repo’s `.cursor/rules/meta`, `.cursor/skills/meta`, `.cursor/commands/meta`, `.cursor/agents/meta`, `.cursor/templates`, and optionally `docs/` (or specific docs) into another project.

**Pros:** No new tooling; one source of truth; pull updates by pulling this repo. Aligns with current rule.

**Cons:** User must clone this repo somewhere. Symlinking into another project’s `.cursor/` can overwrite or mix with that project’s own `meta/` unless we document “only symlink these subdirs” and possibly a layout (e.g. project keeps `.cursor/rules/` for project rules, symlink only `meta`). Docs and `docs/` paths: either symlink a `docs` subtree or copy docs once.

**Verdict:** Stays within the rule; improves on “copy by hand” by making updates trivial.

---

## Option 2: Install Script or Makefile in This Repo (Copy Bundle)

**What:** e.g. `./scripts/install-self-improvement.sh /path/to/other/project` or `make install-bundle DEST=/path/to/project` that copies the bundle (meta rules/skills/commands/agents, templates, selected docs) into the target’s `.cursor/` and `docs/`.

**Pros:** One command; no symlink; target project is self-contained and can edit the copied files.

**Cons:** Conflicts with standalone-repository rule (“no install scripts”, “no Makefile targets that copy/sync/deploy”). Would require a **rule change** (e.g. “one exception: install script for self-improvement bundle only”) or dropping the “no copy” part.

**Verdict:** Easiest for users who want a copy, but not allowed under the current rule unless we amend it.

**Implemented:** Option 2 is in place. The script `scripts/install-self-improvement.sh` copies the self-improvement bundle into a target project (interactive prompts, no symlinks). The standalone-repository rule was updated to allow this one install script. See [Self-Improvement Bundle](../self-improvement-bundle.md) and [INSTALL.md](../../INSTALL.md).

---

## Option 3: External Installer (Separate Repo or Package)

**What:** A **different** repo or package that fetches this repo (or a release artifact) and copies the bundle into the current directory. Examples:

- **npm/npx:** e.g. `npx @hutchic/cursor-self-improvement install` (package contains a small script that downloads the bundle or clones this repo and copies files).
- **Standalone script repo:** e.g. `cursor-self-improvement-install` repo with `install.sh` that `curl`/`git` this repo and copies the bundle.

**Pros:** One-command install; versioned (releases or npm tags); this repo stays “standalone” with no install script or copy Makefile.

**Cons:** Two things to maintain (this repo + installer repo or package). For npm: repo isn’t JS, so the package would be “wrapper + script” only.

**Verdict:** Compliant with the current rule; good if we want “one command” without changing this repo’s rule.

---

## Option 4: GitHub Release Tarball of the Bundle

**What:** On release, attach a tarball (e.g. `self-improvement-bundle-v1.0.tar.gz`) that contains only the bundle layout, e.g.:

```
.cursor/rules/meta/...
.cursor/skills/meta/...
.cursor/commands/meta/...
.cursor/agents/meta/...
.cursor/templates/...
docs/...
```

**Pros:** Versioned, single download; users can `curl -sL <url> | tar xz` or download and extract; no script in this repo. Can be produced by CI (e.g. `git archive` or a small script in `.github/` that runs only on release).

**Cons:** User (or an external installer) still has to extract into the right place; overlapping paths (e.g. existing `meta/`) need to be merged or documented. Creating the tarball could be a release job that doesn’t “install” from this repo’s Makefile, so it may still fit the rule if we define “release artifact” as documentation/distribution, not “install script.”

**Verdict:** Fits the rule if we don’t add a local “run this to install” target; improves repeatability and versioning.

---

## Option 5: Git Submodule in the Consumer Project

**What:** User adds this repo as a submodule (e.g. `vendor/cursor-meta` or `.cursor-meta`) and then either symlinks from submodule into their `.cursor/` and `docs/`, or runs a one-time copy (manual or their own script).

**Pros:** Updates via `git submodule update`; single clone of this repo.

**Cons:** Submodule workflow is heavy for some teams; user still must do symlink or copy; we don’t “install” from this repo, so rule is fine.

**Verdict:** Document as an option for “I want to track this repo and pull updates”; no change to this repo required.

---

## Option 6: Dedicated “Bundle” Repo

**What:** A second repo (e.g. `cursor-self-improvement-bundle`) that contains only the extracted bundle (flat `.cursor/...` and `docs/...`). Updated by a sync process (manual or CI) from this repo. Users clone or download that repo and copy/symlink into their project.

**Pros:** Clean “only the bundle” surface; no meta-repo clutter; could be the source for Option 3 or 4.

**Cons:** Duplication and sync discipline; two repos to maintain.

**Verdict:** Optional downstream; not required for Options 1–4.

---

## Recommendation Summary

| Goal | Option | Rule change? |
|------|--------|---------------|
| Easiest within current rule | **1. Documented symlink** | No |
| One-command copy install from this repo | **2. Install script/Makefile** | Yes (exception or relax “no copy”) |
| One-command install without changing this repo | **3. External installer** (npx or script repo) | No |
| Versioned, downloadable bundle | **4. Release tarball** | No (if we don’t add local install target) |
| “Track this repo and pull updates” | **5. Submodule** | No |
| Clean bundle-only surface | **6. Bundle repo** | No |

**Practical path:**

1. **Short term:** Improve **Option 1** in [self-improvement-bundle.md](../self-improvement-bundle.md): add exact symlink commands and a one-line “optional: symlink docs” so users can install and update with minimal steps.
2. **If we want one-command install without touching the rule:** Add **Option 4** (release tarball) and/or support **Option 3** (e.g. a small npm package or installer repo that uses the tarball or clone and copies into cwd).
3. **If we’re okay changing the rule:** Add **Option 2** (single install script or `make install-bundle`) and document it as the one supported “copy” method.

---

## Related

- [Standalone Repository rule](.cursor/rules/standalone-repository.mdc)
- [Self-Improvement Bundle](docs/self-improvement-bundle.md)
- [INSTALL.md](../../INSTALL.md)
