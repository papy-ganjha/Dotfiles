#!/usr/bin/env bash

# Install a modern `tmux-256color` terminfo into ~/.terminfo with the
# capabilities nvim needs to render fast inside tmux:
#   - Sync   : DEC mode 2026 synchronized output (atomic frame redraws)
#   - Tc/RGB : 24-bit true color
#   - Smulx  : extended underline styles (undercurl, dotted, dashed)
#   - Setulc : colored underlines (used by LSP diagnostics)
#
# The system-shipped tmux-256color on macOS (and some Linux distros) lacks
# these. Without Sync, nvim falls back to unbatched draws and heavy scroll
# inside tmux feels noticeably laggy. ~/.terminfo is read before
# /usr/share/terminfo, so this overrides without touching system files.
#
# Idempotent: skips if Sync is already present on the active entry.
# Reversal:    rm ~/.terminfo/74/tmux-256color

set -e

if ! command -v infocmp >/dev/null 2>&1 || ! command -v tic >/dev/null 2>&1; then
    echo "[terminfo] ncurses (infocmp/tic) not found, skipping" >&2
    exit 0
fi

if ! infocmp -x tmux-256color >/dev/null 2>&1; then
    echo "[terminfo] tmux-256color entry not present on this system, skipping" >&2
    exit 0
fi

if infocmp -x tmux-256color 2>/dev/null | tr ',' '\n' | grep -qE '^\s*Sync='; then
    echo "[terminfo] tmux-256color already has Sync cap, nothing to do"
    exit 0
fi

src="$(mktemp -t tmux-256color.XXXXXX.src)"
trap 'rm -f "$src"' EXIT

infocmp -x tmux-256color > "$src"

# Append the modern caps as a final comma-separated chunk. infocmp output
# always ends with a trailing comma + newline, so we strip and re-add.
{
    perl -0777 -i -pe 's/,\s*\z/,\n/' "$src"
    cat >> "$src" <<'CAPS'
	Tc, RGB, Sync=\E[?2026%?%p1%{1}%-%tl%eh%;, Smulx=\E[4:%p1%dm, Setulc=\E[58:2:%p1%{65536}%/%d:%p1%{256}%/%{255}%&%d:%p1%{255}%&%d%;m,
CAPS
}

tic -x "$src"

echo "[terminfo] installed modern tmux-256color to ~/.terminfo"
echo "[terminfo] restart tmux (tmux kill-server) for nvim to pick it up"
