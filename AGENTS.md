# erd-editor-obsidian-plugin

## Purpose

The repository Obsidian's community directory points at for the **ERD Editor** plugin. The plugin's source is not here: it is `packages/obsidian-plugin` in the erd-editor monorepo, which this repository carries as the `erd-editor` submodule. What stays here is what Obsidian reads from a plugin repository and the build that feeds its releases.

## Key Files

| File | Description |
| --- | --- |
| `erd-editor/` | git submodule, the whole monorepo; the plugin is `erd-editor/packages/obsidian-plugin` (see its `AGENTS.md`) |
| `manifest.json` | Copy of the package's. Obsidian reads it from `main` to learn the latest version |
| `versions.json` | Copy of the package's. Obsidian reads it when the latest version needs a newer app than the user runs |
| `README.md` | Shown on the plugin's page in Obsidian |
| `scripts/build.sh` | Checks both copies against the submodule, then builds the plugin in it |
| `.github/workflows/build.yml` | `scripts/build.sh`, the artifact, and on `main` a draft release |
| `package.json`, `pnpm-lock.yaml` | commitlint alone; the plugin's own dependencies live in the submodule |
| `commitlint.config.js` | Conventional Commits through `@commitlint/config-conventional`, `subject-case` off as in the monorepo |
| `.githooks/commit-msg` | Runs commitlint; `pnpm install` points git at `.githooks` through the `prepare` script |

## For AI Agents

### Working In This Directory

- **Check the submodule first.** An empty `erd-editor/` builds nothing: `git submodule update --init`. Change the plugin in the monorepo, then move the submodule here to that commit; a change made inside the submodule's checkout belongs in a monorepo commit.
- **`manifest.json` and `versions.json` are copies.** The package's files are the source; `scripts/build.sh` fails when these differ (`cp erd-editor/packages/obsidian-plugin/{manifest,versions}.json .`).
- **A release is a published GitHub release** whose tag is the bare manifest version (`1.2.3`, no `v`) with `main.js`, `manifest.json` and `styles.css` attached; Obsidian downloads exactly those. The Build workflow replaces the draft on every push to `main` and skips a version already released. Publishing the draft is manual.
- **The manifest `id` is `erd-editor`** and cannot change once the plugin is in the community directory; it may not contain `obsidian`.
- **Commits follow Conventional Commits**, checked on commit-msg: run `pnpm install` once in a fresh clone to install the hook. Subjects are capitalized; header and body lines stay within 100 characters (config-conventional's limits). The root install is separate from the submodule's: `scripts/build.sh` installs inside `erd-editor/`, and CI never installs the root.
- Nothing here is built into `main`: the plugin folder is `erd-editor/packages/obsidian-plugin/dist`, inside the submodule, and is never committed.

### Testing Requirements

`scripts/build.sh` is the gate. The plugin's checks run in the monorepo, where `pnpm --filter @dineug/erd-editor-obsidian-plugin smoke` drives a real Obsidian on macOS; run it from `erd-editor/` after `scripts/build.sh` to check the exact commit the submodule pins.
