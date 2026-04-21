#!/bin/bash
# Connect to a remote machine via mosh with clipboard relay.
# Run this on your LOCAL machine (the one you sit at).
#
# Usage: mosh-connect.sh [user@]hostname [extra-mosh-args...]
CLIPBOARD_PORT=2225
REMOTE="$1"
shift

if [ -z "$REMOTE" ]; then
    echo "Usage: mosh-connect.sh [user@]hostname [extra-mosh-args...]"
    exit 1
fi

SOCK="/tmp/clipboard-tunnel-$$"

cleanup() {
    kill "$LISTENER_PID" 2>/dev/null
    ssh -O exit -S "$SOCK" "$REMOTE" 2>/dev/null
}
trap cleanup EXIT

if nc -z localhost "$CLIPBOARD_PORT" 2>/dev/null; then
    echo "Port $CLIPBOARD_PORT already in use. Another mosh-connect session running?"
    exit 1
fi

(while true; do nc -l "$CLIPBOARD_PORT" | pbcopy; done) &
LISTENER_PID=$!

ssh -fN -M -S "$SOCK" -R "${CLIPBOARD_PORT}:localhost:${CLIPBOARD_PORT}" "$REMOTE"

mosh "$REMOTE" "$@"
