# ERD Editor for Obsidian

Edit Entity-Relationship Diagrams inside your vault with the same editor that powers
[erd-editor.io](https://erd-editor.io), the VS Code extension and the IntelliJ plugin.

- `.erd` files show up in the file explorer and open in the diagram view.
- `.erd.json` files open in the diagram view from links. Obsidian reads their extension as
  `json`, so the file explorer and the quick switcher leave them out; with
  **Settings → Files and links → Detect all file extensions** on, the file explorer lists them
  and opens them in the diagram view too.
- Opening a file never rewrites it: it is saved once the diagram changes.
- A file the editor cannot read (a merge conflict, a cut-off sync) opens read-only and is left
  as it is, rather than being replaced by an empty diagram.
- Export (JSON, SQL, PNG) writes into the vault, where your attachments go.
- The editor follows Obsidian's light and dark theme.
- **Create new diagram** command, and **New ERD** in a folder's context menu.

Desktop only for now.

## This repository

The plugin's source lives in the [erd-editor](https://github.com/dineug/erd-editor) monorepo,
in `packages/obsidian-plugin`, and this repository carries the monorepo as the `erd-editor`
submodule. It holds what Obsidian reads from a plugin repository — this README, `manifest.json`
and `versions.json` (copies of the package's) — and the workflow that builds the plugin.

```sh
git clone --recurse-submodules https://github.com/dineug/erd-editor-obsidian-plugin.git
scripts/build.sh    # builds in the submodule; the plugin folder is erd-editor/packages/obsidian-plugin/dist
```

### Releasing

1. Bump `version` in the package's `manifest.json` (and `versions.json` when `minAppVersion`
   moves) in the monorepo.
2. Here, move the submodule to that commit and copy both files to the root:
   `cp erd-editor/packages/obsidian-plugin/{manifest,versions}.json .`
3. Push to `main`. The Build workflow checks the copies, builds the plugin and leaves a draft
   release tagged with the version, `main.js`, `manifest.json` and `styles.css` attached.
4. Publish the draft. The tag is the bare version (`1.2.3`, no `v`), which is what Obsidian
   looks for.
