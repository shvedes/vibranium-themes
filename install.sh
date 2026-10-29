#!/usr/bin/env bash
# Install every Vibranium theme from this monorepo.
#
# Local checkout:
#   ./install.sh
#
# One-liner (after the repo is published):
#   curl -fsSL https://raw.githubusercontent.com/shvedes/vibranium-themes/main/install.sh | bash
#
# Destination defaults to ~/.config/vibranium/themes and can be overridden
# with VIBRANIUM_THEMES_DIR or the first positional argument.
set -euo pipefail

REPO_URL="${VIBRANIUM_REPO_URL:-https://github.com/shvedes/vibranium-themes.git}"
DEST="${VIBRANIUM_THEMES_DIR:-${1:-$HOME/.config/vibranium/themes}}"

TMP_REPO=""
cleanup() {
    if [ -n "$TMP_REPO" ] && [ -d "$TMP_REPO" ]; then
        rm -rf "$TMP_REPO"
    fi
}
trap cleanup EXIT

# Prefer a local checkout living next to this script.
SOURCE_DIR="${VIBRANIUM_SOURCE_DIR:-}"
if [ -z "$SOURCE_DIR" ] && [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
    candidate="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if compgen -G "$candidate"/*/theme.info >/dev/null; then
        SOURCE_DIR="$candidate"
    fi
fi

# Otherwise fetch the repository into a temporary directory.
if [ -z "$SOURCE_DIR" ]; then
    if ! command -v git >/dev/null 2>&1; then
        echo "git is required for the remote install flow" >&2
        exit 1
    fi
    TMP_REPO="$(mktemp -d)"
    echo "Fetching vibranium-themes..."
    git clone --depth 1 "$REPO_URL" "$TMP_REPO"
    SOURCE_DIR="$TMP_REPO"
fi

mkdir -p "$DEST"

count=0
for theme_dir in "$SOURCE_DIR"/*/; do
    [ -d "$theme_dir" ] || continue
    name="$(basename "$theme_dir")"
    case "$name" in .*) continue ;; esac

    [ -f "$theme_dir/theme.info" ] || continue

    src="${theme_dir%/}"
    rm -rf -- "$DEST/$name"
    cp -a -- "$src" "$DEST/$name"
    rm -f -- "$DEST/$name/install.sh"

    count=$((count + 1))
    printf 'Installed: %s\n' "$name"
done

printf 'Done: %d theme(s) installed into %s\n' "$count" "$DEST"
