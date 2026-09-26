#!/usr/bin/env bash
# Builds the plugin in the erd-editor submodule, after checking that the manifest Obsidian
# reads at this repository's root is the one the build ships.
set -euo pipefail

cd "$(dirname "$0")/.."
package=erd-editor/packages/obsidian-plugin

if [ ! -f "$package/manifest.json" ]; then
  echo "The erd-editor submodule is empty or predates the plugin." >&2
  echo "Run: git submodule update --init" >&2
  exit 1
fi

for file in manifest.json versions.json; do
  if ! cmp -s "$file" "$package/$file"; then
    echo "$file differs from $package/$file. Run: cp $package/$file ." >&2
    exit 1
  fi
done

cd erd-editor
pnpm install --frozen-lockfile
pnpm exec vp run --filter @dineug/erd-editor-obsidian-plugin --fail-if-no-match build

echo "Plugin folder: $package/dist"
