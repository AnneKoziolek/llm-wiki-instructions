#!/usr/bin/env bash
# Install claude-mcse-rules hooks into a parent git repository.
#
# Usage (from the parent repo's root):
#   bash .claude/rules/mcse-rules/install-hooks.sh
#
# Installs each hook in `hooks/` as a relative symlink under
# `.git/hooks/<name>`. Refuses to overwrite an existing non-symlink hook
# unless --force is given. Refuses to replace an existing symlink that
# points elsewhere unless --force.
#
# Idempotent: re-running with the same hooks already in place is a no-op.

set -eu

force=false
if [ "${1:-}" = "--force" ] || [ "${1:-}" = "-f" ]; then
    force=true
fi

# Find the parent repo's .git directory (handles worktrees: .git can be a file).
git_dir=$(git rev-parse --git-common-dir 2>/dev/null || true)
if [ -z "$git_dir" ] || [ ! -d "$git_dir" ]; then
    printf 'error: not inside a git repository (run from the parent repo root).\n' >&2
    exit 1
fi

# Locate this script's hooks/ directory (the source of truth).
script_dir=$(cd "$(dirname "$0")" && pwd)
src_hooks_dir="$script_dir/hooks"
if [ ! -d "$src_hooks_dir" ]; then
    printf 'error: %s does not exist.\n' "$src_hooks_dir" >&2
    exit 1
fi

mkdir -p "$git_dir/hooks"

# Compute a relative path from $git_dir/hooks to $src_hooks_dir so the
# symlink survives the repo being moved. Falls back to absolute if `realpath
# --relative-to` is unavailable.
make_relative() {
    target=$1
    from=$2
    if realpath --relative-to="$from" "$target" 2>/dev/null; then
        return
    fi
    # Fallback: absolute path.
    realpath "$target" 2>/dev/null || printf '%s\n' "$target"
}

installed=0
skipped=0
for src in "$src_hooks_dir"/*; do
    [ -f "$src" ] || continue
    name=$(basename "$src")
    dst="$git_dir/hooks/$name"
    rel=$(make_relative "$src" "$git_dir/hooks")

    if [ -L "$dst" ]; then
        existing=$(readlink "$dst")
        if [ "$existing" = "$rel" ] || [ "$(readlink -f "$dst" 2>/dev/null)" = "$(readlink -f "$src" 2>/dev/null)" ]; then
            printf '  [ok]      %s already linked.\n' "$name"
            skipped=$((skipped + 1))
            continue
        fi
        if ! $force; then
            printf '  [skip]    %s is a symlink pointing elsewhere (%s). Re-run with --force.\n' "$name" "$existing"
            skipped=$((skipped + 1))
            continue
        fi
    elif [ -e "$dst" ]; then
        if ! $force; then
            printf '  [skip]    %s exists and is not a symlink. Re-run with --force to overwrite.\n' "$name"
            skipped=$((skipped + 1))
            continue
        fi
        # Back up the existing hook before overwriting.
        cp "$dst" "$dst.bak.$(stat -c '%Y' "$dst" 2>/dev/null || stat -f '%m' "$dst")"
        printf '  [backup]  %s -> %s.bak.<mtime>\n' "$name" "$name"
    fi

    ln -snf "$rel" "$dst"
    chmod +x "$src"
    printf '  [install] %s -> %s\n' "$name" "$rel"
    installed=$((installed + 1))
done

printf '\n%d installed, %d skipped.\n' "$installed" "$skipped"
